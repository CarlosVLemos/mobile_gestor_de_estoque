# Tasks: Spec 010 - Outbox de Vendas e Resiliência Offline

- [x] **Fase 1: Schema de Banco de Dados**
  - [x] Evoluir a `sync_outbox` existente e criar `local_sales`/`local_sale_items` por migração v3 -> v4 não destrutiva.
  - [x] Arquivo gerado Drift produzido na implementação original e confirmado alinhado ao schema atual; codegen não foi repetido nesta estabilização.

- [x] **Fase 2: Repositório Local e Enfileiramento**
  - [x] Criar `DriftSalesRepository` implementando `SalesRepository`.
  - [x] Garantir que a criação de uma venda execute dentro de uma transação do banco local, gravando a venda e o evento de outbox de forma atômica (tudo ou nada).

- [x] **Fase 3A: núcleo do OutboxProcessor**
  - [x] Criar `lib/features/sales/application/outbox_processor.dart`.
  - [x] Implementar leitura sequencial ordenada dos eventos `pending` ou `failed_retryable` cujos tempos `next_attempt_at` já tenham expirado.
  - [x] Conectar com o `ApiClient` para despachar `POST /api/mobile/sale-intents` e `/confirm`, mantendo `client_request_id` no payload persistido.
  - [x] Implementar o cálculo do delay de retentativa com backoff exponencial + jitter ao cair no bloco de tratamento de erro temporário (gravando `next_attempt_at` e incrementando `attempts`).
  - [x] Tratar erros definitivos (`422`) marcando o item como `failed_permanent`.
  - [ ] **Fase 3B bloqueada:** conectar o envelope real de proposal/intent/sale/token após `HANDOFF-010-BACKEND`.

- [ ] **Fase 4: Indicadores na Interface de Usuário (adiada; sem estética final nesta fase)**
  - [ ] Atualizar a tela de lista de vendas para exibir um badge/pílula de status no card de cada venda correspondente ao status canônico da outbox.
  - [ ] Adicionar botão de reprocessamento manual ou limpeza para itens com falha definitiva.

- [ ] **Fase 5: testes E2E de conectividade; núcleo unitário validado**
  - [ ] Criar testes unitários para o `OutboxProcessor` validando reenvio automático ao reestabelecer conexão.
  - [x] Testar cenários de conciliação de chaves idempotentes (evitar vendas duplicadas em retentativas consecutivas).
  - [x] Testar cálculo correto da fórmula de backoff exponencial e sorteio do jitter.
