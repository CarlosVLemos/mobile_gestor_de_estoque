# Validation Result — Spec 010

Status: `PHASE_A_VALIDATED — E2E_BLOCKED`
Verdict: `passed_with_restrictions`

## Núcleo validado

- `DriftSalesRepository`: 11 testes aprovados para atomicidade, rejeição de IDs fixture, rollback, identidade estável, retry, ordenação, CAS de revisão, 403, cancelamento e restart.
- `OutboxProcessor`: 6 testes aprovados para claim sequencial, backoff/jitter, aceite explícito, 403 e cancelamento de lifecycle.
- `SaleIntentsRemoteDataSource`: 8 testes aprovados para payload, replay estrito, conflitos e classificação de erros.
- banco/migração v4: 9 testes aprovados.
- suíte completa: 220 testes aprovados, zero falhas.

O [`CR-010-001`](change-request-001-confirmed-replay.md) registra que o replay estrito já está implementado e não depende do blocker de recovery.

## Restrições reais

1. `BLOCKER-010-CLIENTS`: o backend auditado não fornece `GET /api/mobile/clients`; a UI não pode inventar `client_id` remoto válido.
2. `BLOCKER-010-CONFIRMATION-RECOVERY`: replay/consulta não devolve o token de confirmação e o mobile ainda não materializa de forma recuperável todo o envelope de conflito.
3. A tela de vendas ainda usa `FixtureSalesDraftRepository` e pendências em memória; ela não chama o núcleo persistente da Fase A.

A Fase A está validada. A Spec 010 completa permanece `blocked` até handoff backend e conexão segura da UI após o contrato de clientes.
