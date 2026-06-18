# Spec 010 - Revisão de Abertura

## Status

Planejada em 18 de junho de 2026. Não implementada.

## Escopo pretendido

- Modelagem física no Drift das tabelas `SalesTable` e `OutboxEventsTable` (com suporte a versões de payload, contagem de tentativas e tempo de backoff);
- Geração de código do Drift correspondente;
- Implementação de `DriftSalesRepository` para gravação de transações locais e enfileiramento na Outbox em transação única atômica (SQLite);
- Criação de `OutboxProcessor` para drenagem em lote ordenada e sequencial dos itens na fila;
- Conexão do `OutboxProcessor` com `ApiClient` anexando cabeçalho de idempotência `X-Request-ID` usando o identificador único do evento;
- Algoritmo de backoff exponencial com ruído aleatório (jitter) para retentativas de rede;
- Exibição na UI dos estados canônicos de sincronização por pílulas no card de venda;
- Suíte de testes integrados e unitários cobrindo resiliência offline e idempotência de reenvio.

## Gate de implementação

FECHADO.

Esta especificação define o mecanismo de resiliência e envio em segundo plano das vendas locais (Outbox). Nenhum código de negócio está liberado para escrita.

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

- Esclarecer sobre o limite de tentativas: após atingir o limite de 5 tentativas sem sucesso em erros temporários, o status deve progredir de `failed_retryable` para `failed_permanent`, exigindo reprocessamento manual ou limpeza por parte do usuário.

## Veredito

Especificação detalhada e alinhada com as melhores práticas de persistência resiliente. O gate permanece fechado.
