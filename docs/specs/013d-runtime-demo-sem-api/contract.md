# Contract — Spec 013D

Status: `FROZEN`
Version: 1
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
- dashboard usa o mesmo scope e repository Drift da produção.

## Vendas

- no demo, registro chama `RegisterSaleUseCase` e `DriftSalesRepository`;
- venda, itens e outbox são atômicos;
- o engine existente drena pelo `DemoSaleIntentGateway`;
- o gateway não importa Dio e devolve confirmação/replay determinísticos;
- proposta/aceite não são inventados.

## Paths autorizados

- `lib/bootstrap.dart`, `lib/app/router/**`, `lib/core/config/**`;
- `lib/app/demo/**`, `lib/features/auth/data/demo/**`;
- `lib/features/catalog/data/demo/**`, `lib/features/dashboard/data/demo/**`;
- `lib/features/sales/data/demo/**`, composição/providers/controller/UI de vendas;
- testes e documentação da Spec.

Schema, migrações, backend e contratos remotos permanecem fora de escopo. Qualquer necessidade nesses pontos exige Change Request.
