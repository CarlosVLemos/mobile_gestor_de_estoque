# Arquitetura

O documento canônico da arquitetura está em:

- `para mobile/05-arquitetura-mobile.md`

As decisões e seus status estão em:

- `para mobile/06-registro-decisoes.md`

O resumo para leitura rápida está em:

- `para mobile/00-contexto-operacional.md`

Fluxo oficial:

```text
Page
  -> Controller Riverpod
    -> UseCase
      -> Repository
        -> Local DAO / Remote Data Source
```

Regra importante: a camada `application` orquestra casos de uso por contratos.
Ela não conhece Dio, Drift, JSON ou widgets. Esses detalhes pertencem à camada
`data`.
