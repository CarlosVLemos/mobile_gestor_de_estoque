# Contrato 009B — Sync Engine e lifecycle

## Status

`FROZEN`

Aprovado em 9 de setembro de 2026 após a entrega da 009A e o fechamento explícito das políticas de teardown e lock persistido.

## Dependências e fronteiras

- A 009A está entregue e fornece o `AppDatabase` contextual, `sync_collections` e schema v2.
- A 009B implementa o `SyncLifecycle` existente da 008B; não cria lifecycle paralelo.
- Um único engine pode alterar dados/checkpoints por vez em cada contexto ativo.
- O engine coordena rodadas finitas de sincronização. Estar online não significa manter conexão/stream permanente com a API.
- Pull de dados remotos pertence ao motor/coleções de leitura. Envio confiável de operações locais, como vendas, continua pertencendo à outbox/Spec 010.
- Cursor/checkpoint só avança após persistência local confirmada.

## B1 — política aprovada de teardown

`SyncLifecycle.stop(context)` é o mecanismo de encerramento controlado do contexto. Ele não é garantia para kill/crash abrupto do processo pelo sistema operacional.

Ao iniciar `stop(context)`:

1. o contexto entra imediatamente em estado de stopping e novas rodadas/gatilhos daquele contexto são recusados;
2. a execução ativa recebe solicitação de cancelamento;
3. requests HTTP pendentes devem ser canceladas quando o transporte permitir;
4. uma transação SQLite já iniciada não é interrompida à força: ela deve terminar em commit ou rollback;
5. o engine só considera a execução encerrada ao atingir um ponto seguro, sem Future capaz de continuar usando Drift depois do fechamento;
6. `stop(context)` aguarda no máximo 10 segundos pelo término seguro.

### Sucesso do stop

Somente depois de `stop(context)` concluir com sucesso o teardown pode seguir para:

1. `DatabaseFactory.closeActive()`;
2. limpeza do cache contextual;
3. invalidação do estado contextual.

### Timeout ou falha do stop

Se o término seguro não ocorrer em até 10 segundos, ou se `stop(context)` falhar:

- o banco contextual NÃO é fechado;
- o cache contextual NÃO é limpo;
- o contexto local NÃO é invalidado como se o teardown tivesse concluído;
- o logout/teardown não é reportado como concluído com sucesso;
- a UI deve expor estado recuperável e permitir retry;
- outro contexto não pode ser ativado por cima do contexto cujo teardown ainda não foi concluído.

A prioridade é preservar consistência local mesmo que isso torne o encerramento da sessão temporariamente mais lento.

## Encerramento abrupto do processo

Android/iOS podem matar o processo sem oportunidade de executar `stop()` ou `finally`.

A recuperação desse cenário não depende do teardown controlado. Ela depende de:

- transações SQLite para garantir commit ou rollback;
- checkpoint/cursor mantido no último ponto confirmado;
- operações idempotentes/reprocessáveis por coleção;
- TTL do lock persistido para recuperar lock órfão.

Ao reabrir o app, uma nova rodada parte do último estado local seguro.

## B2 — política aprovada de lock persistido

A 009B adiciona `sync_locks` ao mesmo banco físico do contexto, por migração não destrutiva posterior à 009A. Se o schema vigente continuar v2 no início da implementação, a migração alvo é v3.

O lock persistido contém, no mínimo:

- `name`;
- `owner_id`;
- `acquired_at`;
- `expires_at`.

Para a 009B existe um lock global de sincronização dentro de cada banco contextual.

### Aquisição

- existe também mutex em memória para concorrência dentro do mesmo isolate;
- aquisição do lock persistido deve ser atômica;
- um lock válido pertencente a outro owner impede nova execução concorrente;
- toda aquisição normal possui liberação em `finally`.

### TTL e heartbeat

- TTL inicial/renovado: **2 minutos**;
- heartbeat: **a cada 30 segundos** enquanto a execução permanecer ativa e ainda for proprietária;
- cada heartbeat renova `expires_at` para dois minutos à frente;
- tempos persistidos devem usar representação temporal consistente (UTC/instante), sem depender de timezone de apresentação.

### Takeover

Outra execução só pode assumir o lock quando `expires_at <= agora`.

O takeover deve ser atômico e registrar novo `owner_id`, `acquired_at` e `expires_at`.

Renovação e liberação devem ser condicionadas ao `owner_id`. Uma execução nunca pode renovar ou liberar o lock de outra.

Se uma execução detectar que perdeu ownership, ela perde o direito de continuar a sincronização: deve abortar antes de aplicar a próxima página local ou avançar cursor/checkpoint.

## Execução e checkpoints

O engine executa coleções registradas em ordem.

Para cada página/unidade persistível:

1. buscar/processar dados conforme protocolo da coleção;
2. aplicar mudanças em transação local;
3. concluir commit;
4. somente depois persistir/promover o estado seguro de cursor/checkpoint previsto pela coleção.

Falha parcial mantém o último estado confirmado e deve permitir reprocessamento seguro.

## Gatilhos

Rodadas podem ser solicitadas por:

- startup autenticado;
- pull-to-refresh;
- retorno do app a `resumed`, com throttling;
- retorno de conectividade após health check real;
- background apenas como apoio.

Refresh manual não deve ser bloqueado pelo cooldown de `resumed`. A duração exata desse cooldown é uma política configurável de gatilho e não altera as garantias de consistência deste contrato.

## Fora de escopo

- mapping/protocolo específico de produtos e dashboard (009C);
- outbox e confirmação de vendas (010);
- background como garantia de entrega;
- conexão permanente/stream contínuo com a API.

## Critérios de aceite

- nunca existem duas execuções proprietárias capazes de alterar checkpoints simultaneamente no mesmo contexto;
- `stop(context)` bloqueia novos runs antes de aguardar o run ativo;
- transação local em andamento chega a commit/rollback antes do fechamento controlado;
- stop bem-sucedido garante que nenhuma Future atrasada use Drift após `closeActive()`;
- timeout/falha de stop em 10 s preserva banco/contexto e produz estado recuperável;
- lock usa TTL de 2 min e heartbeat de 30 s;
- stale lock só sofre takeover após expiração e de forma atômica;
- renew/release validam `owner_id`;
- perda de ownership aborta a execução antes de nova persistência/checkpoint;
- lock é liberado em sucesso, falha e cancelamento quando o processo continua vivo;
- crash abrupto é recuperável por transação + checkpoint + TTL, sem reset do banco;
- checkpoint não avança em falha parcial;
- testes cobrem concorrência, heartbeat, stale takeover, ownership, `finally`, stop, timeout e cancelamento.
