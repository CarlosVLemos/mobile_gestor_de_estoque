# Regras para `lib/`

- Arquitetura: `Page -> Controller -> UseCase -> Repository -> DAO/API`.
- `presentation/` não importa Dio nem Drift.
- `application/` não importa Dio, Drift, JSON nem Flutter widgets.
- `domain/` não importa Flutter, persistência ou HTTP.
- `data/` contém DTOs, storage/DAO, remote data sources, mappers e repositories concretos.
- Providers de composição podem conectar dependências concretas, mas não devem esconder regra de negócio.
- Não introduza singleton global que misture contexto de tenant/user.
- Estados offline, restricted e failure devem preservar dados locais quando o produto assim exigir.
- Qualquer contrato remoto novo deve ser auditado por Maquiavel antes de consumo.
