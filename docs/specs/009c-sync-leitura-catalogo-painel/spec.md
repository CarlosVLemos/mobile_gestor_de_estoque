# Spec 009C: Sync de leitura de Catálogo e Dashboard

## Status

`done` — 009A e 009B foram entregues; a leitura local-first de catálogo e dashboard está integrada ao SyncEngine.

## Backend auditado

`CarlosVLemos/gestor_de_estoque`, branch `dev`, commit `4ef4b3ee6374848ff903ce1f467daeff0975b005`.

## Objetivo

Implementar as coleções reais de leitura e substituir fixtures por repositórios locais Drift. A rede nunca alimenta diretamente a UI.

```text
API -> SyncCollection -> Drift -> Repository/Stream -> Controller -> Page
```

## Produtos — contrato real

Endpoint: `GET /api/mobile/products`.

Proteções: Sanctum, conta/tenant válidos, troca obrigatória de senha resolvida, feature `catalog` ativa e permissão `products.view`.

Parâmetros relevantes para sync:

- `per_page`: 1..50, default backend 15;
- `cursor`: cursor opaco de continuação;
- `checkpoint`: data <= agora;
- `updated_since`: compatibilidade de delta inicial.

`page` é aceito pelo FormRequest, mas a Action de sync não o usa como mecanismo de paginação. A 009C não deve basear sync em `page`.

Resposta:

```text
data[]
tombstones[] { id, deleted_at }
meta:
  next_cursor
  has_more
  target_checkpoint
```

### Janela estável

A primeira request fixa `target_checkpoint`. Todas as páginas do mesmo cursor permanecem nessa janela. O backend ordena por `(sync_at, id)` e inclui o tenant dentro do cursor; cursor adulterado ou de outro tenant retorna 422.

Mudanças ocorridas depois de `target_checkpoint` ficam para a próxima rodada.

### Aplicação local

Cada página deve ser aplicada em uma transação:

1. aplicar tombstones;
2. upsert de categorias presentes;
3. upsert de produtos ativos, limpando eventual `deleted_at` do mesmo id;
4. commit;
5. somente após commit promover cursor/checkpoint seguro.

Ao terminar `has_more = false`, o `target_checkpoint` concluído torna-se o checkpoint da próxima rodada e o cursor transitório é limpo.

## Dashboard — contrato real

Endpoint: `GET /api/mobile/dashboard`.

Parâmetros validados: `group_by=day|week|month`, `goal_month=YYYY-MM`, `page>=1` e `category_id` UUID nullable. Na implementação auditada, `DashboardService` reconstrói os filtros e não aplica `category_id`; o cliente não pode depender de filtragem por categoria até o backend materializar essa semântica.

Resposta:

- `data`: snapshot allowlisted pelo `DashboardResource`;
- `web_dashboard_url`;
- `meta.revision`;
- `meta.generated_at`;
- `meta.period`;
- `meta.reference_date`.

`revision` é estável para o mesmo snapshot e muda quando período ou dados de negócio mudam, conforme testes backend.

Dashboard NÃO usa o protocolo cursor/checkpoint dos produtos. Cada sync obtém um snapshot e, após resposta válida, substitui atomicamente o snapshot local daquele `scope_key`.

Campos financeiros podem ser `null`; `can_view_financial` orienta rendering local, sem substituir autorização remota.

## UI local-first

- catálogo e dashboard observam Drift;
- refresh mantém dados antigos visíveis;
- falha remota atualiza estado de sync/offline, não zera tabelas;
- Streams/providers devem ser descartados com segurança no logout e na troca de contexto;
- imagens continuam fora do SQLite.

## Fora de escopo

- outbox de vendas (010);
- mudança no backend;
- refresh token;
- categoria como coleção remota independente, pois não há endpoint mobile auditado para isso.

## Critérios de aceite

- bootstrap e delta de produtos respeitam cursor/tombstones/target checkpoint;
- retomada de página é idempotente;
- dashboard substitui snapshot somente após resposta/persistência válidas;
- offline mantém último conteúdo local;
- `price = null` e campos financeiros nulos não quebram UI;
- troca de contexto não mistura streams ou bancos.
