# Contrato 010 — Outbox de vendas (Fase A)

## Status

`FROZEN` para a Fase A, autorizado pelo pedido de implementação de 9 de setembro de 2026.

A Fase A foi implementada e validada. A Spec completa permanece `BLOCKED`:
integração de clientes e recuperação remota de `confirmation_token` aguardam
`HANDOFF-010-BACKEND`.

Adendo aceito: [`CR-010-001`](change-request-001-confirmed-replay.md) formaliza o replay confirmado estrito já implementado.

## Fronteiras

- Escopo exclusivo do Flutter; nenhuma alteração no Laravel.
- O banco continua fisicamente isolado por `userId + tenantId`.
- A `sync_outbox` existente é evoluída; não existe segunda outbox nem lifecycle/SyncEngine paralelo.
- O schema parte de v3 e evolui de forma não destrutiva para v4.
- Servidor permanece soberano para preço, estoque, autorização e confirmação.
- A UI de fixture não registra venda real e IDs como `client-1`/`prod-1` nunca chegam ao transporte.

## Persistência e atomicidade

Uma nova operação persiste, em uma única transação SQLite, a venda local, seus
itens históricos e exatamente uma linha de outbox. Falha em qualquer etapa
reverte tudo. O carrinho só poderá ser limpo depois do commit.

`client_request_id` é UUID gerado uma vez, persistido e reutilizado em retry,
restart, timeout, 5xx, replay e crash recovery. O JSON semântico da criação é
persistido e não é reconstruído entre tentativas.

## Transporte congelado

- `POST /api/mobile/sale-intents`
- `POST /api/mobile/sale-intents/{intent}/confirm`
- `GET /api/mobile/sale-intents/{intent}` somente para reconciliação quando o contrato aplicável permitir.
- Bearer token da sessão atual; sem `Ref` capturado em objeto de vida longa.
- Idempotência é `client_request_id` no payload. `X-Request-ID` não é requisito.
- Payload v1 contém `client_request_id`, `client_id` inteiro, `status: paid`,
  `sold_at` com offset, `timezone` e itens com `product_id` inteiro e `quantity`.
- Não enviar preço nem `tenant_id`.
- ID String local não numérico produz falha local explícita antes do HTTP.

## Estados e classificação

Estados: `pending`, `syncing`, `confirmed`, `failed_retryable`,
`failed_permanent`, `requires_acceptance`, `cancelled`.

- 201 `intent_confirmed`, ou replay reconciliado como confirmado: `confirmed`.
- 409 `requires_confirmation`: `requires_acceptance`, sem confirmação automática.
- 409 `stock_proposal_changed`: exige novo aceite. A extração concreta de
  proposta/token permanece bloqueada até o handoff congelar o envelope.
- 409 `insufficient_stock`, `idempotency_conflict`: `failed_permanent`.
- 410 `intent_expired` e 422: `failed_permanent`.
- rede, timeout, 5xx e 429: `failed_retryable`.
- 401 aciona o comportamento global de sessão.
- 403 bloqueia a operação atual sem retry agressivo.

O token de confirmação é sensível, nunca é logado e é limpo em estado terminal.

Na Fase A, domínio, persistência, revisão de proposta e CAS de aceite estão
preparados, mas a fonte remota apenas estaciona os códigos 409 em
`requires_acceptance`. Ela não extrai `intent_id`, proposta ou token de um
envelope presumido. O aceite remoto funcional continua bloqueado. Conforme
`CR-010-001`, replay só é reconciliado quando a resposta 200 traz
`code=idempotent_replay`, `intent.state=confirmed` e `intent.id` válido.

## Processamento e recovery

- Ordem determinística mais antiga primeiro, um item por vez.
- Elegíveis automaticamente: `pending` e `failed_retryable` vencido.
- `syncing` órfão é recuperado com a mesma identidade e payload.
- Nenhuma transação SQLite permanece aberta durante HTTP.
- Agenda vem de `next_attempt_at`; não há timer permanente por evento.
- Backoff: `min(2^attempts * 30, 1800) + jitter(-15,+15)`, com clock e jitter
  injetáveis e clamp para nunca agendar no passado.
- Não existe limite artificial de cinco retries de transporte.

## Autorização

Uma nova venda exige feature `sales` e permissão `sales_create` na sessão atual.
Perda posterior de acesso não apaga pendências já persistidas.

## Bloqueado por handoff

- contrato e sync/listagem real de clientes;
- envelope de proposta/token e regra/endpoint final de recuperação de
  `confirmation_token` após restart;
- conexão do fluxo real de criação à UI, que hoje usa fixtures.

Qualquer mudança destas rotas, payload, schema, idempotência, tenant boundary ou
ownership exige Change Request explícito.
