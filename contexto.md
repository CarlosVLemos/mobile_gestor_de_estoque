# Contexto do Projeto

Este arquivo é um mapa rápido do estado atual do Arara-Gastos Mobile. Ele não substitui as fontes canônicas em `para mobile/` nem os contratos congelados em `docs/specs/`.

Use junto com `tree.txt`:

- `tree.txt` = índice bruto da estrutura;
- `contexto.md` = fotografia curta do estado, caminho crítico e decisões recentes;
- `para mobile/00-contexto-operacional.md` = porta de entrada canônica;
- `para mobile/06-registro-decisoes.md` = decisões arquiteturais aceitas;
- `docs/specs/<spec>/contract.md` = contrato congelado da entrega.

## Estado atual — 9 de setembro de 2026

A base Flutter, shell e arquitetura por feature/camada estão materializadas. O caminho estrutural relevante está assim:

```text
007  Core de rede                         ✅ entregue
008  Sessão/autenticação                  ✅ entregue
008B Contexto/isolamento user + tenant    ✅ entregue
009A Drift/schema inicial                 ✅ entregue e testado
009B Sync Engine Base                     🟦 contrato FROZEN / pronto para implementar
009C Sync de leitura catálogo/dashboard   ⏭ depende da 009B
010  Outbox + vendas                      ⏭ posterior
```

### 009A entregue

A `dev` possui `AppDatabase` schema v2 com migração não destrutiva a partir do v1. A `sync_outbox` da 008B é preservada e foram adicionadas:

- `categories`;
- `products`;
- `dashboard_snapshots`;
- `sync_collections`.

O Drift gerado foi atualizado. Os testes direcionados de banco/migração e lifecycle contextual foram executados em 9 de setembro de 2026 com **9 testes aprovados**. A correção local de conflito de import nos testes usa `package:drift/drift.dart hide isNull`.

### 009B pronta para implementação

Os antigos blockers B1 (teardown) e B2 (TTL do lock) foram decididos e registrados no contrato da 009B.

A sincronização deve ser entendida como **rodadas finitas disparadas por eventos**, não como uma conexão permanente com a API. Gatilhos previstos incluem startup autenticado, pull-to-refresh, `resumed` com throttling e retorno de conectividade após health check. Background é apoio, nunca garantia.

O `SyncEngine` coordena concorrência, lifecycle e checkpoints. O protocolo específico de produtos/dashboard pertence à 009C. Envio confiável de operações locais, como vendas, pertence à outbox/Spec 010.

## Decisões congeladas da 009B

### Teardown controlado

`SyncLifecycle.stop(context)` é usado quando o aplicativo controla o encerramento do contexto, por exemplo logout, expiração ou troca de contexto.

Fluxo aprovado:

1. `stop(context)` bloqueia imediatamente novos runs daquele contexto;
2. a execução ativa recebe cancelamento;
3. requests HTTP pendentes são canceladas quando possível;
4. uma transação SQLite já iniciada deve chegar a commit ou rollback, nunca ser interrompida à força;
5. o engine aguarda um ponto seguro em que nenhuma Future atrasada possa continuar usando Drift;
6. o limite para o término seguro é **10 segundos**.

Se o stop concluir, o teardown pode seguir para fechar o banco, limpar cache contextual e invalidar estado.

Se o stop falhar ou exceder 10 segundos:

- o banco NÃO é fechado;
- o cache NÃO é limpo;
- o contexto NÃO é invalidado como concluído;
- logout/teardown não deve ser apresentado como sucesso;
- a UI deve permitir retry;
- outro contexto não pode ser ativado por cima do contexto ainda em teardown.

A prioridade é consistência local, mesmo que um encerramento excepcional demore mais para o usuário.

### Kill/crash abrupto

Android/iOS podem matar o processo sem executar `stop()` ou `finally`. Esse caso é coberto por mecanismos de recuperação, não pelo lifecycle controlado:

- transações SQLite garantem commit ou rollback;
- cursor/checkpoint permanece no último estado confirmado;
- coleções devem tolerar reprocessamento seguro;
- lock órfão é recuperado pelo TTL.

Ao reabrir, a sincronização parte do último ponto local seguro.

### Lock persistido

A 009B adicionará `sync_locks` por migração não destrutiva posterior à 009A. Se o schema continuar v2 no início da implementação, a versão alvo é v3.

Regras aprovadas:

- mutex em memória para o mesmo isolate;
- lock persistido no banco contextual para isolates/processos distintos;
- `owner_id`, `acquired_at` e `expires_at`;
- TTL de **2 minutos**;
- heartbeat a cada **30 segundos**;
- heartbeat renova `expires_at` para dois minutos à frente;
- takeover somente quando `expires_at <= agora`;
- aquisição/takeover devem ser atômicos;
- renew e release validam `owner_id`;
- uma execução nunca libera ou renova o lock de outra;
- se perder ownership, a execução aborta antes de persistir a próxima página ou avançar checkpoint;
- liberação normal ocorre em `finally`.

Crash pode impedir `finally`; nesse caso o TTL torna o lock recuperável.

## Checkpoints e segurança da sync

A regra central é:

```text
buscar dados
   ↓
aplicar em transação local
   ↓
COMMIT confirmado
   ↓
só então promover cursor/checkpoint
```

Falha parcial mantém o último estado seguro. O app não deve registrar uma página como sincronizada antes de sua persistência local ter sido confirmada.

Nunca devem existir duas execuções proprietárias capazes de alterar checkpoints ao mesmo tempo no mesmo contexto.

## Arquitetura obrigatória

Fluxo padrão:

```text
Page -> Controller -> UseCase -> Repository -> DAO/API
```

Regras essenciais:

- `presentation` não acessa Dio ou Drift diretamente;
- `application` não conhece Dio, Drift, JSON ou widgets;
- `domain` não conhece Flutter, transporte ou persistência;
- UI lê estado local no modelo local-first;
- servidor permanece soberano para autorização, estoque e confirmação remota;
- operação offline pendente nunca é apresentada como confirmada;
- dados de usuários/tenants diferentes nunca compartilham contexto local indevidamente;
- falha de migração não autoriza reset/apagamento de banco ou outbox.

## Banco e contexto local

O banco operacional é Drift + SQLite e é fisicamente separado por `userId + tenantId`.

A 008B fornece `DatabaseFactory`, lifecycle de contexto e `SyncLifecycle` como boundary. A 009B deve implementar esse boundary existente, não criar um lifecycle paralelo.

O banco local não é cache descartável: pode conter estado operacional e pendências que precisam sobreviver a logout, falhas e atualizações.

## Leitura e escrita remota

É útil separar os dois sentidos:

```text
Backend -> mobile
pull/sync de leitura
produtos, categorias, dashboard...
009B coordena / 009C implementa protocolos específicos

mobile -> Backend
operações locais como venda
outbox e reconciliação
Spec 010
```

Ter internet apenas permite disparar/tentar rodadas remotas. Não existe pressuposto de stream contínuo aberto com a API.

## UI local-first

Estados relevantes incluem:

- initial;
- loading;
- ready;
- refreshing;
- empty;
- offline;
- restricted;
- syncing;
- failure.

Dados locais podem continuar visíveis durante refresh ou falha. `price = null` pode representar restrição válida e não erro de carregamento.

## Áreas principais do repositório

- `lib/app/`: bootstrap, roteamento, shell, tema e integração global;
- `lib/core/network/`: Dio, interceptors e fronteira HTTP;
- `lib/core/database/`: Drift, contexto, factory, migrações e purge;
- `lib/core/sync/`: lifecycle e futura implementação do SyncEngine;
- `lib/features/auth/`: sessão/autenticação;
- `lib/features/catalog/`: catálogo;
- `lib/features/dashboard/`: painel;
- `lib/features/sales/`: fluxo de vendas, ainda sem outbox real completa;
- `docs/specs/`: histórico e contratos das specs;
- `para mobile/`: documentação operacional e decisões canônicas;
- `test/`: testes automatizados.

## Próximo caminho crítico

1. implementar 009B conforme `docs/specs/009b-sync-engine-base/contract.md` FROZEN;
2. validar concorrência, heartbeat, stale takeover, ownership, cancelamento e teardown;
3. implementar 009C em cima da engine pronta;
4. avançar para 010/outbox e protocolo real de vendas;
5. release/VPS/APK e smoke E2E.

## Regras de trabalho

`AGENTS.md` continua obrigatório. Para mudanças CRITICAL (auth, tenancy, Drift/migração, sync, outbox/vendas), contrato explícito e gate de validação são obrigatórios.

Nenhum agente executa testes, análise, formatação, build ou processo persistente sem autorização explícita do usuário no contexto atual.

## Observação final

Este arquivo resume o estado para navegação rápida. Em conflito, prevalecem as fontes canônicas definidas em `AGENTS.md`, especialmente decisões aceitas em `para mobile/06-registro-decisoes.md` e contratos `FROZEN` das specs.
