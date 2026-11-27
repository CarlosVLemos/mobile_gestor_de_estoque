# Validation Result — Spec 015

Status: `NOT_RUN` | Verdict: não emitido

## Environment
Não definido. Registrar SHA, versão Flutter/Dart, runner/aparelho, ambiente API e execução autorizada.

## Results
| ID | Result | Evidence |
| --- | --- | --- |
| QA-015-* | NOT_RUN | Matriz planejada em test.md; nenhum teste executado nesta preparação. |

## Commands/tools used
Nenhuma execução Flutter/Dart, CI, build, deploy ou escrita remota neste pacote. Preenchimento futuro apenas com evidência real.

## Residual risks
- Runner Linux pode divergir da referência Windows; baseline precisa aprovação visual.
- Proteção de branch pode depender do plano; não declarar ativada sem evidência.
- Dependências de ações e scanner precisam verificação na implementação.

Allowed result: PASS | FAIL | BLOCKED | NOT_RUN.

## Inventário inicial do gate

Base de integração: `dev` em `805873f6832c33a7213ceaaf52500c544a7829e4`.
O levantamento usa os resultados já coletados nos PRs e a árvore Git da
base. A matriz QA-015 continua `NOT_RUN`.

| Área | Evidência | Pendência para o contrato |
| --- | --- | --- |
| Workflows | A árvore de `dev` não contém arquivos em `.github/`. | Definir runner, gatilhos e nomes dos checks antes de criar workflows. |
| Proteção de branches | A consulta de regras de `dev` à API retornou HTTP 403. | Confirmar as regras e os recursos do plano no GitHub. |
| SDK e dependências | A revisão `924134a44c` da `.metadata` corresponde a Flutter 3.44.1 com Dart 3.12.1, usados nas validações dos PRs. A instalação com `--enforce-lockfile` passou. | Validar a instalação no runner e fixar essa versão no CI. |
| Formatação | O formatador sinalizou 57 de 210 arquivos no PR #21, que mantém os arquivos Dart da base. | Definir a regularização da base antes de exigir formatação na árvore inteira. |
| Goldens | O PR #21 reproduziu 18 divergências no Linux. Após atualizar as duas referências do catálogo no #24 (`c092896`), os dois testes do catálogo passaram e as outras 16 divergências persistiram. A Spec 014 registra a validação histórica em Windows. | Definir a plataforma de referência e revisar as diferenças visuais antes de atualizar os baselines do conjunto completo. |

Começar com dois níveis propostos no contrato: validação rápida para push e
gate completo para PR. Antes do freeze, resolver a plataforma dos goldens, a
regularização da formatação e a disponibilidade de checks obrigatórios. A
implementação de CI segue pendente de aprovação do contrato.
