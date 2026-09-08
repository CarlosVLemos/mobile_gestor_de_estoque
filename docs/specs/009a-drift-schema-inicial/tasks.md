# Tasks — Spec 009A

- [ ] Confirmar no início da execução que o baseline ainda é `schemaVersion = 1`.
- [ ] Evoluir o `AppDatabase` existente; não criar banco paralelo.
- [ ] Criar tabelas `categories`, `products`, `dashboard_snapshots` e `sync_collections` conforme `contract.md`.
- [ ] Incrementar a versão para v2 se o baseline continuar em v1.
- [ ] Implementar `MigrationStrategy` v1 -> v2 preservando `sync_outbox` e dados existentes.
- [ ] Ativar/testar foreign keys para `products.category_id` com `ON DELETE SET NULL`.
- [ ] Adicionar DAOs/boundaries locais sem expor Drift fora da camada `data/core database`.
- [ ] Agrupar alterações de schema antes de codegen.
- [ ] Criar teste de banco novo.
- [ ] Criar teste real de upgrade v1 -> v2 com linha pendente em `sync_outbox`.
- [ ] Testar `price = null`, tombstone, dashboard snapshot e `sync_collections`.
- [ ] Não implementar 009B, 009C ou 010.
