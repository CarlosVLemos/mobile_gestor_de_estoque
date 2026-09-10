# Tasks — Spec 009A

Status: `DONE / VALIDATED`

- [x] Confirmar no início da execução que o baseline era `schemaVersion = 1`.
- [x] Evoluir o `AppDatabase` existente; não criar banco paralelo.
- [x] Criar tabelas `categories`, `products`, `dashboard_snapshots` e `sync_collections` conforme `contract.md`.
- [x] Incrementar a versão para v2 a partir do baseline v1.
- [x] Implementar `MigrationStrategy` v1 -> v2 preservando `sync_outbox` e dados existentes.
- [x] Ativar/testar foreign keys para `products.category_id` com `ON DELETE SET NULL`.
- [x] Adicionar DAOs/boundaries locais sem expor Drift fora da camada `data/core database`.
- [x] Agrupar alterações de schema antes do codegen da entrega original.
- [x] Criar teste de banco novo.
- [x] Criar teste real de upgrade v1 -> v2 com linha pendente em `sync_outbox`.
- [x] Testar `price = null`, tombstone, dashboard snapshot e `sync_collections`.
- [x] Preservar o escopo: 009B, 009C e 010 foram implementadas apenas por suas Specs posteriores.

O schema seguiu evoluindo até v4. O gate de 2026-09-09 revalidou os caminhos v1/v2/v3 → v4; consulte `validation-result.md`.
