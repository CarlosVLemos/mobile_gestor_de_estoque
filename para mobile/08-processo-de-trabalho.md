# Processo de Trabalho Mobile

## 1. Orientar

Leia `AGENTS.md`, `.agents/quick-context.md`, `para mobile/00-contexto-operacional.md` e use `.agents/task-routing.md` para escolher somente contexto adicional necessário.

## 2. Classificar

Jarvis escolhe:

- `LIGHT`: ajuste pequeno/baixo risco;
- `STANDARD`: feature normal ou integração multi-camada;
- `CRITICAL`: auth, tenant/isolation, Drift/migração, sync, outbox/vendas, segurança, contrato ou release.

## 3. Planejar

Para STANDARD/CRITICAL, defina:

- objetivo e fora de escopo;
- contrato real;
- source of truth e persistência;
- estados de UI;
- permissões/tenant;
- ownership;
- validação;
- `SINGLE_WRITER` ou `PARALLEL_SAFE`.

CRITICAL exige `contract.md` FROZEN antes de implementação dependente dele.

## 4. Executar

- Maquiavel confirma backend/API quando houver integração.
- Van Gogh implementa Flutter dentro do contrato.
- máximo de 2 writers em PARALLEL_SAFE e somente em arquivos distintos.
- não executar validação pesada em loop; seguir `terminal-budget.md`.

## 5. Change Request

Se contrato FROZEN, schema, tenant boundary, rota, idempotência ou ownership precisar mudar, registrar CR e voltar à decisão humana. Não ajustar silenciosamente.

## 6. Validar

Mefisto escolhe o menor conjunto suficiente:

1. diff vs contrato;
2. teste focado;
3. análise estática;
4. widget/integration conforme risco;
5. suíte completa no fechamento/merge.

Validação dependente de WSL/Docker/device/VPS pode ser executada pelo usuário com comando exato preparado por Mefisto.

## 7. Fechar

Mefisto emite `passed`, `failed`, `blocked` ou `passed_with_restrictions`. Jarvis registra fechamento e dependências abertas.

## Specs

LIGHT normalmente não precisa de spec.

STANDARD usa spec quando múltiplas camadas/handoffs tornam a rastreabilidade útil.

CRITICAL usa:

```text
docs/specs/<id>-<slug>/
  spec.md
  contract.md
  tasks.md
  test.md
  validation-result.md
  review.md
```

Specs independentes podem andar em paralelo se as dependências estiverem explícitas; não existe regra de uma única spec ativa.

## Handoffs

Agentes canônicos:

- Jarvis: escopo/lifecycle;
- Maquiavel: contrato API;
- Van Gogh: Flutter;
- Mefisto: QA.

Handoff deve ser curto: objetivo, contrato, arquivos/camadas, decisões, riscos e validação necessária.
