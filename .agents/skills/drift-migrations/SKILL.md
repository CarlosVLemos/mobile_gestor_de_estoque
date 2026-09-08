---
name: drift-migrations
description: Use ao criar ou alterar Drift/SQLite, schemaVersion, migrações, DAOs ou lifecycle de bancos por usuário/tenant.
---

# Drift Migrations

## Invariantes

- migração nunca pode resolver erro apagando banco/outbox/dados pendentes;
- schema deve refletir tipos remotos reais conscientemente;
- `price = null` precisa permanecer representável;
- chaves de usuário/tenant precisam impedir mistura de dados;
- alterações de schema exigem teste de upgrade, não apenas banco novo.

## Checklist

- definir schemaVersion;
- criar índice/unique constraints necessários;
- separar entidades remotas de estado local de sync/outbox;
- testar create e migrate;
- testar reinício/persistência;
- testar isolamento de contextos;
- testar nullable/restrições críticas;
- documentar rollback/limite quando aplicável.

Não rode geração/build em loop; agrupe mudanças e deixe o gate para Mefisto.
