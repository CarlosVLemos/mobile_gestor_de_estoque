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
   * Consumir o endpoint `GET /api/mobile/products` passando parâmetros `limit` (tamanho do lote, ex: 100), `page` (número da página) e `updated_since` (carimbo do checkpoint, se houver).
   * Tratar paginação do endpoint remoto. O bootstrap deve baixar todas as páginas de forma sequencial até que `has_more_pages` seja falso.
   * Realizar o "upsert" em massa das categorias e produtos na base de dados Drift local usando blocos de transação.
2. **Sincronização do Painel (`DashboardSyncCollection`):**
   * Consumir o endpoint `GET /api/mobile/dashboard`.
   * Salvar os KPIs e dados de alertas nas tabelas locais do banco Drift, limpando registros antigos consolidados e sobrescrevendo com os novos.
3. **Observabilidade Reativa na UI com Descarte Seguro (MOB-001):**
   * Modificar a camada de apresentação (`CatalogPage`, `DashboardPage`) para observar os dados através de fluxos contínuos (`Stream`) gerados pelo Drift.
   * Os Riverpod Providers que expõem essas Streams (ex: `catalogProductsStreamProvider`) devem utilizar o modificador `.autoDispose` para fechar os canais reativos e cancelar inscrições de banco de dados quando as telas correspondentes forem desmontadas.
   * Quando o `SyncEngine` terminar de salvar novos dados em background, a UI deve se atualizar automaticamente sem exigir que o usuário mude de página ou acione refresh.
4. **Resiliência Offline e Dados em Cache (UI-005):**
   * Se a sincronização falhar (ex: sem internet, erro de servidor), o repositório Drift local deve continuar fornecendo os últimos dados gravados no SQLite com sucesso.
   * O estado reativo da tela deve mudar para `ready` (exibindo os dados locais) mas acionar um banner ou indicador de "modo offline" ou "sincronização falhou", impedindo a exibição de uma tela em branco ou erro fatal de carregamento de tela inteira.

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
* Desconectar a internet e abrir o aplicativo exibe os dados salvos localmente na última sincronização válida, junto com o banner offline.
* Provedores de Stream do Drift usam `.autoDispose` e cancelam subscrições de banco no descarte da tela.
* A ausência de preços nos produtos (`price = null` devido a restrição visual) não quebra a renderização dos cards na lista do catálogo.
* Testes de widget e de integração validam o comportamento offline, renderização do catálogo reativo e descarte de subscrições.

