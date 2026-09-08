# Spec 009A - Referência de Validação Futura

## Objetivo

Registrar como a futura implementação da Spec 009A (Drift Schema Inicial) deverá ser validada.

## O que verificar depois

A futura implementação deverá comprovar que:
- O banco Drift compila e gera arquivos `.g.dart` sem warnings;
- As tabelas de categorias, produtos, kpis e checkpoints foram criadas fisicamente com tipos corretos;
- Relações de chave estrangeira são cumpridas no SQLite (PRAGMA foreign_keys = ON);
- O banco insere e recupera produtos com preço contendo valor numérico normal;
- O banco insere e recupera produtos com preço nulo (`price = null`).

## Cenários de Teste a Cobrir

### 1. CRUD Básico em Memória
* **Verificar:**
  - Instanciar a conexão em memória.
  - Inserir uma categoria.
  - Inserir um produto vinculado à categoria.
  - Consultar o produto e a categoria correspondente e verificar a igualdade dos dados.
  - Deletar o produto e garantir que a categoria continua intacta.

### 2. Preço Nulo (Restrição Financeira)
* **Verificar:**
  - Inserir um produto com campo `price` definido como `null` no Drift.
  - Recuperar o registro.
  - Validar que o objeto recuperado contém o valor `null` no preço de forma segura e não gera falhas de conversão de ponto flutuante.

### 3. Validação de Chave Estrangeira (Ordem de Sync)
* **Verificar:**
  - Tentar inserir um produto que faz referência a um `category_id` inexistente no banco.
  - Validar que o Drift lança uma exceção de restrição de chave estrangeira (`SqliteException` indicando falha de foreign key).
  - Inserir a categoria primeiro e em seguida o mesmo produto, confirmando que a operação é concluída com sucesso.
  - Deletar a categoria inserida e validar se o campo `category_id` do produto é alterado para `null` (ON DELETE SET NULL).

## Checklist de Validação

- [ ] Dependências de `drift` e `sqlite3` no `pubspec.yaml`.
- [ ] Geração de código do build_runner completada sem erros.
- [ ] Tabela de categorias criada e mapeada.
- [ ] Tabela de produtos criada com chave estrangeira para categoria e `price` anulável.
- [ ] Tabela de checkpoints de sync suportando nome da coleção, carimbo e cursor.
- [ ] Testes unitários rodando sobre `NativeDatabase.memory()`.
- [ ] Testes de chaves estrangeiras ativos e passando.
- [ ] Testes de nulos de preços passando.

## Roteiro para a próxima sessão com Flutter

Testes escritos em `test/core/database/app_database_test.dart`, ainda não executados.
Execute na raiz, nesta ordem:

```sh
flutter pub get
dart run build_runner build
dart format lib/core/database test/core/database
flutter analyze
flutter test test/core/database/app_database_test.dart
flutter test
```

Revisar e versionar o `pubspec.lock` resultante da resolução. Não marcar o aceite
como concluído antes de gerar o código e executar os testes. O teste de rollback
valida a transação do banco, não uma SyncEngine implementada. A continuação 009C alterou estados
de tela; seguir também seus testes de reatividade e roteiro visual.

## Painel e lease adicionados na continuação

Executar também `flutter test test/core/database/drift_sync_store_test.dart` e
`flutter test test/features/dashboard/dashboard_sync_test.dart`. Esses testes
cobrem exclusão/renovação de locks, substituição atômica de KPIs/alertas, nulos,
rollback e leitura local. O decoder do painel usado no teste é um dublê explícito.
Nenhum desses testes foi executado nesta sessão.
