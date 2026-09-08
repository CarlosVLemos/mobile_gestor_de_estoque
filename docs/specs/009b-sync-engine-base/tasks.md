# Tasks — Spec 009B

## Pré-gate

- [ ] Resolver B1 (falha/timeout de `SyncLifecycle.stop`).
- [ ] Resolver B2 (TTL/renovação/takeover de `sync_locks`).
- [ ] Congelar `contract.md`.
- [ ] Confirmar 009A implementada e schema vigente.

## Implementação futura

- [ ] Adicionar `sync_locks` por migração não destrutiva.
- [ ] Implementar mutex intra-isolate.
- [ ] Implementar lock persistido com owner e stale recovery.
- [ ] Implementar `SyncEngine` e estado reativo.
- [ ] Implementar `SyncLifecycle.stop(context)` real integrado ao engine.
- [ ] Garantir que stop bloqueie novos runs antes de aguardar o run ativo.
- [ ] Implementar checkpoint seguro via `sync_collections`.
- [ ] Implementar gatilho `resumed` com política aprovada e refresh manual sem cooldown.
- [ ] Escrever testes de concorrência, finally, stale lock, cancelamento e teardown.
- [ ] Não implementar mappers de catálogo/dashboard nem outbox de vendas.
