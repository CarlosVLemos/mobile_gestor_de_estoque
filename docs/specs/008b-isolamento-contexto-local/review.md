# Spec 008B — Revisão de Fechamento

## Status

Concluída em 8 de setembro de 2026.

## Escopo entregue

- `DatabaseFactory` cria e reabre arquivos Drift determinísticos por `userId` + `tenantId`.
- A abertura do banco ocorre somente após login ou restauração de sessão válida.
- `DataPurgeService` executa `stop sync -> close database -> clear scoped cache -> invalidate providers`.
- Logout e expiração aguardam o purge antes de o estado de autenticação redirecionar para `/login`.
- `sync_outbox` permanece no arquivo físico do contexto; o logout avisa antes de prosseguir quando há itens pendentes.
- Testes cobrem isolamento físico, reabertura, preservação da outbox, ordem do purge e integração com autenticação.

## Gate de implementação

ABERTO e autorizado pela solicitação de implementação da Spec 008B. O
`contract.md` foi congelado antes do código de contexto local.

## Fontes consultadas

- `para mobile/00-contexto-operacional.md`;
- `para mobile/05-arquitetura-mobile.md`;
- `para mobile/06-registro-decisoes.md`;
- `docs/specs/008b-isolamento-contexto-local/contract.md`.

## Riscos residuais

- O motor real de sync e o protocolo de envio de vendas continuam fora de
  escopo das Specs 009/010. A 008B fornece o boundary `SyncLifecycle` e a
  persistência contextual que essas specs deverão usar.

## Veredito

`passed` — implementação e validações focadas concluídas; ver
`validation-result.md`.
