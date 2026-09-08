# Tasks — Spec 009C

## Pré-gate

- [ ] 009A implementada e validada.
- [ ] 009B implementada e validada.

## Produtos

- [ ] Implementar DTO remoto conforme contrato congelado.
- [ ] Implementar `ProductSyncCollection` usando `per_page/cursor/checkpoint`.
- [ ] Aplicar tombstones e upserts na mesma transação da página.
- [ ] Promover cursor/checkpoint somente após commit local.
- [ ] Encerrar rodada com `target_checkpoint` quando `has_more = false`.
- [ ] Tratar cursor 422 sem inventar recuperação destrutiva.
- [ ] Implementar repository/DAO Drift e stream local para catálogo.

## Dashboard

- [ ] Implementar DTO/mappers do snapshot real.
- [ ] Não enviar/depender de `category_id` enquanto o backend auditado não o aplica.
- [ ] Persistir snapshot atomicamente por `scope_key`.
- [ ] Registrar `revision`/metadados e manter snapshot anterior em falha remota.
- [ ] Implementar repository/stream local para dashboard.

## Apresentação

- [ ] Trocar fixtures por casos de uso/repositories locais.
- [ ] Manter dados durante refreshing/offline.
- [ ] Tratar `price = null` e métricas financeiras nulas.
- [ ] Garantir descarte seguro de streams na troca/logout de contexto.

- [ ] Não implementar outbox de vendas.
