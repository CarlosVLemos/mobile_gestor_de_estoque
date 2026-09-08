# Contrato 009B — Sync Engine e lifecycle

## Status

`BLOCKED / DRAFT`

## Fronteiras já definidas

- 009B implementa o `SyncLifecycle` existente da 008B.
- Um engine pode escrever checkpoints/dados por vez em cada contexto.
- Há mutex em memória e lock persistido com `owner_id`, `acquired_at` e `expires_at`.
- O lock persistido vive no mesmo banco contextual e exige migração não destrutiva após a 009A.
- Toda aquisição possui liberação em `finally`.
- Cursor/checkpoint só avança após persistência local confirmada.
- `stop(context)` precisa impedir novas execuções antes de aguardar a execução atual.

## Blockers para FROZEN

### B1 — política de falha do teardown

A 008B registra que `SyncLifecycle.stop()`, `database.close()` ou cache clear podem lançar. Antes de implementar engine real é necessário escolher explicitamente:

- timeout/cancelamento da execução ativa;
- comportamento do logout se `stop()` não concluir;
- se o banco permanece aberto em falha de stop;
- estado de sessão/UX a expor para retry.

Não é seguro inventar isso durante a implementação.

### B2 — TTL do lock persistido

A arquitetura exige TTL, mas não define duração nem renovação. É necessário decidir:

- TTL inicial;
- se existe heartbeat/renovação;
- regra de takeover de lock expirado.

Até B1 e B2 serem aprovados, este contrato não pode ser congelado.
