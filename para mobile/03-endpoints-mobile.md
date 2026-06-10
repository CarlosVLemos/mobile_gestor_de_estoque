# Endpoints Mobile

## Visao geral

Base atual encontrada em `routes/api.php`.

Prefixo comum:

- `/api/mobile`

Middleware comum:

- `auth`
- `tenant.initialize`
- `tenant.access`
- `tenant.active`
- `throttle:60,1`

Observacao importante:

- hoje as rotas existentes estao protegidas por autenticacao do Laravel, mas o fluxo de token Sanctum para mobile ainda nao foi implementado;
- o contrato abaixo descreve os endpoints reais disponiveis hoje.

## 1. Perfil autenticado

### `GET /api/mobile/me`

Objetivo:

- devolver contexto do usuario autenticado para boot do app.

Resposta:

```json
{
  "user": {
    "id": "uuid",
    "name": "Maria",
    "email": "maria@empresa.test"
  },
  "tenant": {
    "id": "uuid",
    "name": "Empresa Teste",
    "slug": "empresa-teste"
  },
  "features": [
    "catalog",
    "sales"
  ],
  "permissions": {
    "products_view": true,
    "sales_create": true,
    "reports_view": false,
    "view_financial_metrics": false
  }
}
```

Regras de uso no mobile:

- `features` controla modulos disponiveis;
- `permissions.products_view` habilita consulta de catalogo;
- `permissions.sales_create` prepara o fluxo de venda;
- `permissions.view_financial_metrics` controla exibicao de preco e dados financeiros.

## 2. Dashboard mobile

### `GET /api/mobile/dashboard`

Objetivo:

- devolver um recorte JSON do dashboard operacional web.

Query params aceitos:

- `start_date` - data opcional
- `end_date` - data opcional, maior ou igual a `start_date`
- `group_by` - `day`, `week` ou `month`
- `category_id` - `uuid` opcional
- `goal_month` - formato `YYYY-MM`
- `page` - inteiro opcional

Resposta de alto nivel:

```json
{
  "dashboard": {
    "filters": {},
    "kpis": {},
    "client_portfolio": [],
    "client_positivation": [],
    "sellers_ranking": [],
    "impact_products": [],
    "stock_rupture_risk": [],
    "recommended_actions": [],
    "stock_level_chart": [],
    "operational_goal_chart": {},
    "top_selling_products": [],
    "stock_quantity_overview": [],
    "abc_curve": [],
    "risk_turnover_scatter": [],
    "recent_movements": {},
    "can_view_financial": false,
    "low_stock_alert": []
  },
  "web_dashboard_url": "https://app.exemplo/painel"
}
```

Campos importantes para o app:

- `dashboard.kpis`: indicadores principais.
- `dashboard.recent_movements`: feed resumido operacional.
- `dashboard.can_view_financial`: informa se o app pode mostrar dados sensiveis.
- `dashboard.operational_goal_chart`: resumo da meta do periodo.
- `web_dashboard_url`: ponte para abrir o dashboard completo no navegador.

Observacoes:

- o payload vem da mesma base de negocio do dashboard web;
- a estrutura e ampla, mas o app pode consumir apenas os blocos necessarios;
- dados internos ficam whitelistados pelo `DashboardResource`.

## 3. Catalogo de produtos mobile

### `GET /api/mobile/products`

Objetivo:

- devolver catalogo tenant-scoped para consulta e sincronizacao incremental.

Middleware adicional:

- `feature.enabled:catalog`

Query params aceitos:

- `search` - texto livre, busca em nome e SKU
- `category_id` - `uuid` da categoria do tenant atual
- `sort` - `name`, `sku`, `brand`, `price`, `stock_quantity`, `points_per_unit`, `created_at`
- `direction` - `asc` ou `desc`
- `updated_since` - data/hora para sync incremental
- `per_page` - de `1` a `50`
- `page` - pagina atual

Resposta:

```json
{
  "data": [
    {
      "id": "uuid-ou-id",
      "name": "Produto A",
      "sku": "SKU-123",
      "brand": "Marca X",
      "price": 49.9,
      "stock_quantity": 4,
      "stock_status": "available",
      "is_available_for_sale": true,
      "image_url": "https://app.exemplo/storage/produtos/a.jpg",
      "updated_at": "2026-06-10T10:00:00-03:00",
      "category": {
        "id": "uuid",
        "name": "Capacetes"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "per_page": 15,
    "total": 120,
    "last_page": 8,
    "has_more_pages": true
  }
}
```

Semantica dos campos:

- `price`: pode vir `null` se o usuario nao tiver permissao financeira.
- `stock_status`: classifica estoque como `available`, `low` ou `out`.
- `is_available_for_sale`: atalho de UX para liberar compra/venda.
- `updated_at`: ancora de sincronizacao incremental.

Regras importantes:

- itens sem estoque continuam aparecendo;
- a decisao final de vender continua pertencendo ao servidor;
- `updated_since` filtra por `products.updated_at >= valor informado`.

## 4. Respostas de erro esperadas

### `401 Unauthorized`

Quando:

- usuario nao autenticado;
- sessao ou token invalido.

### `403 Forbidden`

Quando:

- usuario nao tem permissao necessaria;
- feature do tenant esta desativada;
- tenant esta bloqueado pelo middleware de acesso.

### `422 Unprocessable Entity`

Quando:

- filtros invalidos, como `per_page > 50`;
- `category_id` fora do tenant atual;
- `updated_since` com formato invalido.

### `429 Too Many Requests`

Quando:

- o cliente ultrapassa `60` requisicoes por minuto.

## 5. Endpoints planejados e ainda nao implementados

Definidos na `Spec 22`:

- `POST /api/mobile/login`
- `POST /api/mobile/logout`
- `GET /api/mobile/reports/available-products`
- `GET /api/mobile/reports/sold-products`
- `POST /api/mobile/sale-intents`
- `POST /api/mobile/sale-intents/{intent}/confirm`

Esses endpoints ainda nao existem no codigo atual.
