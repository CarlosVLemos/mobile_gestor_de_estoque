# Arara Gastos Mobile — snapshot forense em 2026-09-09

> **Adendo de estabilização:** os achados deste snapshot foram tratados na execução posterior registrada em [`stabilization-report-2026-09-09.md`](stabilization-report-2026-09-09.md). Category UUID, Settings/contexto real, composição do sync, boundary arquitetural e permissão Android foram corrigidos; a suíte final passou com 220 testes. O veredito histórico abaixo descreve o estado anterior às correções e não deve ser lido como status atual.

## 1. Escopo e identidade auditada

Esta auditoria é exclusivamente estática. Nenhum teste, análise, formatação,
build, codegen, processo persistente ou comando de mutação Git foi executado.

| Item | Valor |
|---|---|
| Repositório | `CarlosVLemos/mobile_gestor_de_estoque` |
| Branch | `dev` |
| HEAD | `1e99be90d805435e420bd2ef3276ca36b953f980` |
| Working tree antes desta documentação | limpa |
| Commit HEAD | `Implementação da spec 010 ainda não verificada` |

Últimos commits relevantes:

| Commit | Evidência de estado |
|---|---|
| `1e99be9` | ajustes e geração Drift da 010; o próprio commit declara ausência de verificação |
| `4d8f312` | Fase A da 010: schema v4, repositório, outbox, transporte e testes |
| `620a223` | correções documentais/de entrega da 009C |
| `01b1896` | conexão da 009C: API -> sync -> Drift -> UI |
| `615e398` | implementação do Sync Engine da 009B |
| `1a7ac67` | schema Drift da 009A e testes de migração |

## 2. Veredito executivo

A fundação é tecnicamente relevante e em grande parte materializada: auth
Sanctum, banco por contexto, migrações v1/v2/v3 para v4, lease persistido,
sync de produtos/dashboard e o núcleo da outbox existem. O aplicativo ainda
não é operacional como produto de vendas e não está pronto para release.

Há dois trilhos distintos:

```text
CATÁLOGO / DASHBOARD
API real -> SyncEngine -> Drift -> Repository -> Controller -> Page

VENDAS EXIBIDAS
Fixture -> SalesController -> PendingSalesController em memória -> Page

VENDAS IMPLEMENTADAS, MAS SEM UI
RegisterSaleUseCase -> DriftSalesRepository -> SQLite/outbox
  -> SyncEngine -> OutboxProcessor -> sale-intents
```

Os quatro achados mais graves são:

1. o Flutter exige ID numérico para categoria, mas o backend usa UUID, podendo
   invalidar uma página inteira de produtos;
2. a tela de vendas não alcança o pipeline persistente da 010;
3. Settings/Contexto mistura sessão real com tenant e permissões fixture;
4. proposta/aceite/recovery de `sale-intents` permanece bloqueado pelo contrato
   backend, e nenhuma UI observa a outbox.

## 3. Governança e decisões

Documentação de status não é fonte suficiente neste snapshot. O código e o
histórico mostram 009B/009C/010 depois do ponto registrado em
`para mobile/00-contexto-operacional.md`, `.agents/quick-context.md` e
`contexto.md`. A pasta `011-de-volta-ao-jogo` é um draft `SDD-001` que volta a
propor schema v1, autenticação inexistente e fundação ainda não criada. Ela
contradiz o HEAD e não deve ser implementada.

| Decisão | Origem | Implementada? | Evidência | Divergência |
|---|---|---:|---|---|
| Local-first e UI lendo estado local | MOB-001 | parcial | catálogo/dashboard observam Drift | vendas/settings não seguem o mesmo trilho |
| Feature + camadas | MOB-002/003 | parcial | domínio/application/data/presentation existem | AuthController orquestra DB/sync; composition roots dispersos |
| Riverpod para estado/injeção | MOB-004 | sim, com dívida | providers globais e contextuais | context-bound depende de invalidação manual |
| Drift é banco operacional | MOB-005 | sim | schema v4, vendas/outbox/checkpoints | UI de vendas ainda não grava nele |
| Dio centraliza HTTP | MOB-006 | sim | `ApiClient` e datasources | sem health check/conectividade real |
| go_router controla acesso | MOB-007 | sim | redirect por estado de auth | router é recriado e shell não é feature-gated |
| Token em storage seguro | MOB-008 | sim | `SecureTokenStorage` | token também é duplicado em memória no contexto ativo |
| Outbox e identidade estável | MOB-009 | parcial | UUID/payload persistidos e replay | trilho não é chamado pela UI; recovery de confirmação bloqueado |
| Servidor soberano | MOB-010/015 | sim no core | transporte não envia preço/tenant; permissões orientam UI | Settings mostra permissões fixture |
| Foreground como sync principal | MOB-011 | parcial | startup, resumed e manual | connectivity/background não estão ligados |
| Migração preserva pendências | MOB-012 | sim no código | v1/v2/v3 -> v4 fail-closed | evidência do HEAD não foi executada nesta auditoria |
| Imagens fora do SQLite | MOB-013 | sim por ausência | schema guarda apenas URL | cache de imagens ainda não existe |
| UI azul operacional | MOB-014/UI-001..007 | majoritariamente | tema, shell e estados | sync/proposta/status reais sale não chegam à UI |
| Contrato planejado != implementado | MOB-016 | violada na governança | código permite distinguir fixtures | docs rápidas e Spec 011 contradizem o HEAD |
| Banco físico por user + tenant | MOB-017 | sim | nome determinístico e factory single-active | IDs remotos vazios não são validados antes de formar contexto |

## 4. Inventário por feature

| Feature | Domain | Data | Application | Presentation | API real | Drift | Fixture ativa | Estado |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| auth | sim | sim | sim | sim | sim | abre contexto | não | conectada |
| catalog | sim | sim | sim | sim | sim | sim | não; legado/teste | local-first conectada |
| dashboard | sim | sim | sim | sim | sim | sim | não; legado/teste | local-first conectada |
| sales | sim | sim | sim | sim | sim | sim | **sim, provider padrão** | core infra real desconectada da UI |
| settings | sim | sim | sim | sim | não | não | **sim, provider padrão** | fachada com dados falsos possíveis |
| clients | entidade | fixture | não | não | não | não | sim | scaffold |
| inventory | pastas vazias | pastas vazias | vazio | somente tile | não | não | não | placeholder |
| reports | pastas vazias | pastas vazias | vazio | somente tile | não | não | não | placeholder |

Rastreabilidade dos slices reais:

| Requisito | Spec | Contrato | Camadas/arquivos | Composição/controller/tela | Teste | Estado |
|---|---|---|---|---|---|---|
| sessão Sanctum | 008 | auth + `/me` | `features/auth/**`, `core/network/**` | `authControllerProvider`, router, Login/ChangePassword | auth/app/network | implementado; cobertura inferior ao plano |
| isolamento user/tenant | 008B | DB físico e teardown | `core/database/*`, `app/local_context_lifecycle.dart` | AuthController abre; purge fecha | lifecycle/database | implementado |
| schema de leitura | 009A | v2 | tabelas product/category/dashboard/sync | factory/context | database | implementado; docs stale |
| engine | 009B | lease/checkpoint/stop | `core/sync/**`, stores Drift | context engine + AuthController/ContextSyncScope | sync/lease/checkpoint | implementado parcialmente nos gatilhos |
| catálogo remoto | 009C | cursor estável/tombstone | remote/sync/repository | provider/controller/page | protocol/database/widget | conectado |
| dashboard remoto | 009C | snapshot por scope | remote/sync/repository | provider/controller/page | protocol/database/widget | conectado com apresentação provisória |
| outbox venda | 010 Fase A | create/confirm/replay | sales domain/application/data | somente engine/outbox; sem controller/page real | unit/database/protocol | core implementado, integração incompleta |

## 5. Composition root e lifetimes

```text
ProviderScope único
├── ApiClient/Dio + sinal global de 401                         [root]
├── AuthController                                              [root]
│   ├── login/restore/password/logout
│   ├── DatabaseFactory.open(LocalContext)
│   ├── active token/access/context
│   └── startup SyncEngine
├── DatabaseFactory                                             [root; 1 DB ativo]
├── ContextSyncLifecycle                                        [root; mapa context->engine]
├── contextSyncEngineProvider                                   [contextual lógico]
│   ├── ProductSyncCollection(DB + token capturados)
│   ├── DashboardSyncCollection(DB + token capturados)
│   ├── DriftSyncLeaseStore(DB)
│   └── OutboxProcessor(DB + token capturados)
└── DataPurgeService
    └── stop -> close DB -> clear cache -> invalidate providers
```

Não foi identificado ciclo Riverpod. Foram identificados três composition
roots: `app/local_context_lifecycle.dart`, o próprio `AuthController` e
`sales_sync_composition.dart`. Isso torna ownership e descarte difíceis de
provar.

| Objeto | Lifetime | Risco/materialidade |
|---|---|---|
| Dio/API/storage/auth repository | root | adequado; base URL pode estar vazia |
| DatabaseFactory | root mutável | correto para single-active; reatividade depende de `invalidate` manual |
| active context/token/access | StateProviders root | precisam mudar atomicamente; hoje são três escritas separadas |
| repositories/controllers de tela | providers root | context-bound sem `autoDispose`; lista manual deve invalidar todos |
| engine/collections/outbox processor | contextual lógico | capturam DB/token/acesso imutáveis; uma futura renovação no mesmo contexto pode reutilizar engine antigo |
| `syncStateProvider` | autoDispose | observa `syncEngineProvider`, que é sempre nulo; composição morta |
| router | reconstruído por auth | observa auth e também listener de refresh; ownership redundante |

## 6. Isolamento por usuário e tenant

Nome físico:

```text
app_database_u_<Uri.encodeComponent(userId)>_t_<Uri.encodeComponent(tenantId)>.db
```

| Cenário | DB aberto | Permanece | Limpeza | Outbox | Risco |
|---|---|---|---|---|---|
| A — A/T1 entra | arquivo A/T1 | dados anteriores do par | nenhuma | drena antes das coleções | Settings/vendas continuam fixtures globais |
| B — A sai com pendência | A/T1 até teardown | arquivo e pendências | engine, conexão, cache e providers | exige confirmação de logout; não apaga | logout remoto offline não oferece logout local |
| C — B/T1 entra | arquivo B/T1 | A/T1 intacto e fechado | memória/cache A limpos | somente fila B/T1 | isolamento físico forte; UI fixture igual para todos |
| D — A/T2 entra | arquivo A/T2 | A/T1 e B/T1 intactos | contexto anterior precisa terminar | fila própria A/T2 | troca depende do tenant devolvido por `/me`; sem seletor |
| E — A volta a T1 | reabre A/T1 | catálogo/dashboard/vendas/outbox | cache temporário foi removido | retry elegível volta; acceptance/permanent estacionam | não existe UI para itens estacionados |

A factory recusa abrir outro contexto sobre uma conexão ativa. `purge()` só
fecha o banco depois que `stop()` termina; timeout preserva contexto e DB. O
SQLite nunca é removido no logout. O risco de vazamento entre bancos é baixo;
o risco atual de informação falsa na interface é alto por causa das fixtures.

## 7. Banco Drift real

`schemaVersion = 4`. Banco novo usa `createAll`. Upgrade aceito: `1 -> 4`,
`2 -> 4`, `3 -> 4`; outras combinações falham fechadas. `foreign_keys` é
habilitado em `beforeOpen`.

| Tabela | PK/FK | Índices | Propósito | Retenção atual |
|---|---|---|---|---|
| `sync_outbox` | PK `id` | unique client_request/local_operation; eligibility | fila e protocolo de vendas | indefinida; confirmados não são limpos |
| `categories` | PK `id` | PK | categoria derivada de produto | indefinida; sem tombstone próprio |
| `products` | PK `id`; category SET NULL | PK | catálogo e soft delete | indefinida; `deleted_at` retém histórico |
| `dashboard_snapshots` | PK `scope_key` | PK | snapshot JSON por filtro | um registro por scope; sem eviction |
| `sync_collections` | PK `collection` | PK | cursor/checkpoint/revision | vida do DB contextual |
| `sync_locks` | PK `name` | PK | lease persistido | delete normal; takeover após TTL |
| `local_sales` | PK `id` | unique `client_request_id` | cabeçalho histórico local | indefinida |
| `local_sale_items` | PK autoincrement; FK sale CASCADE | PK | itens históricos | acompanha venda |

Riscos de schema/migração:

- não há índice explícito em `products.category_id` nem
  `local_sale_items.sale_id`;
- `sync_outbox` começou em v1 com apenas id/status; upgrades adicionam campos
  nullable/defaulted, preservando linhas legadas como `legacy_unknown`;
- a 010 não possui `validation-result.md` e o HEAD declara não verificado;
- o `.g.dart` está presente e coerente em superfície com as oito tabelas, mas
  não foi regenerado nem compilado nesta auditoria;
- retenção/eviction de snapshots, confirmados e vendas não está definida.

## 8. Sync Engine real

```text
startup | resumed | manual
  -> rejeita stopped/stopping
  -> SyncLock em memória
  -> cooldown de resumed (5 min)
  -> lease SQLite `global_sync`
       owner aleatório, TTL 2 min, heartbeat 30 s
  -> recover `syncing` órfão
  -> drena outbox
  -> products, se catalog + products_view
  -> dashboard, sempre
  -> para cada página: fetch fora da transação
       -> renew/protect -> dados + checkpoint atômicos -> renew
  -> release em finally
```

Máquina resumida:

| Estado | Evento | Próximo |
|---|---|---|
| idle | trigger aceito | syncing |
| idle | run/lock ocupado | busy (sem alterar stream) |
| idle | resumed no cooldown | throttled |
| syncing | todas as coleções | succeeded |
| syncing | erro tipado/local | failed |
| syncing | cancel/ownership loss | cancelled, com failureKind quando aplicável |
| qualquer ativo | stop | stopping -> stopped |
| stopping | timeout 10 s | permanece stopping; teardown falha e pode repetir |

Confirmado: mutex, lease persistido, TTL, heartbeat, owner check, cancelamento,
stop, timeout, fetch fora de transação, commit protegido, checkpoint após dados
e cooldown de resumed. Ausente: gatilho real de conectividade, health check,
worker/background e estado global visível na UI. Não há observabilidade
estruturada de duração/quantidades além do estado efêmero.

## 9. Outbox e venda

Pipeline implementado:

| Etapa | Arquivo/método | Input/output | Persistência e recovery |
|---|---|---|---|
| criar identidade | `RegisterSaleUseCase.call` | SaleDraft + acesso -> id | UUID único usado como local e client request id |
| validar/persistir | `DriftSalesRepository.register` | IDs numéricos, itens, timezone | uma transação cria sale, items e outbox |
| claim | `claimNextEligible` | pending/retry vencido -> syncing | oldest-first; payload inválido vira permanente |
| envio | `OutboxProcessor.drain` | OutboxSale -> outcome | HTTP fora da transação; writes sob lease |
| create | `SaleIntentsRemoteDataSource.createIntent` | payload v1 | POST `/sale-intents` |
| confirm | `confirmIntent` | intent id + token | POST `/sale-intents/{id}/confirm` |
| recovery | `recoverOrphanedSyncing` | syncing -> pending | preserva identidade, payload e operação |

Pipeline exibido: `SalesController.registerSale()` cria somente `PendingSale`
em memória. Ele não constrói `SaleDraft`, não chama `RegisterSaleUseCase`, não
grava Drift e não dispara sync. A página informa corretamente “somente nesta
sessão”, mas isso comprova que a venda real não está integrada.

### Máquina de estados real

| De | Evento | Para | Automático | Dados preservados |
|---|---|---|---:|---|
| pending/retry vencido | claim | syncing | sim | identidade/payload/operação |
| syncing | 201 confirmado ou replay 200 confirmado | confirmed | sim | payload + IDs remotos quando extraídos; token limpo |
| syncing | 409 requires/changed | requires_acceptance | sim | payload; revision++; envelope hoje não extraído |
| syncing | offline/timeout/5xx/429 | failed_retryable | sim | payload; attempts/backoff |
| syncing | 401 | pending | sim | payload; erro unauthorized; sessão global expira |
| syncing | 403 | failed_permanent | sim | payload/token; erro preservado |
| syncing | 409 insufficient/idempotency, 410, 422 | failed_permanent | sim | payload; token limpo em permanent |
| syncing | cancel lifecycle | pending | sim | payload/operação; sem incrementar attempts |
| syncing | crash/restart | pending | no próximo drain | mesma identidade/payload/operação |
| requires_acceptance | aceite CAS | pending + confirm op | usuário | intent/token/revision |
| confirmação pending | 409 proposal changed | requires_acceptance | sim | intent antigo preservado, token novo hoje ausente |
| qualquer não terminal | cancel local | cancelled | não há caller | token limpo |

Estados órfãos ou sem saída operacional:

- `requires_acceptance`: persistence/CAS existem, mas não há UI e o datasource
  descarta proposal/token do `ProtocolException.data`;
- `failed_permanent`: não existe ação UI de retry/ciência/limpeza;
- `cancelled`: repository suporta, mas não há chamada de produto;
- `confirmed`: não há histórico/consulta UI e 201 pode confirmar sem guardar IDs.

### Idempotência

Veredito: **PARTIALLY PROVEN**.

O núcleo local gera UUID v4 uma vez, usa-o como `client_request_id`, persiste
payload v1 e possui uniques no cabeçalho/outbox. Retry, crash e restart leem o
mesmo JSON e o replay confirmado é reconhecido. A garantia ponta a ponta ainda
depende da semântica idempotente real do backend, do replay em estados não
confirmados e da recuperação segura de `confirmation_token`. Além disso, a UI
atual nem entra nesse núcleo. Não foi encontrado caminho no pipeline
persistente que gere novo UUID durante retry.

### Contrato Laravel auditado

Backend canônico auditado: `CarlosVLemos/gestor_de_estoque`, branch `dev`,
HEAD `4ef4b3ee6374848ff903ce1f467daeff0975b005`. O checkout de leitura estava
limpo.

| Rota | Proteções/contrato real | Compatibilidade mobile |
|---|---|---|
| auth/login/logout/me/password | Sanctum, conta/tenant e password gate conforme rota | substancialmente alinhado |
| `GET /mobile/products` | produto ID numérico; category ID UUID; cursor/checkpoint/tombstones | **incompatível na categoria** |
| `GET /mobile/dashboard` | snapshot + meta/revision/URL | substancialmente alinhado |
| clients | **não existe rota mobile** | blocker confirmado |
| `POST /mobile/sale-intents` | payload v1, IDs numéricos, feature sales + `sales.create` | payload alinhado; UI não chega ao transporte |
| `POST /sale-intents/{id}/confirm` | token, revalidação, 201/200/409/410/422 | datasource não extrai envelope 409 |
| `GET /sale-intents/{id}` | reconciliação autorizada | existe no backend, não implementado no Flutter; não recupera token |

Create integral retorna 201 com `intent`, `sale` e `reconciliation`. Create
parcial retorna 409 com `intent`, `proposal` e `confirmation_token`. O mesmo
`client_request_id` e fingerprint produz replay; payload diferente produz
`idempotency_conflict`. A constraint é por tenant + user + request id e o
processamento usa transação/lock.

Replay confirmado devolve 200 com estado e IDs. Replay/GET em
`requires_confirmation` omite deliberadamente o token, pois o backend guarda
somente seu hash. Confirm pode rotacionar token quando a proposta muda e torna
o token inválido definitivo na quinta tentativa.

## 10. Catálogo 009C

Implementado: IDs de produto numéricos positivos normalizados para String
local, cursor opaco, target checkpoint estável, promoção final,
tombstones/soft delete, upsert que limpa tombstone, preço nullable, masking
financeiro adicional no repository e produto sem estoque preservado.

Cada página aplica tombstones, categorias e produtos, depois promove o
checkpoint na mesma transação. A próxima página usa o target salvo; a página
final move target para checkpoint e limpa cursor/target.

Incompatibilidade P1: o backend usa ID numérico para produto e UUID para
categoria. `RemoteProduct._category()` chama `_requiredRemoteId`, que aceita
somente inteiro/String numérica. Um produto categorizado com UUID causa
`FormatException`, mapeia a página para `invalidData` e impede seu commit. O
contrato 009C congelado também registrou categoria numérica, portanto a
correção requer Change Request.

Outros riscos: SKU vazio é rejeitado; `brand` e `updated_at` aceitam null;
status de estoque desconhecido só falha mais tarde no mapper de domínio;
categorias antigas nunca são removidas; não há índice por categoria; estado
automático de sync não chega à UI.

## 11. Dashboard 009C

```text
GET /api/mobile/dashboard
-> DashboardRemoteDataSource
-> DashboardSyncCollection(scope `day:YYYY-MM:1`)
-> dashboard_snapshots + sync_collections
-> DriftDashboardRepository
-> DashboardController
-> DashboardPage
```

O datasource envia `group_by`, `goal_month` e `page`. O scope e mês são
calculados separadamente no engine e repository, usando `DateTime.now()`. O
snapshot persiste `revision`, generated/reference date, financial flag, URL e
JSON. O repository aplica a permissão atual além da flag remota.

Funcional: snapshot real, refresh local-first, KPIs, alertas, movimentos,
estoque, meta e mascaramento. Provisório: labels são derivados das chaves,
datas usam `DateTime.toString`, tones têm fallback, `web_dashboard_url` não é
acionável e `sales_count` não recebe tratamento explícito. O dashboard não
converte 403 em `restricted`; esse estado existe no controller/page, mas o
repository Drift nunca o produz.

## 12. Autenticação e permissões

Login grava token e consulta `/me`; restore lê token e consulta `/me`; password
change faz PUT e restaura perfil; 401 global limpa token e executa purge;
logout remoto precede purge. O contexto abre antes de ativar sync; se
`must_change_password`, DB abre mas token/sync/acesso operacional ficam nulos.

| Backend/profile | Uso mobile |
|---|---|
| `user.id`, `tenant.id` | nome físico do DB e lifecycle |
| user/tenant nomes/slug/e-mail | shell; Settings ainda mistura fixture |
| `features: catalog` | registra coleção produtos e restringe catálogo |
| `products_view` | registra coleção e restringe repository/UI |
| `view_financial_metrics` | mascara preço/KPIs na leitura e UI |
| `features: sales` | guarda acesso e restringe formulário fixture |
| `sales_create` | guarda acesso e restringe formulário/use case |
| `reports_view` | somente tela Settings fixture; sem módulo |
| `meta.revision` | armazenado em UserSession; sem reação de refresh |
| `must_change_password` | guard dedicado e bloqueio operacional |

Falhas: casts/mapeamento de `/me` e secure storage fora de `ApiException` podem
escapar e deixar o controller resolvendo; IDs vazios não são validados; logout
offline não conclui localmente; uma troca futura de token/permissões no mesmo
contexto pode reutilizar engine capturando valores antigos.

## 13. Fixtures, placeholders e dead code

Classificação A (testes aceitáveis): fakes de transport/store/DB, fixtures de
widget/golden e `FixtureCatalogRepository` usado explicitamente por testes.

Itens C/D/E completos encontrados em `lib/`:

| Classe | Ocorrência | Classificação | Consequência |
|---|---|---|---|
| C | `salesDraftRepositoryProvider` + `sales_draft_fixture.dart` | produção fixture | tela usa `client-1`/`prod-1`, memória e não outbox |
| C/E | Settings provider + fixture access profile | produção fixture/risco | pode exibir tenant e permissões falsos |
| D | `clients_fixture.dart` | dead scaffold | nenhum consumidor; não substitui contrato/API |
| D | catalog/dashboard fixture repositories | legado | provider de produção já usa Drift |
| D/E | `syncEngineProvider` | composição morta | `syncStateProvider` sempre observa null |
| B | busca global por snackbar | UI temporária | ação sem busca |
| B | tiles Estoque/Relatórios | placeholder declarado | indisponíveis |
| D | `NoopSyncLifecycle` | fallback/teste legado | engine real usa `ContextSyncLifecycle` |
| E | TODOs de auth no router | comentários stale | descrevem shell pública que já tem guard |

## 14. Telas e rotas

```text
/  Startup / auth gate
├── /login
├── /change-password
└── /app (StatefulShell)
    ├── /app/dashboard
    ├── /app/products
    ├── /app/sales
    └── /app/more
        └── /app/context
```

| Tela | Fonte/controller | Estados reais | Fixture/ações |
|---|---|---|---|
| Startup | AuthController | loading, unavailable/failure | retry restore |
| Login | AuthController | form, busy, failure | login real |
| Change password | AuthController | form, busy, failure | PUT real |
| Dashboard | Drift/DashboardController | loading, ready, refreshing, empty, offline, failure, restricted | refresh; web URL sem ação |
| Produtos | Drift/CatalogController | loading, ready, refreshing, empty, offline, failure, restricted | filtro/search local + refresh |
| Vendas | fixture/SalesController | formulário ou restricted | cria rascunho só memória |
| Mais | fixture context controller | ready/restricted/failure | contexto; busca snackbar; tiles indisponíveis |
| Contexto | fixture + shell session | loading/ready/restricted/failure | mistura fontes; edita nome local no shell |

Guards funcionam para initializing, unauthenticated, password change e
authenticated. Não há deep links específicos além das rotas; não há redirect
web implementado; os quatro destinos da shell aparecem independentemente de
features/permissões. O router observa auth e também cria um listener de refresh,
recriando `GoRouter` e navigator key a cada mudança de auth.

## 15. Escopo mobile versus web

| Classe | Features identificadas |
|---|---|
| MOBILE NATIVO | auth, perfil/contexto real, shell, catálogo, registro/status de vendas |
| MOBILE LOCAL-FIRST | catálogo, clientes necessários à venda, drafts/vendas/outbox, status e reconciliação |
| VIEW/READ-ONLY MOBILE | dashboard resumido, estoque/alertas dentro de catálogo/dashboard |
| WEB REDIRECT | dashboard completo e relatórios/visões administrativas quando autorizadas |
| FORA DE ESCOPO | administração do ERP, regras finais de estoque, relatórios nativos sem contrato, backend paralelo |

## 16. Testes e architecture test

Inventário estático: 39 arquivos `*_test.dart`, 197 declarações de teste e
aproximadamente 212 casos de runtime contando a matriz parametrizada do
validador. Todos são `NOT_RUN` nesta missão.

| Grupo | Quantidade aproximada | O que prova |
|---|---:|---|
| app/router | 5 | redirects e controllers globais |
| architecture | 23 runtime | imports, estrutura e ícones |
| database/lifecycle | 20 | schema, migrações, isolamento, teardown |
| network | 19 | classificação HTTP, redaction e 401 |
| sync | 11 | mutex, lease, checkpoint, stop, heartbeat |
| auth | 3 | password error e invalidação 401 |
| catalog | 23 | datasource, cursor, transaction, controller/page |
| dashboard | 21 | snapshot, repository, controller/page |
| sales | 38 | 27 no pipeline real e 11 na UI fixture |
| settings | 9 | provider/controller/pages fixture |
| shared/theme/golden | 40 | componentes, formatação, tema e imagens |

Lacunas materiais:

- nenhum teste da composição contextual real ou de login -> engine ->
  collections/outbox;
- provável regressão em `arara_app_test`: sessão autenticada não injeta token
  agora exigido pelo AuthController;
- auth remoto/repository/storage/use cases e telas têm cobertura inferior ao
  plano da 008;
- refresh de catálogo/dashboard usa engine nulo nos testes e não prova sync;
- sem `integration_test/` e sem E2E backend/aparelho;
- sem teste dedicado do observer lifecycle e do cooldown `throttled` de 5 min;
- testes antigos de vendas legitimam explicitamente a fachada em memória;
- docs 009A/009B/010 não registram validação coerente com o HEAD.

O architecture test lê imports. Providers na raiz de feature viram layer
`root`; presentation -> app/core é permitido; exports não são analisados. A
composição 009C adicionou em `app/local_context_lifecycle.dart` imports diretos
dos dois remote datasources, que conflitam com a regra `app` atual. Essas
violações nasceram em `01b1896`, antes da 010. A solução mínima é criar
composition factories por feature, como já existe em sales, e fazer `app`
importar somente essas portas; depois ampliar o validador para classificar
providers/composition e proibir controller -> infraestrutura.

### Inventário arquivo a arquivo

| Arquivo de teste | Spec principal | O que prova estaticamente | Tipo |
|---|---|---|---|
| `app/app_controllers_test.dart` | 003–006 | controllers globais/shell | unit |
| `app/arara_app_test.dart` | 008 | redirects auth; provável fixture de token stale | integration |
| `architecture/icons_encapsulation_test.dart` | 005 | encapsulamento de ícones | architecture |
| `architecture/layer_boundaries_test.dart` | 001/007+ | regras de import | architecture |
| `architecture/project_structure_test.dart` | 001 | árvore canônica | architecture |
| `core/database/app_database_test.dart` | 009A/009B/010 | schema novo, migrações v1/v2/v3, fail-closed | database |
| `core/database/drift_sync_checkpoint_store_test.dart` | 009B | dados + checkpoint atômicos | database |
| `core/database/drift_sync_lease_store_test.dart` | 009B | acquire/renew/takeover/owner | database/protocol |
| `core/database/local_context_lifecycle_test.dart` | 008B/009B | isolamento, purge, concorrência e stop | lifecycle |
| `core/network/api_client_test.dart` | 007/008/010 | erros HTTP, 401, protocol body, redaction | protocol |
| `core/sync/sync_engine_test.dart` | 009B/010 | mutex, lease, heartbeat, stop, outbox e collections | lifecycle/integration |
| `features/auth/auth_controller_test.dart` | 008/008B | troca de senha e invalidação 401 | lifecycle |
| `features/catalog/catalog_controller_test.dart` | 003/009C | concorrência de load, filtros e estados | unit |
| `features/catalog/catalog_page_states_test.dart` | 009C | empty/offline/restricted/failure | integration/widget |
| `features/catalog/catalog_page_test.dart` | 003/009C | produto/preço restrito | integration/widget |
| `features/catalog/fixture_catalog_repository_test.dart` | 003 | repositório legado fixture | unit/stale |
| `features/catalog/product_remote_data_source_test.dart` | 009C | cursor e IDs/envelope | protocol |
| `features/catalog/product_sync_collection_test.dart` | 009C | páginas, tombstone, checkpoint e masking | database/integration |
| `features/dashboard/dashboard_controller_test.dart` | 003/009C | estados e concorrência de refresh | unit |
| `features/dashboard/dashboard_page_states_test.dart` | 009C | estados e formatação | integration/widget |
| `features/dashboard/dashboard_page_test.dart` | 003/009C | layout/conteúdo | integration/widget |
| `features/dashboard/dashboard_remote_data_source_test.dart` | 009C | parâmetros e envelope | protocol |
| `features/dashboard/dashboard_sync_collection_test.dart` | 009C | scope, snapshot, rollback e conversões | database/integration |
| `features/sales/drift_sales_repository_test.dart` | 010 | atomicidade, claim, CAS, recovery e identidade | database |
| `features/sales/outbox_processor_test.dart` | 010 | sequência, retry, cancel, acceptance | unit/protocol |
| `features/sales/register_sale_use_case_test.dart` | 010 | autorização e UUID único | unit |
| `features/sales/sale_intents_remote_data_source_test.dart` | 010 | payload e classificação HTTP/replay | protocol |
| `features/sales/sales_controller_test.dart` | 003/006 | fluxo fixture em memória | unit/stale |
| `features/sales/sales_page_test.dart` | 003/006 | UI fixture, restrição e reflow | widget/stale |
| `features/settings/module_status_tile_test.dart` | 003/006 | reflow de tile | widget |
| `features/settings/more_page_test.dart` | 003/006 | estado da fachada fixture | widget/stale |
| `features/settings/operational_context_controller_test.dart` | 003/008 | estados do repository fixture | unit/stale |
| `features/settings/operational_context_page_test.dart` | 003/006 | contexto fixture e reflow | widget/stale |
| `goldens/visual_goldens_test.dart` | 004–006 | seis snapshots visuais | widget/golden |
| `shared/formatters_test.dart` | 003–006 | moeda, data e estoque | unit |
| `shared/widgets/animated_state_switcher_test.dart` | 004–006 | transições de estados | widget |
| `shared/widgets/operational_widgets_test.dart` | 003–006 | componentes, acessibilidade e reflow | widget |
| `theme/app_theme_context_test.dart` | 002/005 | extensão de tema | widget |
| `theme/app_theme_test.dart` | 002/004/005 | tokens, tema e guardrails | unit/architecture |

Não existem testes de integração em `integration_test/`. Não foram encontrados
arquivos de Change Request nas Specs 008–010; mudanças congeladas aparecem
somente nos próprios contratos/reviews e histórico Git.

## 17. Dívida priorizada e blockers

| ID | Sev. | Problema/evidência | Impacto | Spec |
|---|---|---|---|---|
| P0-01 | P0 | Settings usa fixture junto da sessão | contexto/permissão falsos | hardening contextual |
| P0-02 | P0 | UI de vendas não chama pipeline 010 | perda do rascunho; sem venda real | vertical de vendas |
| P0-03 | P0 | acceptance/permanent invisíveis e sem ação | venda pode ficar parada indefinidamente | reconciliação |
| P0-04 | P0 | confirmation token/replay incompleto | confirmação não recuperável após restart | backend handoff + reconciliação |
| P1-00 | P1 | categoria UUID backend é rejeitada como ID não numérico | páginas de produtos categorizados não sincronizam | CR 009C + hotfix catálogo |
| P1-01 | P1 | clientes reais ausentes | IDs fixture são rejeitados antes da persistência | clientes local-first |
| P1-02 | P1 | syncState observa provider nulo | falha/startup/progresso invisíveis | composição contextual |
| P1-03 | P1 | docs rápidas e Spec 011 contradizem HEAD | próxima execução pode regredir o projeto | governança |
| P1-04 | P1 | Android release sem INTERNET | APK release não acessa API | release |
| P1-05 | P1 | sem validação do HEAD 010 | risco de compile/regressão desconhecido | QA/hardening |
| P1-06 | P1 | router/composição capturam lifecycle redundante | reuso de token/permissão stale futuro | composição contextual |
| P1-07 | P1 | URL API vazia não falha cedo | auth/sync falham genericamente | release/env |
| P2-01 | P2 | boundary test incompleto/desalinhado | confiança arquitetural falsa | hardening arquitetura |
| P2-02 | P2 | controllers root + invalidação manual | risco de estado entre contextos em feature futura | composição contextual |
| P2-03 | P2 | retenção e índices não definidos | crescimento/performance | hardening DB |
| P2-04 | P2 | dashboard mapeia contrato de forma heurística | labels/tones/datas frágeis | UI dashboard |
| P3-01 | P3 | busca, web redirect e status global ausentes | app pouco apresentável | UX/polish |

### Blockers conhecidos validados no mobile

`BLOCKER-010-CLIENTS` entra em nova tabela/migração, datasource/collection,
repository/use case e picker de vendas. A feature clients atual só possui
entidade e fixture; não há preparação de data/application/presentation real.

`BLOCKER-010-CONFIRMATION-RECOVERY` entra em `ApiClient/ProtocolException`,
`SaleIntentsRemoteDataSource`, outcome/persistência, query de detalhe/replay,
OutboxProcessor e UI de proposta. Há colunas e CAS preparados, mas o datasource
intencionalmente não extrai o envelope 409, embora `ApiClient` já preserve o
body. Portanto até o primeiro 409 funcional estaciona com intent/token nulos e
o CAS não pode aceitar. Separadamente, replay e GET reais omitem o token; após
timeout/crash antes da persistência não existe recovery seguro no backend.

### Checklist HANDOFF-010-BACKEND

- [ ] branch/commit e contrato FROZEN do backend
- [ ] clients route/método
- [ ] auth/middlewares/tenant scope
- [ ] features e permissões exatas
- [ ] paginação, cursor e janela/checkpoint
- [ ] tipos de client ID e campos JSON/nullability
- [ ] confirmar produto ID numérico e category ID UUID
- [ ] ordenação estável e limites
- [ ] estratégia de remoção/tombstones/inativos
- [ ] erro de cursor, tenant, permissão e validação
- [ ] create-intent payload e response 201
- [ ] requires_confirmation body completo
- [ ] stock_proposal_changed body completo
- [ ] idempotent replay para cada estado possível
- [ ] forma segura de recuperar confirmation token após restart
- [ ] expiração, rotação, uso único e número de tentativas do token
- [ ] intent/proposal/sale IDs e tipos
- [ ] proposal items, preços/estoque e revision/hash
- [ ] confirm request/response e revalidação de estoque
- [ ] GET detail/reconciliation e autorização
- [ ] 401/403/409/410/422/429/5xx semânticos
- [ ] garantia idempotente transacional por tenant + client_request_id
- [ ] logs/redaction e ausência de segredo em mensagem

## 18. Roadmap mestre

Antes de nova implementação, marcar `011-de-volta-ao-jogo` como
`superseded/rejected` e atualizar os snapshots de contexto. Isso é correção de
governança, não uma feature.

| Ordem | Spec proposta | Problema/objetivo | Dependências | Escopo / fora de escopo | Camadas | Risco/aceite | Tam. |
|---:|---|---|---|---|---|---|:---:|
| 1 | 012 — Correção contratual do catálogo | voltar a sincronizar categorias reais | CR 009C | UUID de categoria, parser e testes; sem UI nova | catalog remote/sync/contract | página com categoria UUID comita e retoma | S |
| 2 | 013 — Composição contextual e Settings real | remover dados falsos e ligar estado do engine | 012 | scope operacional atômico, settings/session, sync state, factories; sem venda | app/auth/settings/core sync | troca/logout sem estado stale; UI mostra sessão real | M |
| 3 | Backend HANDOFF-010 | criar clients e tornar token recuperável | decisão backend | contrato/implementação Laravel; sem Dart | backend/contract | checklist completo e testes backend | M |
| 4 | 014 — Clientes local-first | fornecer cliente remoto válido | handoff clients + 013 | schema v5, sync, repository, picker; sem venda | DB/clients/sync/UI | cursor/tombstone/tenant/offline | M |
| 5 | 015 — Vertical persistente de venda | unir tela e 010 | 014 | produtos/clientes Drift, RegisterSaleUseCase, lista persistida, trigger; sem aceite | sales/app composition/UI | commit antes de limpar carrinho; restart preserva | M |
| 6 | 016 — Proposta, aceite e recovery | concluir protocolo 409/replay | handoff confirmation + 015 | parse 409, reconcile GET, CAS, accept/confirm; sem histórico amplo | network/sales/DB/UI | nenhum auto-aceite; token recuperável/redacted | M |
| 7 | 017 — Histórico e ações da outbox | tornar estados operáveis | 016 | status, retry/ciência/cancel conforme regra; sem relatórios | sales repository/controller/UI | todos os estados têm saída segura | M |
| 8 | 018 — Navegação, escopo e web redirects | respeitar features e evitar scope creep | 013 | destinos gated, URL launcher, dashboard completo web | router/settings/dashboard | deep links/URLs validados | S |
| 9 | 019 — UX offline e gatilhos | tornar sync compreensível/resiliente | 015-017 | health check, connectivity trigger, banner/progresso/stale | core sync/controllers/shared | conteúdo local preservado; retry controlado | M |
| 10 | 020 — Hardening DB/arquitetura/QA | fechar riscos estruturais | anteriores | migrations, retention/indexes, validator/composition tests, auth gaps | transversal | gate focado + analyze + suíte autorizada | M |
| 11 | 021 — Release candidate | APK instalável e conectado | 020 + VPS HTTPS | INTERNET, app id, signing, env, versão, smoke | Android/release/docs | smoke completo em endpoint implantado | M |

### Caminho crítico

```text
HOJE
-> corrigir governança da Spec 011
-> 012 correção category UUID
-> 013 composição/Settings
-> HANDOFF backend
-> 014 clientes
-> 015 venda persistente
-> 016 aceite/recovery
-> 019 offline/sync UX
-> 020 hardening e gate
-> MVP funcional
-> 017/018 e polish dashboard/catalog
-> 021 release candidate
```

Indispensável: 012–016, gatilhos/UX mínimos de 019, hardening e release.
Pode esperar: histórico amplo, estoque dedicado, cache de imagens, background.
Polish: labels/tones/datas, busca global, animações adicionais e goldens finais.

## 19. Plano futuro de UI

| Tela | Dados/estado | Reuso | Ações/fontes |
|---|---|---|---|
| Dashboard | snapshot Drift + SyncState; loading/empty/offline/failure/restricted/stale | KPI, section, banners, badges | refresh; abrir URL backend validada |
| Produtos | products/categories Drift + sync | ProductCard/filter/empty/failure/offline | busca/filtro local, refresh; backend só via sync |
| Vendas | clients/products + local sales/outbox Drift | cards/badges/bottom sheets | persistir, retry, revisar/aceitar; backend via processor |
| Mais/Contexto | UserSession/scope real | tenant/permission/module tiles | logout, conta, web redirects |
| Startup/Login | auth + abertura/teardown contextual | padrões atuais | retry, login, password change; sem abrir shell cedo |

## 20. Não construir no mobile

- administração completa do ERP, usuários, tenants, catálogo ou permissões;
- dashboard web completo e relatórios analíticos nativos sem contrato;
- decisão local final de estoque, preço, autorização ou confirmação;
- backend paralelo, endpoint de categorias inventado ou refresh token presumido;
- garantia de entrega baseada apenas em background;
- imagens como BLOB no SQLite;
- edição administrativa de estoque como extensão do catálogo de leitura;
- fluxos para features vazias apenas para preencher a navegação.

## 21. Cleanup futuro

Na 013: provider/fixture de Settings, `syncEngineProvider` morto, comentários
TODO stale do router e composition roots duplicados. Na 014/015: clients e
sales draft fixtures/providers, PendingSalesController e modelos redundantes
de venda em memória. Na 020: fixture repositories antigos de catálogo e
dashboard se nenhum teste ainda justificar sua retenção, Noop lifecycle não
usado, imports/helpers mortos e atualização dos documentos 009A/B/C/010.

## 22. Dez riscos se o APK fosse publicado amanhã

1. produtos categorizados podem impedir o sync por UUID rejeitado;
2. release Android sem permissão INTERNET;
3. venda exibida é descartada ao fechar e nunca chega à outbox/API;
4. Settings pode mostrar outra empresa/permissões fixture;
5. nenhum cliente remoto válido pode ser selecionado;
6. propostas/falhas permanentes ficam invisíveis e o token não é recuperável;
7. sync automático falha sem estado visível e sem connectivity trigger;
8. HEAD 010 não possui gate executado/registrado e há regressão provável em teste de app;
9. `applicationId` de exemplo e assinatura debug impedem distribuição adequada;
10. API base URL vazia/HTTPS/VPS/smoke não foram validados.

## 23. Matriz de prontidão

| Área | Nota | Justificativa |
|---|---:|---|
| Auth | 7/10 | fluxo real e guards existem; parsing, cobertura e logout offline precisam hardening |
| Database | 8/10 | schema/migrações relevantes; falta gate atual, retenção e índices |
| Isolation | 8/10 | DB físico e teardown fortes; fixtures e invalidação manual reduzem confiança |
| Sync | 7/10 | lease/checkpoint/stop sólidos; faltam estado UI, connectivity/background e composição testada |
| Catalog | 5/10 | vertical existe, mas categoria UUID real pode invalidar a sincronização |
| Dashboard | 7/10 | vertical real; mapeamento/apresentação e redirect ainda provisórios |
| Sales core | 7/10 | atomicidade, retry e replay implementados isoladamente |
| Sales E2E | 1/10 | UI não usa o core e clientes/aceite estão bloqueados |
| Offline | 5/10 | leitura/cache e outbox existem; fluxo operacional completo não |
| UI | 6/10 | shell/estados/componentes bons; dados falsos e vendas provisórias |
| Tests | 6/10 | boa amplitude isolada; sem execução atual, composição ou E2E |
| Release readiness | 1/10 | manifest, identidade, assinatura, ambiente e smoke bloqueiam release |

## 24. Veredito final

`FOUNDATION HAS CRITICAL BLOCKER`

A fundação de auth/DB/sync é saudável o bastante para continuar, mas o catálogo
tem uma incompatibilidade real de ID; publicar ou chamar o app de operacional
também expõe dados contextuais fixture e uma tela de venda sem persistência.
Clientes e recovery de confirmação exigem handoff backend. A próxima Spec deve
corrigir o contrato do catálogo; depois, consolidar o contexto real e seguir o
contrato backend até a vertical de vendas ponta a ponta.
