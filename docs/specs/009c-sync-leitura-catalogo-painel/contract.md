# Contrato 009C — Leitura remota e aplicação local

## Status

`FROZEN`

Backend auditado: `CarlosVLemos/gestor_de_estoque` `dev` @ `4ef4b3ee6374848ff903ce1f467daeff0975b005`.

## `/api/mobile/products`

### Request de sync

- método `GET`;
- `per_page` 1..50;
- `cursor` opaco nullable;
- `checkpoint` datetime <= now nullable;
- `updated_since` datetime nullable para compatibilidade;
- não usar `page` como protocolo de sync.

### Response

- `data[]`: `id`, `name`, `sku`, `brand`, `price?`, `stock_quantity`, `stock_status`, `is_available_for_sale`, `image_url?`, `updated_at?`, `category? {id,name}`;
- `tombstones[]`: `{id, deleted_at}`;
- `meta.next_cursor` nullable;
- `meta.has_more` bool;
- `meta.target_checkpoint` datetime.

Cursor é tenant-bound e a janela é fixada por `target_checkpoint`.

## `/api/mobile/dashboard`

### Request

- método `GET`;
- `group_by`: `day|week|month`, default `day`;
- `goal_month`: `YYYY-MM`, default mês atual;
- `page`: inteiro >= 1, default 1;
- `category_id`: aceito pela validação, mas não aplicado pelo `DashboardService` auditado; mobile não depende dele.

### Response

- `data`: snapshot allowlisted de dashboard;
- `web_dashboard_url`;
- `meta.revision`;
- `meta.generated_at`;
- `meta.period`;
- `meta.reference_date`.

Dashboard é snapshot/revision, não coleção cursor-based.

## Regra local

Produtos: página HTTP -> transação local -> tombstones/upserts -> commit -> promoção de cursor/checkpoint.

Dashboard: resposta válida -> transação local -> substituir snapshot do mesmo escopo -> commit -> registrar revision/sucesso.

Nenhuma Page/Controller recebe DTO HTTP diretamente.

Mudança desses endpoints/payloads exige Change Request.
