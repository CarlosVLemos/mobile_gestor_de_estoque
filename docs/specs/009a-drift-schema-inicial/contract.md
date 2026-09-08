# Contrato 009A — Evolução do banco local

## Status

`FROZEN`

Auditado em 8 de setembro de 2026 contra:

- mobile `dev`: baseline 008B com `schemaVersion = 1` e `sync_outbox`;
- backend `CarlosVLemos/gestor_de_estoque` `dev` @ `4ef4b3ee6374848ff903ce1f467daeff0975b005`.

## Fronteiras congeladas

1. O banco continua físico por `userId + tenantId` (MOB-017).
2. A evolução parte do schema v1; `sync_outbox` e seu conteúdo são intocáveis pela 009A.
3. Se v1 ainda for a versão vigente na implementação, a versão alvo é v2.
4. A 009A cria `categories`, `products`, `dashboard_snapshots` e `sync_collections`.
5. Produto suporta `price = null`, categoria nullable, imagem nullable, timestamp remoto nullable e tombstone local por `deleted_at`.
6. Dashboard é persistido como snapshot composto (`payload_json`) mais metadados indexáveis; JSON não atravessa a camada `data`.
7. `sync_collections` guarda cursor/checkpoint por coleção; cursor só poderá avançar após persistência local segura na 009B/009C.
8. Nenhum endpoint, SyncEngine ou outbox de vendas é implementado nesta spec.

Mudança de tabela, chave, migração ou ownership exige Change Request.
