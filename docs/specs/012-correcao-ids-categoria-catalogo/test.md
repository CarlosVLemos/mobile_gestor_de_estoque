# Test Plan — Spec 012

Status: `EXECUTED — STATIC ANALYSIS PENDING`
Execução nesta sessão: autorizada pelo pedido de estabilização e pela ordem posterior para rodar os testes.

## Objetivo

Provar a correção específica de Category UUID e detectar qualquer relaxamento indevido das regras numéricas de Product/Tombstone, sem transformar testes de fixtures antigas em evidência suficiente.

## Casos necessários

| ID | Caso | Critérios |
| --- | --- | --- |
| CT-012-01 | Product `id: 123` | resulta em `"123"` |
| CT-012-02 | Category com `id: "550e8400-e29b-41d4-a716-446655440000"` | UUID preservada e página aceita |
| CT-012-03 | `category: null` | página aceita e FK local nula |
| CT-012-04 | Tombstone `id: 123` | resulta em `"123"` e remove Product correto |
| CT-012-05 | Product com UUID/texto | rejeitado como contrato inválido |
| CT-012-06 | Tombstone com UUID/texto | rejeitado como contrato inválido |
| CT-012-07 | Category UUID + Product | Category é upsertada e `Product.categoryId` contém a mesma UUID |
| CT-012-08 | Aplicação transacional com Category UUID | FK válida e checkpoint promovido após sucesso |
| CT-012-09 | Falha durante aplicação | checkpoint não promovido |
| CT-012-10 | Tombstone e checkpoint existentes | comportamento permanece válido |

Uma fixture apenas numérica para Category não satisfaz CT-012-02 nem AC-012-11.

## Comandos futuros de QA

Executar somente após autorização explícita do usuário, na ordem e no menor perfil necessário:

```bash
flutter test test/features/catalog/product_remote_data_source_test.dart
flutter test test/features/catalog/product_sync_collection_test.dart
flutter test --no-pub test/architecture
flutter analyze --no-pub
```

Além do perfil focado, a suíte completa foi executada e passou. Não houve schema change; por isso build_runner/codegen não foram necessários.

## Gate de aprovação

O veredito só pode ser `PASS` se todos os critérios AC-012-01 a AC-012-14 tiverem evidência, os testes focados passarem e a análise estática não apontar erro no escopo. Falha em tombstone, checkpoint, FK ou isolamento bloqueia o fechamento.
