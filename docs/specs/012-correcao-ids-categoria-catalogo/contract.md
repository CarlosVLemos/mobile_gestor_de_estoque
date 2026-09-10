# Contract — Spec 012

Status: `FROZEN`
Version: 1
Mode: `CRITICAL`
Change Request: [`CR-009C-001`](../009c-sync-leitura-catalogo-painel/change-request-001-category-id.md)
Human approval / freeze date: 2026-09-09 — missão de estabilização e fechamento

Auditoria de contrato remoto: `CONFIRMED` em 2026-09-09, com base na auditoria forense concluída.

## Regra contratual

O tipo de ID deve ser validado conforme a entidade remota, sem um relaxamento global:

```text
Product.id (integer)             -> String numérica mobile
Product.category.id (UUID)       -> String UUID mobile
Product.category (null)          -> null mobile
Product tombstone.id (integer)   -> String numérica mobile
```

O valor UUID da Category deve ser preservado de forma idêntica entre o objeto remoto, a entidade local de Category e `Product.categoryId`. Product e Tombstone permanecem numéricos na fronteira remota.

## Invariantes

1. servidor permanece soberano sobre tipos e relações;
2. o parser não aceita texto arbitrário onde o backend fornece inteiro;
3. Category aceita UUID válida e não exige conversão numérica;
4. Category anulável permanece anulável;
5. uma falha de validação não promove checkpoint;
6. Category e Product são persistidos com uma FK coerente na mesma aplicação transacional;
7. tombstones mantêm a semântica de Product ID numérico;
8. não há alteração de schema Drift enquanto as colunas textuais atuais atenderem ao contrato.

## Paths permitidos após congelamento

### Produção

- `lib/features/catalog/data/remote/product_remote_data_source.dart`
- `lib/features/catalog/data/sync/product_sync_collection.dart` somente mediante necessidade demonstrada

### Testes

- `test/features/catalog/product_remote_data_source_test.dart`
- `test/features/catalog/product_sync_collection_test.dart`

### Documentação

- `docs/specs/012-correcao-ids-categoria-catalogo/**`
- `docs/specs/009c-sync-leitura-catalogo-painel/change-request-001-category-id.md`
- adendo mínimo nos documentos 009C somente após aprovação do CR

## Paths proibidos sem novo Change Request

- schema, migrations, `schemaVersion` e arquivos Drift gerados;
- features de vendas/outbox;
- UI, rotas e providers não relacionados ao mapper;
- contrato de Product ID, tombstone, paginação ou checkpoint;
- backend.

## Dependências

- aprovação humana do `CR-009C-001` — atendida em 2026-09-09;
- confirmação de Maquiavel sobre `HasUuids`, Product numérico e FK — atendida em 2026-09-09;
- contrato `FROZEN` antes de Van Gogh iniciar implementação;
- autorização explícita separada para executar cada perfil de QA.

## Regra de mudança

Qualquer necessidade de migração Drift, alteração de schema, mudança em endpoint/payload ou aceitação ampla de strings interrompe a execução e exige novo Change Request. O contrato está congelado; mudanças além deste escopo exigem novo Change Request.
