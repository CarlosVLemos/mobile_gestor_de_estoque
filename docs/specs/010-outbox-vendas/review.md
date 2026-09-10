# Spec 010 - Revisão de Abertura

## Status

`PHASE_A_VALIDATED — E2E_BLOCKED`

## Escopo pretendido

- Evolução não destrutiva da `sync_outbox` existente e criação de `local_sales`/`local_sale_items`;
- Geração de código do Drift correspondente;
- Implementação de `DriftSalesRepository` para gravação de transações locais e enfileiramento na Outbox em transação única atômica (SQLite);
- Criação de `OutboxProcessor` para drenagem em lote ordenada e sequencial dos itens na fila;
- Conexão do `OutboxProcessor` com `ApiClient` usando `client_request_id` no payload persistido;
- Algoritmo de backoff exponencial com ruído aleatório (jitter) para retentativas de rede;
- Exibição na UI dos estados canônicos de sincronização por pílulas no card de venda;
- Suíte de testes integrados e unitários cobrindo resiliência offline e idempotência de reenvio.

## Gate de implementação

ABERTO PARA FASE A conforme `contract.md`. Clientes reais e recuperação do
token de confirmação permanecem bloqueados por `HANDOFF-010-BACKEND`.

## Fontes consultadas

- `para mobile/00-contexto-operacional.md`;
- `para mobile/04-regras-e-necessidades-mobile.md` (vendas offline);
- `para mobile/05-arquitetura-mobile.md` (outbox, resiliência, concorrência);
- `para mobile/06-registro-decisoes.md` (decisões MOB-009, MOB-012, DEP-003).

## Decisões já assumidas pelo pedido do usuário

- Nenhuma venda é transmitida diretamente à rede sem antes passar pela persistência física local (Outbox);
- Chaves geradas no dispositivo servem como tokens de idempotência para o servidor remoto Laravel;
- Erros de validação (422) são tratados como falhas definitivas.

## Pontos curtos a refinar antes de aprovar a spec

- Não existe limite artificial de cinco retentativas de transporte; a regra de
  cinco tentativas pertence ao token de confirmação no backend.

## Veredito

`passed_with_restrictions` — núcleo da Fase A verde; a spec completa permanece bloqueada pelo handoff backend e pela UI ainda baseada em fixture.

O replay confirmado estrito foi reconciliado documentalmente pelo [`CR-010-001`](change-request-001-confirmed-replay.md). Isso não resolve o recovery do token de confirmação.
