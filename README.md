# Arara-Gastos Mobile

Aplicativo Flutter do Arara-Gastos, organizado por feature e camada para
evoluir como cliente operacional local-first.

## Orientação

- [Contexto operacional](para%20mobile/00-contexto-operacional.md)
- [Arquitetura mobile](para%20mobile/05-arquitetura-mobile.md)
- [Especificações](docs/specs)

Antes de alterar o aplicativo, siga as instruções de `AGENTS.md` e leia o
contexto operacional.

## Estado da implementação

Em 8 de setembro de 2026, 009A/B/C possuem código de persistência, sincronização
e leitura reativa, com validação Flutter pendente. O startup permanece em modo
demonstrativo até receber contexto autenticado; o decoder remoto do painel
aguarda o contrato interno. Vendas continuam locais em memória.

Consulte [estado atual e roteiro de validação](docs/estado-atual.md) antes de
compilar: é necessário resolver dependências e gerar o código Drift.
