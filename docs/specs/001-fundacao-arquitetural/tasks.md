# Spec 001 - Tarefas

## Preparação

- [x] Confirmar que a árvore de trabalho não contém mudanças conflitantes.
- [x] Registrar as versões atuais de Flutter e Dart usadas na implementação.
- [x] Resolver versões compatíveis de `flutter_riverpod` e `go_router`.
- [x] Confirmar que não surgiu decisão nova ou dependência aberta bloqueante.
- [x] Registrar no `review.md` os MCPs disponíveis e os fallbacks usados.

## Dependências

- [x] Adicionar `flutter_riverpod`.
- [x] Adicionar `go_router`.
- [x] Executar `flutter pub get`.
- [x] Confirmar que nenhuma dependência fora do escopo foi adicionada.

## Fundação

- [x] Simplificar `lib/main.dart`.
- [x] Criar `lib/bootstrap.dart`.
- [x] Criar `lib/app/arara_app.dart`.
- [x] Garantir que `ProviderScope` seja criado no bootstrap.
- [x] Garantir que `AraraApp` use `MaterialApp.router`.

## Estrutura de `app`

- [x] Criar `lib/app/router/`.
- [x] Criar `lib/app/theme/`.
- [x] Criar `lib/app/localization/`.
- [x] Criar `lib/app/startup/` para a tela transitória.
- [x] Usar `.gitkeep` somente nos diretórios sem arquivo real.
- [x] Criar `lib/app/localization/app_strings.dart`.
- [x] Centralizar textos iniciais para futura localização.
- [x] Não definir idiomas além de `pt-BR`.

## Estrutura de `core`

- [x] Criar `lib/core/auth/`.
- [x] Criar `lib/core/background/`.
- [x] Criar `lib/core/config/`.
- [x] Criar `lib/core/database/`.
- [x] Criar `lib/core/errors/`.
- [x] Criar `lib/core/images/`.
- [x] Criar `lib/core/logging/`.
- [x] Criar `lib/core/network/`.
- [x] Criar `lib/core/result/`.
- [x] Criar `lib/core/security/`.
- [x] Criar `lib/core/sync/`.
- [x] Materializar diretórios sem inventar implementações.
- [x] Manter `core/config/` sem ambientes ou URLs inventados.
- [x] Garantir que `core/auth` não seja confundido com `features/auth`.

## Estrutura de `shared`

- [x] Criar `lib/shared/formatters/`.
- [x] Criar `lib/shared/ui_states/`.
- [x] Criar `lib/shared/validators/`.
- [x] Criar `lib/shared/widgets/`.
- [x] Materializar diretórios sem inventar implementações.
- [x] Garantir que `shared` não contenha regra específica de feature.

## Estrutura de features

- [x] Criar `auth`.
- [x] Criar `catalog`.
- [x] Criar `clients`.
- [x] Criar `dashboard`.
- [x] Criar `inventory`.
- [x] Criar `reports`.
- [x] Criar `sales`.
- [x] Criar `settings`.
- [x] Aplicar a cada feature a estrutura completa de camadas e subdiretórios.
- [x] Usar `.gitkeep` nos diretórios ainda sem código.

## Navegação

- [x] Criar `lib/app/router/app_routes.dart`.
- [x] Criar `lib/app/router/app_router.dart`.
- [x] Definir uma rota inicial estável.
- [x] Direcionar a rota inicial para `StartupPage`.
- [x] Não adicionar redirects de autenticação antes do contrato existir.
- [x] Não criar shell autenticado, bottom navigation ou rotas de features.

## Tema

- [x] Criar `lib/app/theme/app_colors.dart`.
- [x] Criar `lib/app/theme/app_theme.dart`.
- [x] Configurar Material 3 e identidade azul inicial.
- [x] Aplicar os tokens HSL documentados em `02-definicoes-de-interface.md`.
- [x] Usar fallback de tipografia sem declarar fonte ausente.
- [x] Remover estilos demonstrativos do template.

## Tela transitória

- [x] Criar `lib/app/startup/startup_page.dart`.
- [x] Identificar visualmente o Arara-Gastos.
- [x] Exibir somente uma mensagem de fundação pronta.
- [x] Não simular dashboard, login, permissões ou dados remotos.

## Testes

- [x] Substituir o teste do contador por teste de inicialização.
- [x] Validar a tela inicial por widget test.
- [x] Criar teste da árvore de diretórios obrigatória.
- [x] Criar teste de fronteiras arquiteturais.
- [x] Testar o validador com imports válidos e inválidos.
- [x] Cobrir separadores de caminho Windows e Unix.
- [x] Cobrir `data`, `core`, `shared` e `app`, além das três camadas principais.
- [x] Cobrir as proibições mínimas definidas em `spec.md`.

## Limpeza

- [x] Remover classes, textos e comentários do template Flutter.
- [x] Remover imports sem uso.
- [x] Atualizar a descrição genérica de `pubspec.yaml`.
- [x] Substituir o `README.md` padrão por orientação curta do projeto mobile.
- [x] Remover `cupertino_icons` se continuar sem uso.
- [x] Remover `.gitkeep` de diretórios que receberam arquivos reais.
- [x] Não criar classes ou contratos apenas para preencher diretórios.
- [x] Não incluir caminhos absolutos, URLs, tokens ou configurações de máquina.
- [x] Revisar nomes para refletirem responsabilidades reais.

## Validação

- [x] Executar `dart format`.
- [x] Executar `flutter analyze`.
- [x] Executar `flutter test`.
- [x] Inicializar o aplicativo em um alvo Flutter disponível.
- [x] Fazer validação visual da tela transitória.
- [x] Verificar os tokens de cor e o fallback tipográfico.
- [x] Registrar resultados e limitações em `review.md`.

## Documentação

- [x] Atualizar a spec se a implementação exigir mudança de escopo.
- [x] Registrar em `06-registro-decisoes.md` somente se surgir nova decisão.
- [x] Não alterar decisões aceitas silenciosamente.
- [x] Registrar dependências externas ainda abertas.
- [x] Registrar MCPs usados, indisponibilidades e fallbacks.
- [x] Marcar esta lista conforme o trabalho for concluído.
