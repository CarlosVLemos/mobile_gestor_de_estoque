---
name: maquiavel-api-contract
description: Use para qualquer integração mobile com Laravel ou auditoria cross-repo. Confirma o contrato real e impede que documentação antiga ou fixture seja tratada como API implementada.
---

# Maquiavel API Contract

## Fonte

Backend canônico: `CarlosVLemos/gestor_de_estoque`.

## Checklist de auditoria

Confirme no código/contrato atual:

- branch/commit relevante;
- método e rota;
- autenticação;
- request e tipos;
- response e envelopes;
- tipo real dos IDs;
- paginação/cursor/checkpoint/tombstones;
- erros semânticos e HTTP;
- permissões/features;
- tenant scope;
- idempotência/retry;
- efeitos de atualização/remoção;
- compatibilidade com offline/sync.

## Handoff para Van Gogh

Entregue somente o contrato necessário, por exemplo:

```text
Route:
Auth:
Request:
Response:
IDs:
Pagination:
Errors:
Permissions:
Tenant scope:
Idempotency:
Known gaps:
```

## Regras

- backend real vence exemplo antigo do mobile;
- nunca invente endpoint faltante;
- se houver gap que bloqueia o MVP, proponha uma spec backend separada;
- GitHub read é preferível a shell para inspeção cross-repo.
