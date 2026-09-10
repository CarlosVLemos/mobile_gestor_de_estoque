# ARARA MOBILE — STABILIZATION REPORT

## Repository

* Branch: `dev`
* HEAD inicial: `1e99be90d805435e420bd2ef3276ca36b953f980`
* Working tree inicial: já continha a governança 011/012 em elaboração, a auditoria mestre não rastreada e diferenças cosméticas em `analysis_options.yaml` e `pubspec.lock`; tudo foi preservado.
* Working tree final: estabilização, testes, goldens e documentação revisados para um commit dedicado; diferenças cosméticas preexistentes e diagnósticos de golden ficam fora dele.
* Backend auditado: `CarlosVLemos/gestor_de_estoque`, `dev@4ef4b3ee6374848ff903ce1f467daeff0975b005`.
* Ambiente: Flutter 3.47.3, Dart 3.13.3, Linux.

## Changes already present before this run

* autenticação real da 008 e isolamento físico por usuário/tenant da 008B;
* schema Drift e migrações iniciados pela 009A no commit `1a7ac67`;
* SyncEngine/lease/lifecycle da 009B no commit `615e398`;
* catálogo e dashboard local-first da 009C nos commits `01b1896` e `620a223`;
* Fase A de vendas/outbox da 010 nos commits `4d8f312` e `1e99be9`;
* Spec 011 ainda descrevendo uma fundação anterior ao estado real;
* preparação documental da 012 e diferenças locais preexistentes, preservadas no inventário inicial.

## Bugs confirmed and fixed

### STAB-001 — Category UUID rejeitada

* severidade: P1, bloqueador funcional do catálogo;
* causa: o mesmo parser numérico era usado para Product, Category e tombstone;
* arquivos: `product_remote_data_source.dart` e testes de datasource/sync;
* correção: helpers semânticos separados; Product/tombstone continuam numéricos e Category exige UUID;
* teste: perfil de catálogo com 13 testes, incluindo `550e8400-e29b-41d4-a716-446655440000`, upsert e FK.

### STAB-002 — Settings apresentava contexto fixture

* severidade: P1, identidade/permissões incorretas;
* causa: repository fixture permanecia como provider padrão apesar de `UserSession` real;
* arquivos: `settings_providers.dart`, `current_operational_context_repository.dart`, fixtures removidas e testes;
* correção: adaptação direta da sessão autenticada, sem nova chamada HTTP e sem fallback;
* teste: repository e página cobrem sessão real e indisponibilidade sem sessão.

### STAB-003 — Estado observável desconectado do SyncEngine

* severidade: P1, observabilidade incorreta;
* causa: `syncStateProvider` observava um provider nulo diferente do engine contextual;
* arquivos: `context_sync_scope.dart`, composition root e teste de escopo;
* correção: override com a mesma instância registrada no lifecycle;
* teste: `context_sync_scope_test.dart` comprova identidade da instância e perfil autenticado.

### STAB-004 — Violações do boundary em app

* severidade: P1, arquitetura;
* causa: composition root concreto estava em arquivo comum de `lib/app`;
* arquivos: `lib/app/composition/local_context_composition.dart`, shim `local_context_lifecycle.dart` e validator;
* correção: bindings movidos para diretório de composição explícito sem criar segundo engine/lifecycle;
* teste: 15 testes arquiteturais aprovados.

### STAB-005 — Manifest Android sem INTERNET

* severidade: P1, release/runtime;
* causa: permissão ausente do manifest principal;
* arquivo: `android/app/src/main/AndroidManifest.xml`;
* correção: inclusão de `android.permission.INTERNET`;
* teste: inspeção do manifest e suíte de aplicação verde.

### STAB-006 — Testes funcionais e goldens stale

* severidade: P2, gate de regressão;
* causa: testes ainda pressupunham composição fixture e seis masters divergiam da rasterização atual;
* arquivos: testes de app/catálogo/settings e seis arquivos em `test/goldens/goldens/`;
* correção: dependências fixture ficaram explícitas apenas nos testes; masters foram comparados visualmente e atualizados;
* teste: suíte completa final com zero falhas.

### STAB-007 — Cobertura incompleta dos gatilhos da 009B

* severidade: P2, evidência de lifecycle;
* causa: não havia caso direto que distinguisse cooldown de `resumed` e bypass manual;
* arquivo: `test/core/sync/sync_engine_test.dart`;
* correção: caso cobrindo `startup`, `resumed` throttled e manual;
* teste: 12 testes focados do SyncEngine aprovados.

## Findings proven false

* Drift, SyncEngine e outbox não estavam ausentes; a Spec 011 usava uma fotografia anterior às Specs 009/010.
* Catálogo e dashboard não usam fixture como fonte padrão de produção; observam Drift. Os repositories fixture remanescentes são legado/teste.
* Category UUID não exige migração: `categories.id` e `products.category_id` já são textuais.
* Product e tombstone não devem aceitar UUID: o backend mantém IDs inteiros nessas entidades.
* Replay confirmado não está genericamente bloqueado: o caso estrito `idempotent_replay + intent.state=confirmed` já é aceito e testado. O recovery do token de confirmação continua bloqueado.

## Specs

### 008

Status: `DONE`. Auth Sanctum, secure storage, restauração, `/me`, guards e teardown permanecem cobertos pela suíte.

### 009A

Status: `DONE / VALIDATED`. Schema atual v4, migrações v1/v2/v3 → v4 e preservação da outbox passaram.

### 009B

Status: `DONE / VALIDATED`. Mutex, lease, heartbeat, ownership, checkpoint, cancelamento, stop e gatilhos de foreground passaram.

### 009C

Status: `IN PROGRESS — CR-009C-001`. A entrega original permanece; a correção de Category UUID passou nos testes e aguarda análise estática para voltar a `DONE / VALIDATED`.

### 010

Status: `PHASE A VALIDATED / E2E BLOCKED`. O núcleo persistente está verde. Clientes, recovery de confirmação e conexão da UI impedem fechar a Spec completa.

### 011

Status: `SUPERSEDED`. Permaneceu draft, sem contrato FROZEN e sem implementação própria. 009A/009B/009C/010 absorveram seu escopo nos commits registrados em `supersession.md`.

### 012

Status: `IMPLEMENTED / PASSED_WITH_RESTRICTIONS`. Todos os critérios funcionais passaram; `flutter analyze --no-pub` é o único gate interno pendente para aceitar o CR.

### 013

Status: `IMPLEMENTED / PASSED_WITH_RESTRICTIONS`. Contexto real, engine observável e boundaries passaram; análise estática pendente.

### 013D

Status: `PAUSED — PLANNED, NOT IMPLEMENTED`. O contrato do runtime demo sem API foi preservado, mas o código parcial foi removido para não misturar uma entrega incompleta à estabilização.

## Tests

* `flutter test test/features/sales/drift_sales_repository_test.dart`: PASS, 11.
* `flutter test test/features/sales/outbox_processor_test.dart`: PASS, 6.
* `flutter test test/features/sales/sale_intents_remote_data_source_test.dart`: PASS, 8.
* `flutter test test/core/database/app_database_test.dart`: PASS, 9.
* perfil de catálogo antes da correção: PASS, 9.
* perfil de catálogo depois da correção: PASS, 13.
* `flutter test --no-pub test/architecture`: PASS, 15 após a correção do composition root.
* perfil combinado Settings/app/arquitetura: PASS, 35.
* `flutter test --no-pub test/core/sync/sync_engine_test.dart`: PASS, 12.
* `flutter test --no-pub`: PASS, 220.

A primeira suíte completa encontrou oito falhas: duas expectativas stale de composição e seis goldens. As causas foram corrigidas e a suíte passou com 219 testes. Após adicionar o caso final dos gatilhos, o perfil focado e a suíte completa foram repetidos, chegando a 220 testes aprovados.

## Flutter test final

```text
tests: 220
passed: 220
failed: 0
```

Comando: `/home/carlos/develop/flutter/bin/flutter test --no-pub`.

## Flutter analyze

Resultado: `NOT_RUN — PERMISSION REVIEW REJECTED`.

Comando preparado: `/home/carlos/develop/flutter/bin/flutter analyze --no-pub`. A revisão automática recusou a execução por causa da instrução anterior que proibia `analyze`; é necessária autorização explícita atual.

## Drift

* schema version: `4`;
* migration paths: `v1 → v4`, `v2 → v4`, `v3 → v4`;
* codegen state: alinhado ao HEAD; `app_database.dart` e `app_database.g.dart` não têm diff;
* codegen executado: não, pois não houve schema change.

Os warnings do Drift aparecem em testes que abrem múltiplas conexões deliberadamente para migração/concorrência e não causaram falha.

## Sales integrity

* atomic persistence: venda, itens e outbox na mesma transação;
* client_request_id: gerado uma vez, persistido e preservado em retry/restart/cancelamento;
* retry: oldest-first, attempts, backoff e jitter cobertos;
* replay: somente `idempotent_replay` com intent confirmado vira `confirmed`;
* crash recovery: `syncing` é recuperado mantendo identidade, payload e operação;
* 403: bloqueia sem apagar token, intent, payload, operação ou identidade;
* lifecycle cancel: devolve a operação a estado retomável sem attempts/backoff.

## Fixtures still present in production paths

* `FixtureSalesDraftRepository` continua provider padrão da tela de vendas.
* O fluxo visual de pendências usa `PendingSalesController` em memória.
* `sales_draft_fixture.dart` contém clientes/produtos locais fictícios consumidos pelo repository de draft.
* Repositories e dados fixture de catálogo/dashboard permanecem nos paths de produção como legado/utilitários, mas não são providers padrão.
* `core/config/fixture_access_profile.dart` permanece alcançável por esses repositories fixture, sem participar da composição real autenticada.

Nenhuma dessas fixtures alcança o transporte real. O repository Drift rejeita IDs como `client-1` e `prod-1` antes de persistir.

## Backend blockers

* `BLOCKER-010-CLIENTS`: não existe contrato/rota auditada `GET /api/mobile/clients`.
* `BLOCKER-010-CONFIRMATION-RECOVERY`: replay/GET não devolvem o token de confirmação necessário para recovery seguro; `stock_proposal_changed` também exige o contrato real.

## Mobile blockers

* análise estática global ainda não executada;
* tela de vendas ainda não chama `RegisterSaleUseCase -> DriftSalesRepository -> Outbox`;
* o datasource ainda não materializa todo o envelope recuperável de confirmação, dependente do handoff backend.

## Demo Runtime

* implementação: planejada na Spec 013D; nenhum código parcial integra esta entrega;
* ativação futura: `flutter run --dart-define=APP_MODE=demo`;
* API e `API_BASE_URL`: o runtime atual continua dependendo da composição normal; o demo planejado não dependerá deles;
* autenticação planejada: sessão local explícita, sem token remoto;
* isolamento planejado: contexto e banco próprios para `demo-user/demo-tenant`;
* seed planejado: coleção idempotente do SyncEngine com IDs contratuais;
* catálogo/dashboard: deverão consumir os repositories Drift existentes;
* vendas: deverão usar o pipeline persistente, outbox e gateway determinístico sem Dio;
* indicador: banner global e identificação em Settings;
* chamadas HTTP no demo: `NOT VERIFIED`, porque o runtime ainda não foi implementado;
* isolamento da produção: código de produção normal permanece sem composição demo;
* testes: `NOT_RUN` para a 013D;
* limitações: parser, composição, sessão, seed, UI, gateway, testes e documentação de execução ainda precisam ser implementados;
* verdict: `DEMO BLOCKED`.

## Non-blocking technical debt

* gatilho de connectivity, health check e background;
* apresentação de estado de sync/outbox;
* cleanup posterior dos repositories fixture de catálogo/dashboard;
* warnings do harness Drift com conexões deliberadamente concorrentes;
* polish de dashboard;
* applicationId, signing, API_BASE_URL, HTTPS/VPS e smoke de release;
* arquivos diagnósticos versionados em `test/goldens/failures/` foram regravados pela execução que encontrou divergências e permanecem no working tree para decisão humana.

## Files modified

* production:
  * manifest Android;
  * composition root/context sync scope;
  * parser do catálogo;
  * Settings repository/providers;
  * remoção das fixtures Settings e marcadores residuais;
* tests:
  * catálogo UUID/FK/tombstone/checkpoint;
  * contexto/Settings/boundaries;
  * gatilhos do SyncEngine;
  * testes stale de app/catálogo;
  * seis golden masters e artefatos diagnósticos gerados;
* generated:
  * nenhum arquivo Drift/codegen alterado;
* documentation:
  * Specs 009A, 009B, 009C, 010, 011, 012 e 013;
  * `.agents/quick-context.md`, `contexto.md`, `para mobile/00-contexto-operacional.md`;
  * auditoria mestre e este relatório.

`analysis_options.yaml` e `pubspec.lock` já continham diferenças cosméticas no working tree inicial.

## Git operations

Staging, commit local e push foram autorizados explicitamente após a auditoria. Nenhum merge, rebase, reset, checkout ou restore faz parte desta entrega.

## Final verdict

`FOUNDATION VALIDATED — MOBILE INTEGRATION WORK REMAINS`

Os 220 testes comprovam a fundação, o catálogo corrigido, o contexto real, o SyncEngine e o núcleo da outbox. A análise estática ainda precisa ser executada para fechar 009C/012/013, e vendas ponta a ponta continuam dependentes do backend de clientes, do recovery de confirmação e da posterior conexão da UI.
