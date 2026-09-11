# Spec 013D — Runtime de demonstração sem API

Status: `IN_PROGRESS — IMPLEMENTED, VALIDATION PENDING`
Mode: `CRITICAL`
Execution mode: `SINGLE_WRITER`
Data: 2026-09-10
Owner: Jarvis / Van Gogh / Mefisto

## Objetivo

Permitir `flutter run --dart-define=APP_MODE=demo` sem Laravel e sem `API_BASE_URL`, usando sessão local, banco físico exclusivo, seed Drift determinístico, catálogo/dashboard reais sobre repositories locais e vendas pelo pipeline persistente/outbox com gateway sem HTTP.

## Escopo

- modo tipado `normal|demo`, com normal como default seguro;
- seleção no composition root;
- autenticação demo local, sem token real;
- contexto `demo-user + demo-tenant`;
- seed idempotente de catálogo/dashboard;
- referências numéricas realistas de cliente/produto para venda;
- registro por `RegisterSaleUseCase -> DriftSalesRepository -> outbox`;
- `SaleIntentGateway` demo determinístico, sem Dio;
- SyncEngine existente para bootstrap e dreno;
- indicação global “Modo demonstração”;
- testes e documentação do comando.

## Fora de escopo

- fallback após falha da API;
- editor/reset de cenários;
- proposta/aceite ainda bloqueados na 010;
- segundo router, domínio, banco, outbox ou SyncEngine;
- schema/migração/codegen;
- backend.

## Critérios de aceite

- demo inicia e entra sem API;
- normal continua selecionando auth/HTTP/composição reais;
- bancos normal e demo possuem paths distintos;
- seed roda somente enquanto o contexto demo não estiver inicializado;
- Category usa UUID e Product/Client usam IDs numéricos;
- catálogo, dashboard, vendas e Settings exibem dados coerentes;
- venda demo persiste e é confirmada pelo gateway demo sem duplicação;
- nenhuma chamada HTTP é necessária no uso demo normal;
- teardown demo não toca banco/token real;
- banner inequívoco identifica os dados fictícios.

Contrato: [`contract.md`](contract.md).

## Estado atual

A implementação local usa o mesmo Drift, outbox, use case e SyncEngine. O gate final ainda não foi concluído; portanto a Spec não está `done`.
