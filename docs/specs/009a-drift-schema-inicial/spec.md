# Spec 009A: Drift Schema Inicial para Catálogo/Dashboard e Metadados

## Problema
O catálogo de produtos e os dados do painel (dashboard) estão acoplados a mocks estáticos em memória. Para que a sincronização incremental remota seja viável, precisamos persistir localmente esses objetos de negócio em tabelas relacionais do SQLite usando a biblioteca `Drift`.

## Objetivo
Configurar a biblioteca Drift e modelar as tabelas locais fundamentais do aplicativo: categorias, produtos, alertas de estoque, indicadores consolidados e metadados de controle de sincronização (checkpoints).

## Fora de Escopo
* Lógica da engine de sincronização ou triggers automáticos.
* Integração dos DAOs locais com as telas da interface.
* Tabela de Outbox de vendas offline (será modelada na **Spec 010**).

## Regras de Negócio e Diretrizes Técnicas
1. **Definição de Tipos e Chaves Primárias:**
   * Usar identificadores estáveis (UUID em formato String no Drift) para as chaves primárias do catálogo (`products` e `categories`), combinando com as estruturas retornadas pelo Laravel em `/api/mobile/products`.
2. **Campos Anuláveis para Conformidade Financeira (MOB-003 / MOB-015):**
   * O campo `price` na tabela de produtos deve ser anulável (`real().nullable()`) para comportar o caso de perfis de usuário com restrição visual a métricas financeiras (`price = null` é um estado válido). A UI não deve quebrar ou lançar erro se o preço for nulo.
3. **Ordem de Sincronização e Chaves Estrangeiras:**
   * A tabela de produtos (`ProductsTable`) possui uma chave estrangeira opcional `category_id` que faz referência a `CategoriesTable.id`.
   * Para evitar erros de restrição referencial no SQLite durante a sincronização em lotes, a Sync Engine deve garantir que as **Categorias sejam baixadas e persistidas antes dos Produtos**.
4. **Controle de Sync (Checkpoints):**
   * Criar uma tabela simples `sync_checkpoints` contendo `collection_name` (PK) e `last_synced_at` (DateTime, nullable) ou cursor string. Isso servirá de âncora para a consulta incremental do parâmetro `updated_since`.
5. **Geração de Código:**
   * Utilizar `build_runner` para compilar o schema do Drift. O arquivo compilado gerado não deve ser incluído em commits a menos que seja necessário, ou seguir as regras padrão do `.gitignore` para arquivos `.g.dart`.

## Estrutura de Arquivos Proposta
```text
lib/core/
  database/
    app_database.dart         # Definição principal do Drift Database e tabelas
    tables/
      categories_table.dart
      products_table.dart
      dashboard_kpis_table.dart
      sync_checkpoints_table.dart
```

## Tabelas Especificadas
* **CategoriesTable:**
  * `id` (text, primary key)
  * `name` (text)
* **ProductsTable:**
  * `id` (text, primary key)
  * `name` (text)
  * `sku` (text)
  * `brand` (text)
  * `price` (real, nullable)
  * `stock_quantity` (integer)
  * `stock_status` (text)
  * `is_available_for_sale` (boolean)
  * `image_url` (text, nullable)
  * `category_id` (text, nullable, referenciando `CategoriesTable.id` com política de `ON DELETE SET NULL`)
  * `updated_at` (datetime)
* **SyncCheckpointsTable:**
  * `collection_name` (text, primary key)
  * `last_synced_at` (datetime, nullable)
  * `cursor` (text, nullable)

## Critérios de Aceite
* Dependências `drift`, `drift_dev` e `build_runner` inseridas e atualizadas no `pubspec.yaml`.
* O comando de build runner (`dart run build_runner build`) compila sem erros estáticos.
* As tabelas são criadas no banco de dados SQLite com os tipos de dados e restrições corretas.
* Relações de chaves estrangeiras são aplicadas sem quebrar sincronizações em lote (graças à ordem estrita).
* A suíte de testes unitários de banco de dados (`test/core/database/app_database_test.dart`) valida operações básicas de CRUD (inserção, leitura e exclusão) para todas as tabelas descritas.
* Testes validam que um produto sem preço (`price = null`) é inserido e lido com sucesso.

