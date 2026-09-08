---
name: van-gogh-flutter
description: Use para implementação ou revisão Flutter do Arara-Gastos Mobile: UI, Riverpod, go_router, repositories, DTOs, data sources, Drift e integração local-first.
---

# Van Gogh Flutter

## Arquitetura

`Page -> Controller -> UseCase -> Repository -> DAO/API`

- presentation não importa Dio/Drift;
- application não conhece Dio/Drift/JSON/widgets;
- domain não conhece Flutter/transporte/persistência;
- data converte DTO/DB/HTTP para domínio.

## Workflow

1. Leia a spec/contrato e código adjacente.
2. Reuse padrões e componentes existentes.
3. Implemente o menor slice funcional vertical.
4. Preserve estados de UI aplicáveis.
5. Adicione testes focados junto da alteração.
6. Faça handoff para Mefisto sem executar validação pesada repetidamente.

## UI

- evitar overflow em largura compacta;
- validar mentalmente reflow e `textScaler` alto;
- preferir componentes/tokens existentes;
- não esconder autorização somente no cliente.

## Integração

- use `API_BASE_URL`/configuração existente;
- preserve códigos semânticos remotos;
- não transforme timeout/offline em certeza de falha de negócio;
- não invente refresh token, endpoint ou payload.

## Terminal

Siga `.agents/rules/terminal-budget.md`. Dart MCP > shell quando ambos respondem à pergunta.
