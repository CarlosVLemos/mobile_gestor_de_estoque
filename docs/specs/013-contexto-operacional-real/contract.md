# Contract — Spec 013

Status: `FROZEN`
Version: 1
Mode: `CRITICAL`
Freeze date: 2026-09-09
Human approval: missão de estabilização e fechamento

## Invariantes

1. `UserSession` é a única fonte para identidade, tenant, features e permissões já carregadas por `/me`.
2. Settings não executa HTTP adicional e não usa fallback fixture.
3. O `SyncEngine` observado é a mesma instância registrada no lifecycle contextual.
4. Não se cria engine ou lifecycle paralelo.
5. Somente arquivos sob `lib/app/composition/` podem ligar datasources concretos dentro da camada `app`.
6. Teardown continua cancelando o engine antes de fechar o banco.

## Paths permitidos

- `lib/app/context_sync_scope.dart`
- `lib/app/local_context_lifecycle.dart`
- `lib/app/composition/**`
- `lib/features/settings/settings_providers.dart`
- `lib/features/settings/data/repositories/**`
- fixtures de Settings removidas por se tornarem inalcançáveis
- `test/app/**`, `test/core/sync/**`, `test/features/settings/**`, `test/architecture/**`
- documentação desta Spec

Qualquer mudança de schema, tenant boundary, protocolo remoto ou vendas exige Change Request separado.
