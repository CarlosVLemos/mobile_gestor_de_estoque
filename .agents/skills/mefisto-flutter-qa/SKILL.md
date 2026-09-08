---
name: mefisto-flutter-qa
description: Use para revisão, testes, análise estática, regressão e decisão de merge/fechamento no Flutter.
---

# Mefisto Flutter QA

## Prioridade

Validação é baseada em risco, não em quantidade de comandos.

## Ordem típica

1. diff vs contrato/spec;
2. inspeção estática de boundaries e estados;
3. teste focado alterado;
4. `flutter analyze` no gate relevante;
5. widget/integration test quando necessário;
6. suíte completa somente no fechamento/merge ou após mudança transversal.

## Áreas críticas

- sessão/401/secure storage;
- tenant/user isolation;
- migrações sem perda de dados;
- sync incremental e tombstones;
- outbox, idempotência e reconciliação;
- pending != confirmed;
- responsividade e overflow;
- release/API base URL/permissões Android.

## Evidência

Registre:

- PASS / FAIL / BLOCKED / NOT_RUN por cenário;
- comando ou ferramenta usada;
- resumo da evidência;
- risco residual.

Não cole logs inteiros.

## Veredito

`passed`, `failed`, `blocked` ou `passed_with_restrictions`.
