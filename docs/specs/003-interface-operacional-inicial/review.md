# Spec 003 - Revisao

## Status

Implementacao concluida com validacao parcial do toolchain Flutter.

## Escopo previsto

- shell operacional com bottom navigation;
- dashboard resumido;
- catalogo de produtos;
- contexto operacional;
- tela `Mais`;
- componentes compartilhados documentados;
- comentarios objetivos para futura protecao de rotas.

## Ferramentas e ambiente

- Documentacao local do projeto:
  - `para mobile/00-contexto-operacional.md`
  - `para mobile/02-definicoes-de-interface.md`
  - `para mobile/04-regras-e-necessidades-mobile.md`
  - `para mobile/05-arquitetura-mobile.md`
  - `para mobile/06-registro-decisoes.md`
  - `para mobile/08-processo-de-trabalho.md`
- Docs de biblioteca consultadas:
  - `go_router` via Context7 para confirmar shell com bottom navigation.
- Toolchain local:
  - Flutter: `3.44.1` (lido de `.dart_tool/package_config.json`)
  - Dart: `3.12.1` (`dart.exe --version`)
  - Plataforma: Windows
  - Modo de dados: fixture local explicita por feature
- Fallbacks:
  - `flutter.bat` falhou por nao localizar `git` no `PATH` da sessao;
  - `dart.exe` do cache do Flutter foi usado para `analyze` e `format`;
  - o snapshot do `flutter_tools` foi usado para executar a suite de testes;
  - a rerodada final da suite Flutter nao foi autorizada porque exige acesso ao
    lockfile do SDK fora do workspace.

## Arquivos principais

- `lib/app/router/app_router.dart`
- `lib/app/router/app_routes.dart`
- `lib/app/startup/startup_controller.dart`
- `lib/app/startup/startup_page.dart`
- `lib/core/config/fixture_access_profile.dart`
- `lib/features/catalog/`
- `lib/features/dashboard/`
- `lib/features/settings/`
- `lib/shared/formatters/`
- `lib/shared/ui_states/view_status.dart`
- `lib/shared/widgets/`
- `test/app/arara_app_test.dart`
- `test/features/catalog/catalog_page_test.dart`
- `test/features/dashboard/dashboard_page_test.dart`
- `test/features/settings/operational_context_page_test.dart`

## Testes e validacoes

- `dart format lib test docs/specs/003-interface-operacional-inicial`
  - executado com sucesso
- `dart analyze`
  - executado com sucesso
- `flutter test` via `flutter_tools.snapshot`
  - primeira execucao revelou problemas arquiteturais e testes desatualizados
  - problemas corrigidos na implementacao
  - rerodada final bloqueada por negacao de permissao ao lockfile do SDK
- Validacao visual manual em navegador/emulador
  - nao executada nesta sessao

## Componentes compartilhados criados

- `AppShellScaffold`
- `AppBottomNavigation`
- `SectionHeader`
- `StatusBadge`
- `EmptyStateCard`
- `FailureStateCard`
- `OfflineStateBanner`
- `RestrictedInfoCard`
- `KpiCard`
- `ProductCard`
- `MovementListItem`
- `TenantContextCard`
- `FeaturePill`
- `PermissionListTile`

## Limitacoes

- login mobile por token continua fora de escopo;
- chamadas autenticadas de producao dependem da futura spec de autenticacao;
- CTA de abrir o dashboard web permanece local e sem integracao real com
  navegador externo;
- fixtures continuam controladas localmente e nao representam payload validado
  em producao;
- validacao visual completa e rerodada final da suite Flutter ficaram
  pendentes por limitacao/permissao do ambiente do SDK.

## Desvios

- o caminho de testes usou `flutter_tools.snapshot` em vez de `flutter.bat`
  por falha de ambiente no bootstrap do SDK;
- a protecao real de rotas nao foi implementada e ficou sinalizada por
  comentarios `TODO(auth)` no router, conforme escopo da spec.

## Veredito

Spec 003 implementada em codigo com shell operacional, dashboard, catalogo,
contexto operacional, tela `Mais`, fixtures explicitas e componentes
compartilhados documentados. A analise estatica passou. A suite Flutter
identificou falhas intermediarias e elas foram corrigidas, mas a rerodada final
ficou pendente por permissao negada ao lockfile do SDK.
