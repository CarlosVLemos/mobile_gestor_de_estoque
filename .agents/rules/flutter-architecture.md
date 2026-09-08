---
description: Arquitetura Flutter e boundaries do projeto
paths:
  - "lib/**/*.dart"
---

- Fluxo: Page -> Controller -> UseCase -> Repository -> DAO/API.
- presentation: sem Dio/Drift.
- application: sem Dio/Drift/JSON/widgets.
- domain: sem Flutter/transporte/persistência.
- data: DTOs, DAO, remote data source, mapper e implementação de repository.
- Riverpod é composição/estado; não mova regra crítica para widget.
- go_router reage ao estado da aplicação; não bypassar guard de produção.
- reuse tokens/widgets existentes e evite overflow em largura compacta/textScaler alto.
