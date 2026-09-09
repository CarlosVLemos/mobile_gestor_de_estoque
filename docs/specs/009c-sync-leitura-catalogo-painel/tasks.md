# Tasks — Spec 009C

## Pré-gate

- [x] 009A implementada e validada.
- [x] 009B implementada e validada.

## Produtos

- [x] Implementar DTO remoto conforme contrato congelado.
- [x] Implementar `ProductSyncCollection` usando `per_page/cursor/checkpoint`.
- [x] Aplicar tombstones e upserts na mesma transação da página.
- [x] Promover cursor/checkpoint somente após commit local.
- [x] Encerrar rodada com `target_checkpoint` quando `has_more = false`.
- [x] Tratar cursor 422 sem inventar recuperação destrutiva.
- [x] Implementar repository/DAO Drift e stream local para catálogo.

## Dashboard

- [x] Implementar DTO/mappers do snapshot real.
- [x] Não enviar/depender de `category_id` enquanto o backend auditado não o aplica.
- [x] Persistir snapshot atomicamente por `scope_key`.
- [x] Registrar `revision`/metadados e manter snapshot anterior em falha remota.
- [x] Implementar repository/stream local para dashboard.

## Apresentação

- [x] Trocar fixtures por casos de uso/repositories locais.
- [x] Manter dados durante refreshing/offline.
- [x] Tratar `price = null` e métricas financeiras nulas.
- [x] Garantir descarte seguro de streams na troca/logout de contexto.

- [x] Não implementar outbox de vendas.
