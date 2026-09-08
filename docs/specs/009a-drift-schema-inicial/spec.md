# Spec 009A: Evolução do Schema Drift para Catálogo, Dashboard e Metadados

## Estado de partida

A Spec 008B já configurou `drift`, `sqlite3`, `path`, `path_provider`,
`build_runner` e `drift_dev`. Já existem `AppDatabase`, `DatabaseFactory`,
arquivos físicos por usuário + tenant e schemaVersion `1` contendo
`sync_outbox`.

Dispositivos podem conter bancos v1 com outbox pendente. Esta spec evolui esse
estado; não recria nem substitui a infraestrutura da 008B.

## Objetivo

Evoluir o `AppDatabase` existente com as tabelas locais de categorias,
produtos, KPIs de dashboard e checkpoints de sincronização, por migração
versionada e sem perda de dados existentes.

## Fora de escopo

- Sync engine, bootstrap, delta, tombstones e triggers automáticos (009B).
- Integração dos DAOs com telas (009C).
- Protocolo, payload, processador ou ligação de vendas à outbox (010).
- Remover, renomear, recriar ou ampliar semanticamente `sync_outbox`.

## Baseline e migração

O baseline obrigatório é:

```text
schemaVersion 1
  sync_outbox(id, status)
```

A versão de destino deve ser decidida pela implementação a partir do schema
real vigente; se o baseline continuar em v1, a primeira evolução será v1 → v2.
A migração deve criar apenas as novas tabelas e preservar arquivo SQLite,
`sync_outbox` e qualquer operação pendente. São proibidos `deleteAll`, drop
indiscriminado, reset de schema, apagar ou recriar o banco como atalho de
desenvolvimento.

## Tabelas futuras

- Categorias: identificador estável e nome.
- Produtos: identificador estável, campos remotos necessários, `price`
  anulável e referência opcional à categoria.
- KPIs de dashboard e checkpoints independentes por coleção.

As chaves, cursores, tombstones e tipos remotos devem ser confirmados pelo
contrato vigente antes da implementação. A ordem de aplicação do sync é futura:
categorias antes de produtos quando houver chave estrangeira.

## Critérios de aceite futuros

- `AppDatabase` e `MigrationStrategy` são evoluídos sem destruir v1.
- Banco v1 com uma linha em `sync_outbox` migra para a nova versão preservando
  essa linha.
- Novas tabelas existem após a migração e aceitam `price = null` quando
  aplicável.
- Testes cobrem banco novo, upgrade v1 → versão nova e isolamento por contexto.
