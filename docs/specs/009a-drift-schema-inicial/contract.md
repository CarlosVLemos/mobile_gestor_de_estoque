# Contrato de evolução 009A

## Status

`DRAFT` — não congelado.

## Premissas já congeladas

- O banco existente é físico por usuário + tenant (MOB-017).
- O schema v1 contém `sync_outbox` e deve ser preservado (MOB-005 e MOB-012).
- A 009A evolui o `AppDatabase` existente; não adiciona um banco paralelo.

## Decisões ainda pendentes

Os tipos remotos, chaves, cursores e colunas definitivas das tabelas novas
dependem de auditoria contratual antes da implementação. Este documento não
autoriza alterar endpoints, sync ou outbox da Spec 010.
