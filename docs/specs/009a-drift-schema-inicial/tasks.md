# Tasks: Spec 009A - Drift Schema Inicial para Catálogo/Dashboard e Metadados

- [ ] **Fase 1: Configuração do pubspec.yaml**
  - [x] Adicionar dependências `drift` e `sqlite3` na seção `dependencies`.
  - [x] Adicionar dependências `drift_dev` e `build_runner` na seção `dev_dependencies`.
  - [ ] Executar `flutter pub get`.

- [ ] **Fase 2: Definição dos Schemas de Tabela**
  - [x] Criar arquivo para categorias (`lib/core/database/tables/categories_table.dart`).
  - [x] Criar arquivo para produtos (`lib/core/database/tables/products_table.dart`).
  - [x] Criar arquivo para checkpoints de sincronização (`lib/core/database/tables/sync_checkpoints_table.dart`).
  - [x] Criar KPIs, alertas e snapshot de dashboard (`lib/core/database/tables/dashboard_tables.dart`).

- [ ] **Fase 3: Montagem do AppDatabase e Geração de Código**
  - [x] Criar `lib/core/database/app_database.dart` declarando as classes e a versão do banco de dados.
  - [ ] Executar o comando de geração: `dart run build_runner build`.
  - [ ] Verificar se os arquivos `.g.dart` foram gerados sem avisos do compilador.

- [ ] **Fase 4: Validação do Banco com Testes**
  - [x] Criar testes unitários em `test/core/database/app_database_test.dart` usando uma conexão em memória (`NativeDatabase.memory()`).
  - [ ] Validar integridade referencial: testar se a chave estrangeira em `ProductsTable` que aponta para `CategoriesTable` funciona (ex: exclui categoria e seta nulo no ID correspondente do produto).
  - [ ] Simular inserção de produtos com categorias em ordem errada e ordem correta para validar a necessidade do sequenciamento estrito.
  - [ ] Validar leitura de produtos com campo `price` contendo valor e contendo `null`.

## Execução parcial — 8 de setembro de 2026

Schema e testes escritos, ainda não executados. KPIs/alertas foram modelados
pelas entidades locais; o decoder HTTP do painel continua dependente de contrato. Geração, resolução de dependências e aceite
continuam pendentes; ver `review.md` e `test.md`.
