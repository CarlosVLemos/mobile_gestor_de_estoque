# Spec 004 - Tarefas

## Preparação

- [ ] Confirmar que o workspace não possui alterações não salvas antes de iniciar.
- [ ] Confirmar quais arquivos serão alterados e realizar backups se necessário.
- [ ] Registrar as ferramentas de desenvolvimento ativas no `review.md`.

## Tema e Fundações Visuais

- [ ] Refinar o `atmosphericGradient` em [app_theme.dart](file:///c:/Users/carlos.silva/www/gestor_de_estoque/lib/app/theme/app_theme.dart) para misturar melhor os gradientes de azul e dourado.
- [ ] Ajustar as propriedades de sombra (`boxShadow`) em [app_shadows.dart](file:///c:/Users/carlos.silva/www/gestor_de_estoque/lib/app/theme/app_shadows.dart) ou [app_decorations.dart](file:///c:/Users/carlos.silva/www/gestor_de_estoque/lib/app/theme/app_decorations.dart) para suavizar a dispersão dos cards.
- [ ] Testar se o tema claro e escuro continuam contrastantes e legíveis.

## Componente de Toque Reativo (InteractiveFeedback)

- [ ] Criar o novo widget `InteractiveFeedback` em `lib/shared/widgets/interactive_feedback.dart` [NEW].
- [ ] Implementar a micro-escala reativa (reduzir para `0.97` no toque/pressão) utilizando um controller de animação (`AnimationController`) ou widget animado implícito.
- [ ] Garantir suporte para feedback tátil nativo via `HapticFeedback.lightImpact()`.
- [ ] Integrar o widget nos botões e cartões operacionais.

## Glassmorphism na Shell e Navegação

- [ ] Habilitar `extendBody: true` no `Scaffold` em [app_shell_scaffold.dart](file:///c:/Users/carlos.silva/www/gestor_de_estoque/lib/shared/widgets/app_shell_scaffold.dart).
- [ ] Aplicar `BackdropFilter` com blur sutil no container que envolve a `AppBottomNavigation` em [app_shell_scaffold.dart](file:///c:/Users/carlos.silva/www/gestor_de_estoque/lib/shared/widgets/app_shell_scaffold.dart) ou [app_bottom_navigation.dart](file:///c:/Users/carlos.silva/www/gestor_de_estoque/lib/shared/widgets/app_bottom_navigation.dart).
- [ ] Ajustar espaçamento inferior (`padding` ou `margin`) nos listviews/páginas principais para compensar o `extendBody` e evitar que o conteúdo final fique escondido permanentemente sob a barra de navegação.

## Cards Operacionais com Feedback

- [ ] Integrar `InteractiveFeedback` no [product_card.dart](file:///c:/Users/carlos.silva/www/gestor_de_estoque/lib/shared/widgets/product_card.dart) e [kpi_card.dart](file:///c:/Users/carlos.silva/www/gestor_de_estoque/lib/shared/widgets/kpi_card.dart).
- [ ] Refinar as decorações e bordas dos cards em [app_decorations.dart](file:///c:/Users/carlos.silva/www/gestor_de_estoque/lib/app/theme/app_decorations.dart) para aumentar a nitidez e polimento visual.

## Transição de Estados Suaves (Fade/Slide Transitions)

- [ ] Implementar um wrapper de transição em `lib/shared/widgets/animated_state_switcher.dart` [NEW] ou diretamente nas páginas usando `AnimatedSwitcher`.
- [ ] Aplicar o switcher de transição na [dashboard_page.dart](file:///c:/Users/carlos.silva/www/gestor_de_estoque/lib/features/dashboard/presentation/pages/dashboard_page.dart).
- [ ] Aplicar o switcher de transição na tela de Catálogo.

## Reorganização de Layouts e Posicionamento

- [ ] Reorganizar os `KpiCard`s do Painel em um layout de grade de 2 colunas (`Wrap`).
- [ ] Criar e aplicar um componente de agrupamento para Alertas de Estoque no Painel, consolidando-os em um único card com divisórias.
- [ ] Criar e aplicar um componente de agrupamento para Movimentações Recentes no Painel, consolidando-os em um único card com divisórias.
- [ ] Redesenhar o `CatalogFilterBar` em um design compacto sem os cabeçalhos textuais longos.
- [ ] Atualizar o layout do `ProductCard` para ter uma estrutura colunar limpa (Imagem à esquerda, Detalhes no centro, Preço/Status à direita e Informações de estoque/data no rodapé).
- [ ] Agrupar os atalhos de `ModuleStatusTile` da página "Mais" em uma única lista de configurações dentro de um cartão unificado com divisores.

## Qualidade e Validação

- [ ] Executar `dart format`.
- [ ] Executar `flutter analyze`.
- [ ] Executar `flutter test` para garantir que as alterações não introduziram regressões ou quebraram testes de widget e unidade.
- [ ] Testar o visual e interação manualmente no simulador/dispositivo.

## Fechamento

- [ ] Registrar as alterações, arquivos modificados e resultados de testes em `review.md`.
- [ ] Documentar o novo componente `InteractiveFeedback` em `components.md` se aplicável.

