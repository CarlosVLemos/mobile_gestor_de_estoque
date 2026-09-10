# Spec 012 — Correção contratual de IDs de categoria no catálogo mobile

Status: `in_progress — QA estático pendente`
Modo: `CRITICAL`
Execution mode: `SINGLE_WRITER` até o contrato ficar `FROZEN`
Data de abertura: 2026-09-09
Owner de governança: Jarvis
Contrato remoto: Maquiavel
Implementação: Van Gogh
QA: Mefisto
Change Request: [`CR-009C-001`](../009c-sync-leitura-catalogo-painel/change-request-001-category-id.md)

## Problema

O catálogo mobile usa `_requiredRemoteId()` para interpretar os IDs de Product, Category e Tombstone como valores numéricos. Esse pressuposto só é correto para Product e para tombstones de Product. No backend real, `Category` usa UUID.

Quando uma página de produtos contém uma categoria UUID válida, o parser rejeita a resposta inteira como dado inválido. O defeito impede a leitura normal do catálogo mesmo que produto, paginação e checkpoint estejam corretos.

## Evidência confirmada

- backend `Category` usa Laravel `HasUuids`;
- backend `Product` continua com ID numérico;
- `Product.category_id` referencia `Category`;
- mobile usa `_requiredRemoteId()` numérico para Product, Category e Tombstone;
- IDs internos de catálogo já são representados por `String`;
- a persistência Drift de Category e sua referência em Product já usa representação textual.

## Contrato backend real

| Entidade/campo | Tipo e semântica |
| --- | --- |
| `Product.id` | inteiro, identificador de Product |
| `Product.category_id` | referência anulável para `Category.id` |
| `Category.id` | UUID gerado/gerido pelo model com `HasUuids` |
| tombstone de Product | ID inteiro do Product removido |
| checkpoint | cursor opaco do protocolo de sync; sua semântica não muda nesta Spec |

## Contrato mobile corrigido

| Entrada | Representação interna | Validação |
| --- | --- | --- |
| Product ID inteiro | `String` numérica | obrigatória; rejeitar UUID ou texto arbitrário |
| Tombstone product ID inteiro | `String` numérica | obrigatória; rejeitar UUID ou texto arbitrário |
| Category ID UUID | `String` UUID | obrigatória quando a categoria existe; preservar o valor |
| Category ausente | `null` | válida |

A representação interna `String` deve ser preservada. Ela comporta tanto IDs numéricos convertidos de Product quanto UUIDs de Category sem perda, e evita mudança de schema sem benefício contratual.

## Escopo

- separar a validação/conversão do ID de Category das regras numéricas de Product e Tombstone;
- aceitar e preservar uma UUID realista de Category;
- manter categoria `null` válida;
- garantir que uma Category UUID válida não invalide a página de produtos;
- confirmar upsert de Category e Product no Drift com FK coerente;
- confirmar que tombstones e checkpoint continuam funcionando;
- criar ou ajustar testes focados no datasource remoto e na coleção de sync;
- documentar a alteração e fechar o CR da 009C após QA aprovado.

## Fora de escopo

- relaxamento genérico de IDs para qualquer `String`;
- mudança do tipo de Product ID ou tombstone;
- alteração de endpoint, payload, paginação ou autorização;
- migração Drift sem evidência de incompatibilidade real;
- alteração de tabelas, schemaVersion ou arquivos gerados se o schema textual atual for suficiente;
- mudanças em venda/outbox, escrita de catálogo, UI ou navegação;
- refatoração ampla do Sync Engine.

## Arquivos esperados na implementação futura

Produção efetivamente alterada:

- `lib/features/catalog/data/remote/product_remote_data_source.dart`;
`lib/features/catalog/data/sync/product_sync_collection.dart` não precisou de alteração.

Testes:

- `test/features/catalog/product_remote_data_source_test.dart`;
- `test/features/catalog/product_sync_collection_test.dart`.

Governança:

- arquivos desta Spec;
- `docs/specs/009c-sync-leitura-catalogo-painel/change-request-001-category-id.md`;
- após aprovação do CR, adendo mínimo aos registros de status/validação da 009C.

Não são esperadas alterações em `app_database.dart`, migrations, `schemaVersion` ou `.g.dart`.

## Riscos

- relaxar o helper atual e aceitar IDs arbitrários em Product/Tombstone;
- validar UUID de forma incompatível com o formato realmente serializado pelo Laravel;
- persistir Category com um ID e Product com outra forma textual da mesma FK;
- falhar a página inteira por categoria válida;
- quebrar promoção de checkpoint ou aplicação de tombstones ao mexer no mapper compartilhado;
- introduzir migração desnecessária em colunas que já são textuais;
- testes continuarem verdes apenas com fixtures antigas de categoria numérica.

## Critérios de aceite

- [x] AC-012-01: Product ID inteiro do backend é materializado como `String` numérica no mobile.
- [x] AC-012-02: Tombstone de Product com ID inteiro é materializado como `String` numérica.
- [x] AC-012-03: Category ID UUID do backend é aceito e preservado como `String` UUID.
- [x] AC-012-04: `category: null` continua válido.
- [x] AC-012-05: uma categoria com UUID válida não quebra nem descarta uma página válida de produtos.
- [x] AC-012-06: a categoria UUID é upsertada corretamente no Drift.
- [x] AC-012-07: a FK Product → Category usa exatamente a mesma UUID e permanece válida.
- [x] AC-012-08: tombstones de Product continuam removendo o registro correto.
- [x] AC-012-09: checkpoint continua sendo promovido somente após aplicação transacional bem-sucedida.
- [x] AC-012-10: Product e Tombstone não passam a aceitar UUID ou texto arbitrário.
- [x] AC-012-11: os testes incluem `550e8400-e29b-41d4-a716-446655440000`.
- [x] AC-012-12: nenhuma migração Drift foi criada; as colunas textuais já eram compatíveis.
- [x] AC-012-13: o contrato congelado da 009C recebeu reabertura por CR aprovado antes da implementação.
- [ ] AC-012-14: testes focados e suíte completa passaram; falta executar `flutter analyze` para o veredito final.

## Impacto na 009C

A 009C entregou a integração de leitura do catálogo, mas congelou/validou uma interpretação incompleta do tipo de ID da categoria. A correção altera um detalhe de contrato dentro daquela integração, por isso exige reabertura pontual por `CR-009C-001`. Os demais resultados da 009C permanecem históricos e não são reabertos.

## Gate de abertura cumprido

1. [atendido] Maquiavel registrou a confirmação do contrato backend;
2. [atendido] Jarvis confirmou escopo, dependências e paths;
3. [atendido] a missão de estabilização aprovou o Change Request;
4. [atendido] `contract.md` passou a `FROZEN` antes da implementação.

A implementação foi autorizada e concluída. O único gate de fechamento pendente é a análise estática.
