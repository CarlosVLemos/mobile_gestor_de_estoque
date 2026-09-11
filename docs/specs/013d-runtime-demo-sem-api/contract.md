# Contract — Spec 013D

Status: `FROZEN`
Version: 2
Mode: `CRITICAL`
Freeze date: 2026-09-10
Human approval: pedido explícito da fase “Modo demonstração sem API”

## Runtime

`APP_MODE` aceita somente `normal` ou `demo`. Ausente ou vazio usa `normal`; valor desconhecido falha fechado durante bootstrap.

## Isolamento

- normal usa providers, API e autenticação reais;
- demo usa sessão `demo-user/demo-tenant`, banco derivado desse contexto, nenhum token remoto e nenhum datasource HTTP;
- demo nunca é fallback de erro;
- logout fecha somente o contexto ativo e não apaga bancos.

## Dados e sync

- seed local executado como coleção do SyncEngine existente;
- marcador em `sync_collections` torna o seed idempotente;
- banco demo já inicializado é reutilizado;
- Category usa UUID; Product e Client usam Strings numéricas;
- o seed v5 persiste clientes na mesma tabela/query usada por produção;
- dashboard usa o mesmo scope e repository Drift da produção.

## Vendas

- no demo, registro chama `RegisterSaleUseCase` e `DriftSalesRepository`;
- venda, itens e outbox são atômicos;
- o engine existente drena pelo `DemoSaleIntentGateway`;
- o gateway não importa Dio e devolve confirmação/replay determinísticos;
- proposta/aceite não são inventados; o gateway demo confirma deterministicamente.

## Change Request v2

O CR-010-002 autorizado em 2026-09-11 permite ao demo consumir o schema v5 e
seedar clientes persistidos. O isolamento, a ausência de HTTP/token e o uso de
uma única infraestrutura permanecem inalterados.

## Paths autorizados

- `lib/bootstrap.dart`, `lib/app/router/**`, `lib/core/config/**`;
- `lib/app/demo/**`, `lib/features/auth/data/demo/**`;
- `lib/features/catalog/data/demo/**`, `lib/features/dashboard/data/demo/**`;
- `lib/features/sales/data/demo/**`, composição/providers/controller/UI de vendas;
- testes e documentação da Spec.

Schema, migrações, backend e contratos remotos permanecem fora de escopo. Qualquer necessidade nesses pontos exige Change Request.
