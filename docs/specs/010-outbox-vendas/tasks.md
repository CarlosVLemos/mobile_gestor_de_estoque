# Tasks: Spec 010 - Outbox de Vendas e Resiliência Offline

- [ ] **Fase 1: Schema de Banco de Dados**
  - [ ] Criar tabelas `SalesTable` (dados locais da venda) e `OutboxEventsTable` (fila de eventos pendentes de sync) no Drift.
  - [ ] Executar o `build_runner` para regerar os arquivos compilados do banco.

- [ ] **Fase 2: Repositório Local e Enfileiramento**
  - [ ] Criar `DriftSalesRepository` implementando `SalesRepository`.
  - [ ] Garantir que a criação de uma venda execute dentro de uma transação do banco local, gravando a venda e o evento de outbox de forma atômica (tudo ou nada).

- [ ] **Fase 3: Processador de Outbox (OutboxProcessor)**
  - [ ] Criar `lib/features/sales/application/outbox_processor.dart`.
  - [ ] Implementar leitura sequencial ordenada dos eventos `pending` ou `failed` com tentativas abaixo do limite.
  - [ ] Conectar com o `ApiClient` para despachar requisições para `POST /api/mobile/sale-intents` e `/confirm`.
  - [ ] Tratar respostas de erro: retentativa para erros temporários (sem internet/503), abortar e marcar como falha para erros definitivos de validação (`422`).

- [ ] **Fase 4: Indicadores na Interface de Usuário**
  - [ ] Atualizar a tela de lista de vendas para exibir um badge/pílula de status no card de cada venda (ex: "Sincronizando...", "Pendente Offline", "Erro de Sincronização").
  - [ ] Adicionar botão de reprocessamento manual ou limpeza para itens com falha definitiva.

- [ ] **Fase 5: Testes de Resiliência**
  - [ ] Criar testes unitários para o `OutboxProcessor` validando reenvio automático ao reestabelecer conexão.
  - [ ] Testar cenários de conciliação de chaves idempotentes (evitar vendas duplicadas em retentativas consecutivas).
