# Spec 009A — Revisão de abertura

## Status

`DONE`

## Auditoria

O backend `dev` @ `4ef4b3ee6374848ff903ce1f467daeff0975b005` confirmou o payload de produtos, tombstones e o snapshot de dashboard. O baseline local confirmado é o v1 deixado pela 008B.

A versão antiga da spec foi corrigida para não instalar Drift novamente, não criar outro `AppDatabase` e não tratar a outbox como inexistente.

## Decisões

- catálogo relacional em `categories` + `products`;
- remoção remota representada por `products.deleted_at`;
- dashboard persistido como snapshot composto, evitando normalização prematura de dezenas de estruturas;
- checkpoints separados em `sync_collections`;
- migração destrutiva proibida.

## Gate

Contrato `FROZEN`. Implementação entregue e revalidada; consulte `validation-result.md`.

## Veredito

`passed` — schema, preservação da outbox e migrações continuam verdes no gate atual.
