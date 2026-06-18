# Spec 009C: Sincronização de Leitura de Catálogo e Painel

## Problema
As repositories de catálogo e de painel hoje retornam dados simulados (fixtures). Com a infraestrutura do Drift (Spec 009A) e do SyncEngine (Spec 009B) concluídas, precisamos implementar as implementações reais de sincronização para baixar o catálogo de produtos e os indicadores e atualizar as páginas visuais para observar o banco local reativamente.

## Objetivo
Implementar as coleções de sincronização para produtos (`ProductSyncCollection`) e resumo de painel (`DashboardSyncCollection`), substituindo as repositories de mock por repositórios baseados no banco SQLite reativo (Drift).

## Fora de Escopo
* Escrita local offline (criação de vendas, sincronização de outbox).
* Sincronização de dados não previstos na API (como logs de auditoria).

## Regras de Negócio e Diretrizes Técnicas
1. **Sincronização de Produtos (`ProductSyncCollection`):**
   * Consumir o endpoint `GET /api/mobile/products`.
   * Tratar paginação do endpoint remoto. O bootstrap deve baixar todas as páginas até que `has_more_pages` seja falso.
   * Realizar o "upsert" em massa das categorias e produtos na base de dados Drift local.
2. **Sincronização do Painel (`DashboardSyncCollection`):**
   * Consumir o endpoint `GET /api/mobile/dashboard`.
   * Salvar os KPIs e dados de alertas nas tabelas locais do banco Drift.
3. **Observabilidade Reativa na UI (MOB-001):**
   * Modificar a camada de apresentação (`CatalogPage`, `DashboardPage`) para observar os dados através de fluxos contínuos (`Stream`) gerados pelo Drift.
   * Quando o `SyncEngine` terminar de salvar novos dados em background, a UI deve se atualizar automaticamente sem exigir que o usuário mude de página.
4. **Resiliência Offline (UI-005):**
   * Se a sincronização falhar (ex: sem internet), o repositório deve retornar os últimos dados salvos no banco local e exibir um aviso de "modo offline", em vez de apagar a tela ou exibir um erro de tela inteira.

## Estrutura de Arquivos Proposta
```text
lib/features/catalog/
  data/
    sync/
      product_sync_collection.dart  # Integração com API /products
    repositories/
      drift_product_repository.dart # Query real no banco local Drift
lib/features/dashboard/
  data/
    sync/
      dashboard_sync_collection.dart # Integração com API /dashboard
    repositories/
      drift_dashboard_repository.dart # Query real no banco local Drift
```

## Critérios de Aceite
* A inicialização do aplicativo dispara o download e população inicial das tabelas locais (bootstrap).
* Alterações no banco de dados local refletem automaticamente nas telas sem necessidade de refresh manual.
* Desconectar a internet e abrir o aplicativo exibe os dados salvos localmente na última sincronização válida.
* A ausência de preços nos produtos (`price = null` devido a restrição visual) não quebra a renderização dos cards na lista do catálogo.
* Testes de widget e de integração validam o comportamento offline e a renderização do catálogo reativo.
