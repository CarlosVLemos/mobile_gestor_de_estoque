# Spec 010 - Referência de Validação Futura

## Objetivo

Registrar como a futura implementação da Spec 010 (Outbox de Vendas e Resiliência Offline) deverá ser validada.

## O que verificar depois

A futura implementação deverá comprovar que:
- Registrar uma venda no app insere de forma atômica o registro local e o evento de outbox (se um falhar, nada é persistido);
- O processador lê a outbox de forma sequencial pelo identificador de criação;
- O cabeçalho `X-Request-ID` é enviado ao servidor em todas as tentativas do evento correspondente;
- Erros de rede disparam o recuo exponencial (backoff) e calculam o `next_attempt_at` futuro correto;
- Erros definitivos (422) travam o reenvio deste item e marcam o status local como `failed_permanent`.

## Cenários de Teste a Cobrir

### 1. Atomicidade de Transação (Tudo ou Nada)
* **Verificar:**
  - Mockar uma falha de banco de dados na inserção da tabela `OutboxEventsTable` (ex: trigger de restrição violada).
  - Tentar registrar uma venda.
  - Validar que a venda correspondente na tabela `SalesTable` **NÃO** foi gravada (rollback da transação), mantendo o carrinho intacto na UI para retentativa.

### 2. Idempotência por Cabeçalho X-Request-ID
* **Verificar:**
  - Mockar o processador enviando um intent de venda para a API.
  - A API processa e aceita, mas a rede cai antes que o aplicativo receba a confirmação `200 OK`.
  - O aplicativo incrementa tentativas, calcula o backoff e retenta enviar a mesma venda.
  - Validar no mock da API que a segunda requisição contém o **MESMO** `X-Request-ID` que a primeira.
  - Validar que o servidor aceita e retorna a confirmação sem duplicar a transação.

### 3. Backoff Exponencial com Jitter
* **Verificar:**
  - Registrar uma falha temporária (ex: 503 Service Unavailable).
  - Validar que o status muda para `failed_retryable`, `attempts` vai para `1` e `next_attempt_at` é gravado no futuro.
  - Validar se a fórmula matemática calcula o recuo correspondente (cerca de 60 segundos com jitter aleatório de -15 a 15 segundos).
  - Garantir que o processador ignora a linha de outbox enquanto `DateTime.now()` for anterior a `next_attempt_at`.

### 4. Resolução de Conflitos e Exibição Visual
* **Verificar:**
  - Registrar uma falha definitiva (ex: 422 Unprocessable Entity - falta de estoque).
  - Validar que o status vai para `failed_permanent`.
  - Confirmar na lista de vendas que o card desta venda exibe um badge destacado com status de erro e um botão para "Reprocessar" ou "Ajustar".

## Checklist de Validação

- [ ] Tabelas `SalesTable` e `OutboxEventsTable` criadas no Drift.
- [ ] Gravação unificada das tabelas em bloco de transação (`transaction`).
- [ ] `OutboxProcessor` lê itens pendentes ou em retentativa.
- [ ] Cabeçalho `X-Request-ID` injetado na chamada da API de vendas.
- [ ] Algoritmo de backoff exponencial e jitter implementado.
- [ ] Badges visuais de status canônicos integrados no card de vendas.
- [ ] Testes de transações atômicas passando.
- [ ] Testes de idempotência passando.
- [ ] Testes de backoff e jitter passando com sucesso.
