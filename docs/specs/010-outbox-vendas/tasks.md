# Tasks: Spec 010 - Outbox de Vendas e Resiliência Offline

- [ ] **Fase 1: Schema de Banco de Dados**
  - [ ] Criar tabelas `SalesTable` (dados locais da venda) e `OutboxEventsTable` (fila de eventos pendentes de sync, contendo colunas de status enum, attempts, next_attempt_at, payload_json e payload_version) no Drift.
  - [ ] Executar o `build_runner` para regerar os arquivos compilados do banco.

- [ ] **Fase 2: Repositório Local e Enfileiramento**
  - [ ] Criar `DriftSalesRepository` implementando `SalesRepository`.
  - [ ] Garantir que a criação de uma venda execute dentro de uma transação do banco local, gravando a venda e o evento de outbox de forma atômica (tudo ou nada).

- [ ] **Fase 3: Processador de Outbox (OutboxProcessor)**
  - [ ] Criar `lib/features/sales/application/outbox_processor.dart`.
  - [ ] Implementar leitura sequencial ordenada dos eventos `pending` ou `failed_retryable` cujos tempos `next_attempt_at` já tenham expirado.
  - [ ] Conectar com o `ApiClient` para despachar requisições para `POST /api/mobile/sale-intents` e `/confirm`, injetando o cabeçalho `X-Request-ID` com o UUID do evento para garantir idempotência.
  - [ ] Implementar o cálculo do delay de retentativa com backoff exponencial + jitter ao cair no bloco de tratamento de erro temporário (gravando `next_attempt_at` e incrementando `attempts`).
  - [ ] Tratar erros definitivos (`422`) marcando o item como `failed_permanent`.

- [ ] **Fase 4: Indicadores na Interface de Usuário**
  - [ ] Atualizar a tela de lista de vendas para exibir um badge/pílula de status no card de cada venda correspondente ao status canônico da outbox.
  - [ ] Adicionar botão de reprocessamento manual ou limpeza para itens com falha definitiva.

- [ ] **Fase 5: Testes de Resiliência**
  - [ ] Criar testes unitários para o `OutboxProcessor` validando reenvio automático ao reestabelecer conexão.
  - [ ] Testar cenários de conciliação de chaves idempotentes (evitar vendas duplicadas em retentativas consecutivas).
  - [ ] Testar cálculo correto da fórmula de backoff exponencial e sorteio do jitter.
