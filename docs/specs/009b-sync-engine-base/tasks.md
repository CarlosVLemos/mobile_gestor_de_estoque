# Tasks — Spec 009B

Status: `DONE / VALIDATED`

## Pré-gate

- [x] Resolver B1 (falha/timeout de `SyncLifecycle.stop`).
- [x] Resolver B2 (TTL/renovação/takeover de `sync_locks`).
- [x] Congelar `contract.md`.
- [x] Confirmar 009A implementada e schema vigente em v2.

## Implementação

- [x] Adicionar `sync_locks` por migração não destrutiva v2 → v3.
- [x] Implementar mutex intra-isolate.
- [x] Implementar lock persistido com `owner_id`, TTL de 2 min e stale recovery.
- [x] Implementar heartbeat de 30 s com renovação condicionada ao owner.
- [x] Implementar takeover atômico somente após expiração.
- [x] Implementar `SyncEngine` e estado reativo.
- [x] Implementar `SyncLifecycle.stop(context)` real integrado ao engine.
- [x] Fazer `stop()` bloquear novos runs antes de aguardar o run ativo.
- [x] Cancelar requests HTTP pendentes quando possível.
- [x] Não interromper transação SQLite à força; aguardar commit/rollback.
- [x] Implementar timeout de 10 s para término seguro do `stop()`.
- [x] Em timeout/falha do stop, manter banco/contexto abertos e expor retry; não ativar outro contexto por cima.
- [x] Abortar execução que perder ownership antes de nova persistência/checkpoint.
- [x] Garantir release condicionado ao owner e liberação em `finally`.
- [x] Implementar checkpoint seguro via `sync_collections`.
- [x] Garantir recuperação após kill/crash via transação + checkpoint + TTL, sem depender de `stop()`.
- [x] Implementar gatilho `resumed` com throttling e refresh manual sem cooldown.
- [x] Escrever testes de concorrência, heartbeat, stale takeover, ownership, `finally`, cancelamento, timeout e teardown.
- [x] Preservar o escopo: mappers/protocolo e outbox foram implementados apenas pelas Specs 009C/010.

O gate atual adicionou cobertura direta de startup/cooldown/manual e terminou com 12 testes do engine aprovados.
