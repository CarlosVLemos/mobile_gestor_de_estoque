# Tasks — Spec 009B

## Pré-gate

- [x] Resolver B1 (falha/timeout de `SyncLifecycle.stop`).
- [x] Resolver B2 (TTL/renovação/takeover de `sync_locks`).
- [x] Congelar `contract.md`.
- [x] Confirmar 009A implementada e schema vigente em v2.

## Implementação

- [ ] Adicionar `sync_locks` por migração não destrutiva; se o baseline continuar em v2, migrar para v3.
- [ ] Implementar mutex intra-isolate.
- [ ] Implementar lock persistido com `owner_id`, TTL de 2 min e stale recovery.
- [ ] Implementar heartbeat de 30 s com renovação condicionada ao owner.
- [ ] Implementar takeover atômico somente após expiração.
- [ ] Implementar `SyncEngine` e estado reativo.
- [ ] Implementar `SyncLifecycle.stop(context)` real integrado ao engine.
- [ ] Fazer `stop()` bloquear novos runs antes de aguardar o run ativo.
- [ ] Cancelar requests HTTP pendentes quando possível.
- [ ] Não interromper transação SQLite à força; aguardar commit/rollback.
- [ ] Implementar timeout de 10 s para término seguro do `stop()`.
- [ ] Em timeout/falha do stop, manter banco/contexto abertos e expor retry; não ativar outro contexto por cima.
- [ ] Abortar execução que perder ownership antes de nova persistência/checkpoint.
- [ ] Garantir release condicionado ao owner e liberação em `finally`.
- [ ] Implementar checkpoint seguro via `sync_collections`.
- [ ] Garantir recuperação após kill/crash via transação + checkpoint + TTL, sem depender de `stop()`.
- [ ] Implementar gatilho `resumed` com throttling e refresh manual sem cooldown.
- [ ] Escrever testes de concorrência, heartbeat, stale takeover, ownership, `finally`, cancelamento, timeout e teardown.
- [ ] Não implementar mappers/protocolo de catálogo/dashboard nem outbox de vendas.
