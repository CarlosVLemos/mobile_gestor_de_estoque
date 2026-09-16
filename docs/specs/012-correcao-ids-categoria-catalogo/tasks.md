# Tasks — Spec 012

Status: `DONE — VALIDATED`

## Gate de governança

- [x] Maquiavel registra evidência final do contrato backend em `contract.md`.
- [x] Jarvis confirma modo `CRITICAL`, escopo, dependências e paths.
- [x] Usuário aprova `CR-009C-001` pela missão de estabilização.
- [x] Contrato passa de `DRAFT` para `FROZEN` com data e aprovação.
- [x] 009C é reaberta pontualmente como `in_progress — CR-009C-001`.

## Implementação

- [x] Separar a regra de Category UUID da regra numérica de Product/Tombstone.
- [x] Preservar Product ID inteiro como `String` numérica.
- [x] Preservar Tombstone ID inteiro como `String` numérica.
- [x] Preservar Category UUID como `String` UUID.
- [x] Manter categoria `null` válida.
- [x] Não tocar em Drift/schema/migration sem evidência e novo CR.

## Testes

- [x] Adicionar casos de datasource com UUID realista.
- [x] Cobrir categoria `null`.
- [x] Cobrir rejeição de Product/Tombstone não numéricos.
- [x] Cobrir upsert e FK Category/Product.
- [x] Cobrir tombstone e checkpoint sem regressão.
- [x] Executar testes sob autorização explícita do usuário.

## Fechamento

- [x] Registrar comandos, resultados e ambiente em `validation-result.md`.
- [x] Mefisto emite veredito final após análise estática.
- [x] Registrar o resultado no `CR-009C-001`.
- [x] Com `PASS`, aceitar o CR, aplicar adendo histórico e devolver 009C a `done`/validada.
- [x] Ramo `FAIL`/`PARTIAL` não aplicável; o veredito final foi `passed`.
