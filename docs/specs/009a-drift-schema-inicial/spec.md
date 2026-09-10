# Spec 009A: Evolução do Schema Drift para Leitura Local

## Status

`done` — implementada na família de commits iniciada por `1a7ac67` e revalidada em 2026-09-09. O banco atual está em schema v4; a migração originalmente definida por esta Spec permanece coberta no caminho v1 → v4.

## Estado de partida

A 008B já deixou o banco operacional em `schemaVersion = 1`, fisicamente separado por `userId + tenantId`, contendo `sync_outbox(id, status)`. Drift, SQLite, `DatabaseFactory` e geração Drift já existem.

Esta spec evolui o banco existente. Não cria segundo banco e não recria arquivos locais.

## Objetivo

Criar o schema de leitura local necessário para a futura sincronização de catálogo/dashboard e os metadados de checkpoint que a 009B usará, preservando integralmente o v1.

## Fora de escopo

- execução do SyncEngine (009B);
- chamadas HTTP e coleções de sync (009C);
- ligação de vendas à outbox ou evolução do protocolo da outbox (010);
- imagens binárias no SQLite.

## Contrato remoto auditado

### Produtos

`GET /api/mobile/products` entrega, por item ativo:

- `id`;
- `name`;
- `sku`;
- `brand`;
- `price`, nullable conforme `view-financial-metrics`;
- `stock_quantity`;
- `stock_status`;
- `is_available_for_sale`;
- `image_url`, nullable;
- `updated_at`, nullable;
- `category`, nullable, no formato `{id, name}`.

Remoções chegam separadamente como tombstones `{id, deleted_at}`.

### Dashboard

`GET /api/mobile/dashboard` é um snapshot composto. `data` contém as chaves allowlisted pelo `DashboardResource`, incluindo `kpis`, `recent_movements`, `stock_level_chart`, `operational_goal_chart`, alertas e outras coleções. A resposta também contém `web_dashboard_url` e `meta.revision`, `generated_at`, `period` e `reference_date`.

Como o payload é composto e pode evoluir internamente, 009A não o explode prematuramente em dezenas de tabelas. O snapshot é persistido como payload serializado na camada `data`, com metadados indexáveis separados.

## Schema alvo

Se o baseline continuar em v1 no momento da implementação, a evolução é `v1 -> v2`.

### `categories`

- `id` text PK;
- `name` text.

A categoria é derivada do objeto aninhado retornado junto ao produto. Não existe nesta auditoria um endpoint mobile independente de categorias.

### `products`

- `id` text PK;
- `name` text;
- `sku` text;
- `brand` text nullable;
- `price` real nullable;
- `stock_quantity` integer;
- `stock_status` text;
- `is_available_for_sale` boolean;
- `image_url` text nullable;
- `category_id` text nullable, FK para `categories.id` com `ON DELETE SET NULL`;
- `remote_updated_at` datetime nullable;
- `deleted_at` datetime nullable.

Tombstone não exige apagar fisicamente a linha: `deleted_at` retira o produto das consultas operacionais e permite preservar referências históricas.

### `dashboard_snapshots`

- `scope_key` text PK, chave determinística dos filtros suportados pelo cliente;
- `period` text;
- `group_by` text;
- `page` integer;
- `revision` text;
- `generated_at` datetime;
- `reference_date` text;
- `web_dashboard_url` text;
- `can_view_financial` boolean;
- `payload_json` text.

`payload_json` é detalhe de persistência da camada `data`; domain/application não conhecem JSON.

### `sync_collections`

- `collection` text PK;
- `mode` text (`bootstrap|delta`);
- `cursor` text nullable;
- `checkpoint` text nullable;
- `target_checkpoint` text nullable;
- `revision` text nullable;
- `last_success_at` datetime nullable;
- `is_bootstrapped` boolean;
- `total_received` integer;
- `last_error` text nullable.

O lock persistido da engine não entra aqui: pertence à 009B e, se aprovado, evoluirá o schema em migração própria.

## Migração obrigatória

É proibido:

- apagar/recriar o arquivo;
- `deleteAll` como atalho;
- drop indiscriminado;
- remover, renomear ou recriar `sync_outbox`.

A migração deve criar apenas as novas estruturas e preservar dados do v1.

## Critérios de aceite

- banco novo cria v2 completo;
- banco v1 contendo `sync_outbox` migra sem perda;
- linha pendente de outbox permanece idêntica;
- `price = null` é persistido normalmente;
- produto tombstonado deixa consultas operacionais sem apagar referência histórica;
- snapshots de dashboard podem ser observados reativamente;
- contextos user+tenant continuam fisicamente isolados.
