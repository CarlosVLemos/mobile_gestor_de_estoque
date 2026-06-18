# Tasks: Spec 009C - Sincronização de Leitura de Catálogo e Painel

- [ ] **Fase 1: Coleções de Sincronização**
  - [ ] Criar `ProductSyncCollection` em `lib/features/catalog/data/sync/product_sync_collection.dart` implementando o contrato de sync (obter lista de `/api/mobile/products`).
  - [ ] Implementar paginação recursiva ou iterativa no fetch de produtos.
  - [ ] Criar `DashboardSyncCollection` em `lib/features/dashboard/data/sync/dashboard_sync_collection.dart` consumindo o JSON do `/api/mobile/dashboard`.
  - [ ] Registrar as duas novas coleções no `SyncEngine`.

- [ ] **Fase 2: Repositórios Drift Reativos**
  - [ ] Criar `DriftProductRepository` em `lib/features/catalog/data/repositories/drift_product_repository.dart`.
  - [ ] Implementar retornos baseados em Streams reativas do Drift.
  - [ ] Criar `DriftDashboardRepository` em `lib/features/dashboard/data/repositories/drift_dashboard_repository.dart`.

- [ ] **Fase 3: Vinculação de Provedores e Telas**
  - [ ] Alterar o `productRepositoryProvider` para apontar para `DriftProductRepository`.
  - [ ] Alterar o `dashboardRepositoryProvider` para apontar para `DriftDashboardRepository`.
  - [ ] Ajustar controladores de tela (Presentation) para observar as novas streams usando `.autoDispose` nos provedores.
  - [ ] Implementar a exibição condicional do banner de aviso offline/falha de sync sem apagar os dados locais em cache já renderizados.

- [ ] **Fase 4: Testes de Integração e UI**
  - [ ] Criar testes unitários para os repositórios Drift mockando as chamadas HTTP.
  - [ ] Testar a interface do catálogo sob estado de restrição visual financeira (campo `price = null` no SQLite).
  - [ ] Validar que dados continuam visíveis na tela quando a chamada de sync remota falha e o banner de offline é exibido coerentemente.
  - [ ] Testar se o fechamento do widget desmonta a inscrição do stream do Drift (verificando `.autoDispose` do Riverpod).
