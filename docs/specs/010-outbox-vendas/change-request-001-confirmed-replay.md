# Change Request 010-001 — Replay confirmado estrito

Status: `ACCEPTED`
Data: 2026-09-10
Contrato afetado: `010 — Outbox de vendas (Fase A)`
Tipo: correção documental do contrato congelado
Mudança de produção nesta estabilização: nenhuma; o comportamento já estava implementado

## Motivo

O contrato FROZEN registrava que reconhecer o formato de replay confirmado ainda dependia do `HANDOFF-010-BACKEND`. A auditoria do backend real e do mobile mostrou que esse recorte já é conhecido e implementado:

```text
HTTP 200
code = idempotent_replay
intent.state = confirmed
intent.id válido
→ confirmed
```

Um replay genérico, um intent não confirmado ou uma resposta sem `intent.id` válido continua falhando fechado.

## Evidência

- backend auditado: `CarlosVLemos/gestor_de_estoque dev@4ef4b3ee6374848ff903ce1f467daeff0975b005`;
- `SaleIntentsRemoteDataSource._success()` exige status, código, estado e ID;
- testes cobrem replay confirmado, extração de IDs e rejeição de replay genérico;
- perfil focado do datasource: 8 testes aprovados;
- suíte completa: 220 testes aprovados.

## Limites

Este CR não libera:

- extração de `intent/proposal/confirmation_token` no primeiro `requires_confirmation`;
- recovery do token após restart/replay/GET;
- `stock_proposal_changed`;
- UI de aceite;
- integração de clientes.

Nota posterior: esse blocker histórico foi resolvido pelo backend
`dev@f8ff65e` e absorvido pelo CR-010-002 mobile.

## Decisão

O contrato recebe apenas o adendo de que replay **já confirmado** pode ser reconciliado sob a regra estrita acima. Não há mudança de rota, payload enviado, schema, idempotência, tenant boundary ou ownership.

- [x] Maquiavel confirmou o contrato real.
- [x] Mefisto confirmou cobertura focada e suíte completa.
- [x] Jarvis aceitou o adendo documental na rodada de estabilização.
