# Tasks: Spec 009A - Drift Schema Inicial para Catálogo/Dashboard e Metadados

- [ ] **Fase 1: Configuração do pubspec.yaml**
  - [ ] Adicionar dependências `drift` e `sqlite3` na seção `dependencies`.
  - [ ] Adicionar dependências `drift_dev` e `build_runner` na seção `dev_dependencies`.
  - [ ] Executar `flutter pub get`.

- [ ] **Fase 2: Definição dos Schemas de Tabela**
  - [ ] Criar arquivo para categorias (`lib/core/database/tables/categories.dart`).
  - [ ] Criar arquivo para produtos (`lib/core/database/tables/products.dart`).
  - [ ] Criar arquivo para checkpoints de sincronização (`lib/core/database/tables/sync_checkpoints.dart`).
  - [ ] Criar arquivo para KPIs de dashboard (`lib/core/database/tables/dashboard_kpis.dart`).

- [ ] **Fase 3: Montagem do AppDatabase e Geração de Código**
  - [ ] Criar `lib/core/database/app_database.dart` declarando as classes e a versão do banco de dados.
  - [ ] Executar o comando de geração: `dart run build_runner build --delete-conflicting-outputs`.
  - [ ] Verificar se os arquivos `.g.dart` foram gerados sem avisos do compilador.

- [ ] **Fase 4: Validação do Banco com Testes**
  - [ ] Criar testes unitários em `test/core/database/app_database_test.dart` usando uma conexão em memória (`DatabaseConnection.inMemory()`).
  - [ ] Validar integridade referencial: testar se a chave estrangeira em `ProductsTable` que aponta para `CategoriesTable` funciona (ex: exclui categoria e seta nulo no ID correspondente do produto).
  - [ ] Simular inserção de produtos com categorias em ordem errada e ordem correta para validar a necessidade do sequenciamento estrito.
  - [ ] Validar leitura de produtos com campo `price` contendo valor e contendo `null`.
