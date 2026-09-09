# Spec 009B: Sync Engine Base

## Status

`ready`

Contrato congelado em 9 de setembro de 2026. Os antigos blockers de teardown e TTL foram resolvidos explicitamente no `contract.md`.

## Dependência

Requer 009A implementada. A 009A foi entregue na `dev` com schema v2, `sync_collections`, migração v1 -> v2 preservando `sync_outbox`, codegen Drift atualizado e testes direcionados aprovados.

## Objetivo

Implementar um único motor de sincronização por contexto ativo, responsável por concorrência, lifecycle, checkpoints e execução ordenada de coleções. O motor não conhece widgets nem detalhes do Laravel.

A sincronização ocorre em rodadas finitas disparadas por eventos; conectividade disponível não implica conexão ou stream permanente com a API.

## Integração com 008B

Já existe `SyncLifecycle.stop(LocalContext context)`. A 009B deve fornecer a implementação real desse boundary; não cria lifecycle paralelo.

Antes de `DatabaseFactory.closeActive()`:

- novas rodadas daquele contexto devem ser bloqueadas imediatamente;
- execução ativa deve receber cancelamento/stop;
- requests pendentes devem ser canceladas quando possível;
- transação SQLite já iniciada deve chegar a commit ou rollback;
- o fechamento deve aguardar o término seguro por até 10 segundos;
- nenhuma Future atrasada pode continuar usando Drift após o close.

Se `stop()` falhar ou exceder 10 segundos, o banco/contexto permanece aberto e o teardown deve ser exposto como recuperável para retry; outro contexto não pode ser ativado por cima dele.

Kill/crash abrupto pelo sistema operacional não depende de `stop()`: a recuperação ocorre por transações, último checkpoint seguro e TTL do lock.

## Concorrência

A arquitetura canônica exige:

1. mutex em memória para o mesmo isolate;
2. lock persistido para proteger execuções em isolates/processos distintos (ex.: foreground e worker);
3. owner identificável;
4. TTL de 2 minutos;
5. heartbeat a cada 30 segundos, renovando a expiração para dois minutos à frente;
6. takeover atômico somente após `expires_at <= agora`;
7. renew/release condicionados ao `owner_id`;
8. liberação em `finally` em encerramentos controlados.

A tabela `sync_locks` pertence à 009B e deve ser adicionada por migração não destrutiva posterior à 009A. Se o baseline continuar em schema v2, a versão alvo é v3.

Se uma execução perder ownership do lock, deve abortar antes de persistir a próxima página ou avançar cursor/checkpoint.

## Execução

O engine executa coleções registradas em ordem. Cada coleção controla seu protocolo remoto, mas o engine fornece:

- exclusão mútua;
- estado global reativo;
- cancelamento/lifecycle;
- leitura/escrita segura de `sync_collections`;
- gatilhos manuais e automáticos;
- cooldown para gatilhos de `resumed` conforme configuração vigente.

## Checkpoint

O engine não promove cursor/checkpoint antes de a coleção confirmar persistência local da página. Falha parcial mantém o último estado seguro e permite reprocessamento.

## Gatilhos

- startup autenticado;
- pull-to-refresh;
- `resumed` com throttling;
- retorno de conectividade quando houver health check real;
- background apenas como auxílio.

Refresh manual não é bloqueado pelo cooldown de `resumed`.

## Fora de escopo

- mapping/protocolo específico de produtos/dashboard (009C);
- outbox de vendas e confirmação remota de operações locais (010);
- background como garantia de entrega;
- conexão permanente/stream contínuo com a API.

## Critérios de aceite

- nunca há duas execuções proprietárias alterando checkpoints ao mesmo tempo no mesmo contexto;
- lock abandonado é recuperável sem apagar dados;
- lock usa TTL de 2 min e heartbeat de 30 s;
- takeover ocorre apenas após expiração e de forma atômica;
- renew/release validam `owner_id`;
- perda de ownership aborta a execução antes de nova persistência/checkpoint;
- `stop(context)` impede novos runs antes de aguardar o run ativo;
- transação local em andamento termina em commit/rollback antes do fechamento controlado;
- timeout/falha do stop em 10 s preserva banco/contexto e permite retry;
- lock é liberado em sucesso, falha e cancelamento quando o processo permanece vivo;
- crash abrupto é recuperável por transação + checkpoint + TTL;
- checkpoint não avança em falha parcial;
- cooldown não impede refresh manual;
- testes cobrem concorrência, heartbeat, stale takeover, ownership, `finally`, stop, timeout e cancelamento.
