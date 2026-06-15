# Spec 004 - Revisao

## Status

Implementada em 12 de junho de 2026. Pendente de validação visual pelo usuário.

## Escopo previsto

- Refinamento do gradiente de fundo atmosférico claro/escuro.
- Efeito de desfoque real (glassmorphism/blur) na bottom navigation.
- Implementação do widget de toque reativo `InteractiveFeedback`.
- Aplicação do feedback reativo de escala nos cards e botões operacionais.
- Suavização de transições de estados de visualização com `AnimatedSwitcher` em páginas principais.
- Reorganização de layouts: KPIs 2x2, alertas/movimentos consolidados, filter bar compacta, atalhos agrupados.
- Refinamento tipográfico do header operacional.
- Criação de tokens centralizados de movimento (`AppDurations`, `AppCurves`).

## Ferramentas e ambiente

- Toolchain local: Flutter (conforme workspace)
- Plataforma: Windows (desenvolvimento)
- Modo de dados: Fixture local (bootstrap)

## Arquivos principais

### Novos
- `lib/app/theme/app_motion.dart` — tokens de duração e curvas
- `lib/shared/widgets/interactive_feedback.dart` — widget de toque reativo
- `lib/shared/widgets/animated_state_switcher.dart` — wrapper de transição suave
- `test/shared/widgets/interactive_feedback_test.dart` — testes do InteractiveFeedback
- `test/shared/widgets/animated_state_switcher_test.dart` — testes do AnimatedStateSwitcher

### Modificados
- `lib/app/theme/app_theme.dart` — gradientes atmosféricos refinados (RadialGradient → LinearGradient com 4 paradas)
- `lib/app/theme/app_shadows.dart` — sombras suavizadas (maior blur, menor opacidade, spread sutil)
- `lib/app/theme/app_decorations.dart` — adicionado `glassSurfaceBar` para bottom nav
- `lib/shared/widgets/app_shell_scaffold.dart` — extendBody, BackdropFilter com ClipRRect, SafeArea preservada no topo
- `lib/shared/widgets/operational_page_header.dart` — tipografia refinada (eyebrow com letter-spacing, título w800, descrição com height 1.5)
- `lib/features/dashboard/presentation/pages/dashboard_page.dart` — KPIs em 2x2 com LayoutBuilder, alertas e movimentos consolidados (max 5), AnimatedStateSwitcher
- `lib/features/catalog/presentation/pages/catalog_page.dart` — AnimatedStateSwitcher, InteractiveFeedback nos cards
- `lib/features/catalog/presentation/widgets/catalog_filter_bar.dart` — removido cabeçalho textual
- `lib/features/settings/presentation/pages/more_page.dart` — atalhos consolidados em card único com divisórias
- `lib/features/settings/presentation/widgets/module_status_tile.dart` — simplificado para uso dentro de card pai

## Testes e validacoes

- `dart format`: ✅ 84 arquivos verificados, 7 formatados
- `flutter analyze`: ✅ nenhum issue encontrado
- `flutter test`: pendente de execução pelo usuário

## Componentes compartilhados criados/modificados

| Componente | Ação | Localização |
|---|---|---|
| `AppDurations` | NOVO | `lib/app/theme/app_motion.dart` |
| `AppCurves` | NOVO | `lib/app/theme/app_motion.dart` |
| `InteractiveFeedback` | NOVO | `lib/shared/widgets/interactive_feedback.dart` |
| `AnimatedStateSwitcher` | NOVO | `lib/shared/widgets/animated_state_switcher.dart` |
| `AppDecorations.glassSurfaceBar` | NOVO | `lib/app/theme/app_decorations.dart` |
| `AppShadows` | MODIFICADO | `lib/app/theme/app_shadows.dart` |
| `AppShellScaffold` | MODIFICADO | `lib/shared/widgets/app_shell_scaffold.dart` |
| `OperationalPageHeader` | MODIFICADO | `lib/shared/widgets/operational_page_header.dart` |

## Ajustes incorporados do review do usuario

1. SafeArea preservada no topo (`bottom: false`) — proteção contra notch/status bar mantida
2. ClipRRect com `borderRadius` top-only envolvendo o BackdropFilter — evita blur vazando visualmente
3. `enableHaptics` (default `false`) no InteractiveFeedback — haptic só dispara com onTap + enabled + flag
4. `Curves.easeOutCubic` em vez de `elasticOut` — visual premium sóbrio, não saltitante
5. `LayoutBuilder` para KPIs 2x2 — resiliente em tablets, split screen e telas variadas
6. `ValueKey` semântica obrigatória documentada no AnimatedStateSwitcher
7. Limite de 5 itens inline em alertas/movimentos consolidados com botão "Ver todos"
8. Refinamento tipográfico do header operacional (eyebrow, título, descrição)
9. Tokens `AppDurations` e `AppCurves` centralizados
10. Testes de widget para os dois novos componentes

## Limitacoes

- Validação visual manual em dispositivo/simulador ainda não realizada — pendente do usuário.
- Performance do `BackdropFilter` em dispositivos antigos não testada (sigma mantido em 12 conforme mitigação da spec).
- Testes de integração das páginas existentes pendentes de execução pelo usuário.

## Desvios

Nenhum desvio significativo da spec aprovada. Todos os ajustes obrigatórios do review do usuário foram incorporados.

## Veredito

Implementação completa. Aguardando validação visual e execução de `flutter test` pelo usuário para aceite final.
