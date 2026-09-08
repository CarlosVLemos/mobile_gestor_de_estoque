# Governança de specs mobile

## Quando usar

- `LIGHT`: spec formal normalmente desnecessária.
- `STANDARD`: use spec quando houver múltiplas camadas, handoff ou aceite não trivial.
- `CRITICAL`: spec e contrato obrigatórios.

## Estrutura CRITICAL

```text
docs/specs/<id>-<slug>/
  spec.md
  contract.md
  tasks.md
  test.md
  validation-result.md
  review.md
```

## Lifecycle

Estados: `draft`, `ready`, `in_progress`, `paused`, `blocked`, `done`, `cancelled`, `superseded`, `rejected`.

Mefisto usa vereditos `passed`, `failed`, `blocked`, `passed_with_restrictions` e não fecha a spec; Jarvis fecha.

## Contrato FROZEN

Para CRITICAL, `contract.md` precisa estar aprovado/FROZEN antes de implementação que dependa dele.

Mudança de contrato, schema, tenant boundary, rota, idempotência ou ownership durante execução exige Change Request explícito.

## Concorrência

- `SINGLE_WRITER`: padrão quando existe estado/arquivo compartilhado sensível.
- `PARALLEL_SAFE`: máximo 2 writers, arquivos distintos e contrato já definido.

Specs independentes podem coexistir se Jarvis registrar dependências e caminho crítico; não existe obrigação artificial de uma única spec ativa.
