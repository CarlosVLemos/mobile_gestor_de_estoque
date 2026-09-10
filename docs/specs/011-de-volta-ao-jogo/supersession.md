# Registro de supersessão — Spec 011

Status: `SUPERSEDED`
Estado canônico do lifecycle: `superseded`
Data da decisão: 2026-09-09
Decisão: encerramento administrativo, sem implementação e sem QA próprios

## Decisão formal

A Spec 011 foi superada pelo estado real do aplicativo. Ela permaneceu em `draft`, seu contrato nunca chegou a `FROZEN`, todas as tarefas ficaram sem execução e o resultado de validação permaneceu `NOT_RUN`. Portanto, não há entrega identificável da 011 a implementar, revisar ou validar.

O encerramento como `SUPERSEDED` preserva a intenção histórica da proposta sem atribuir a ela código produzido por outras Specs. Não se trata de rejeição técnica: os objetivos eram válidos, mas já haviam sido absorvidos por contratos e implementações anteriores quando a auditoria confrontou a proposta com o repositório real.

## Motivos determinantes

1. A 011 propõe `schemaVersion = 1`, enquanto o banco real já está em versão 4 e possui evolução governada por migrações.
2. Ela propõe criar tabelas de categorias, produtos e checkpoints que já foram entregues pela 009A.
3. Ela propõe tornar o catálogo persistente, comportamento já integrado pela 009C sobre o Sync Engine da 009B.
4. Seu diagnóstico afirma ausência de banco operacional e Sync Engine, premissas incompatíveis com o código atual.
5. Itens declarados fora de escopo, como dashboard persistente, sincronização remota e outbox, já avançaram nas Specs 009 e 010.
6. Executar a 011 hoje repetiria fundação existente e poderia regredir schema, isolamento, sync e integração já estabelecidos.

## Matriz de absorção

| Escopo proposto na 011 | Entrega que o absorveu | Evidência de implementação |
| --- | --- | --- |
| Fundação Drift e tabelas de catálogo/checkpoint | Spec 009A | commit `1a7ac67` |
| Motor de sincronização, checkpoint e tombstones | Spec 009B | commit `615e398` |
| Catálogo persistido e integração de leitura local-first | Spec 009C | commits `01b1896` e `620a223` |
| Dashboard alimentado pela persistência/sync | Spec 009C | commits `01b1896` e `620a223` |
| Fundação de vendas/outbox, que a 011 ainda tratava como futura | Spec 010 | commits `4d8f312` e `1e99be9` |

O isolamento físico por usuário/tenant e a infraestrutura de abertura do banco também já integram a baseline sobre a qual as Specs 009/010 foram implementadas. A 011 não deve tentar recriá-los nem rebaixar o schema.

## Efeito documental

- `spec.md` e `contract.md` passam a indicar `SUPERSEDED`.
- `tasks.md` e `tests.md` são mantidos sem marcar itens como executados.
- `validation-result.md` e `review.md` preservam `NOT_RUN`, pois não houve implementação atribuível à 011.
- Todo o conteúdo original permanece no diretório como histórico.
- Nenhum Change Request é necessário: o contrato da 011 nunca foi congelado.

## Lacuna descoberta durante a auditoria

A supersessão não declara a integração da 009C livre de defeitos. A auditoria identificou uma divergência específica no ID de categoria: o backend usa UUID para `Category`, enquanto o parser mobile exige ID remoto numérico. Essa correção é governada separadamente pela Spec 012 e por um Change Request pontual da 009C.
