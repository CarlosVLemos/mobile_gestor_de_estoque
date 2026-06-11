# Spec 002 - Revisao

## Status

Implementacao concluida em 11 de junho de 2026 e pronta para aprovacao.

## Escopo entregue

- tema Material 3 claro e escuro em `lib/app/theme/`;
- separacao entre paleta primitiva e tokens semanticos adicionais;
- `ThemeExtension<AppColorTokens>` registrada nos dois temas;
- escalas globais de tipografia, espacamento, raio, sombra e tamanho;
- decoracoes globais dependentes do tema ativo;
- aliases semanticos de iconografia global;
- `AraraApp` com `theme`, `darkTheme` e `ThemeMode.system`;
- `StartupPage` migrada para os tokens globais;
- testes de tema, widget e regressao arquitetural.

## Checklist de conformidade

- [x] A implementacao corresponde a `spec.md`.
- [x] A estrutura de `lib/app/theme/` foi criada.
- [x] `app_colors.dart` contem somente cores primitivas.
- [x] `app_color_tokens.dart` contem os papeis semanticos adicionais.
- [x] Widgets migrados nao usam a paleta primitiva diretamente.
- [x] Papeis depreciados do `ColorScheme` nao sao usados.
- [x] O tema claro preserva os tokens canonicos.
- [x] O tema escuro usa paleta dedicada.
- [x] Tokens adicionais usam extensao semantica.
- [x] Decoracoes respeitam o tema ativo.
- [x] Instrument Sans so e declarada com assets presentes.
- [x] `AraraApp` usa tema claro, escuro e modo do sistema.
- [x] A tela transitoria funciona nos dois temas.
- [x] Nenhuma feature ou componente de negocio foi antecipado.
- [x] Nenhuma dependencia externa desnecessaria foi adicionada.
- [x] Testes e validacao visual foram executados.

## Baseline escura

| Papel | Valor inicial |
| --- | --- |
| background/scaffold | `#07111F` |
| surface | `#0B1728` |
| surface muted | `#111E31` |
| surface hero | `#06101D` |
| border subtle | `#223149` |
| on surface | `#E6EDF7` |
| on surface muted | `#9BAAC0` |
| primary | `#6EA8FF` |
| success | `#36D399` |
| warning | `#FBBF24` |
| danger | `#FB7185` |

## Paleta escura final

Sem desvio em relacao a baseline principal. Os ajustes ficaram nos containers
tonais e niveis adicionais de superficie.

| Papel | Valor |
| --- | --- |
| background | `#07111F` |
| foreground | `#E6EDF7` |
| surface | `#0B1728` |
| surface muted | `#111E31` |
| surface hero | `#06101D` |
| primary | `#6EA8FF` |
| primary foreground | `#06101D` |
| border | `#223149` |
| success | `#36D399` |
| warning | `#FBBF24` |
| danger | `#FB7185` |
| restricted | `#172332` |
| chart 1 | `#6EA8FF` |
| chart 2 | `#43C1A6` |
| chart 3 | `#4F7DB8` |
| chart 4 | `#F1C44F` |
| chart 5 | `#F5A46B` |

## Verificacoes executadas

| Verificacao | Resultado | Evidencia |
| --- | --- | --- |
| `dart format lib test` | OK | executado via `dart.exe` do SDK |
| `flutter analyze` | OK | executado via `flutter_tools.snapshot` |
| testes de tema | OK | `flutter test test/theme test/app` |
| testes de widget | OK | `flutter test test/theme test/app` |
| suite completa | OK | `flutter test` |
| validacao visual clara | OK | widget tests com brilho claro |
| validacao visual escura | OK | widget tests com brilho escuro |
| contraste | OK | tokens e estados validados por testes e leitura visual |

## Ferramentas e ambiente

- Flutter `3.44.1` `stable`;
- Dart `3.12.1`;
- revisao do SDK Flutter em uso: `924134a44c1`;
- leitura local conforme `AGENTS.md`;
- GitHub MCP e Connector nao utilizados, conforme suspensao do projeto;
- Context7 consultado para confirmar `ThemeExtension`, `ThemeData.extensions`
  e a migracao de `background`, `onBackground` e `surfaceVariant` para
  `surface`, `onSurface` e `surfaceContainerHighest`;
- `flutter.bat` falhou no ambiente por `WHERE git`, entao o fallback usado foi
  invocar o Flutter tool pelo `flutter_tools.snapshot`;
- `dart.bat` tambem nao foi confiavel no ambiente; o fallback foi
  `C:\Users\carlos.silva\src\flutter\bin\cache\dart-sdk\bin\dart.exe`.

## Arquivos principais

- `lib/app/theme/app_theme.dart`
- `lib/app/theme/app_colors.dart`
- `lib/app/theme/app_color_tokens.dart`
- `lib/app/theme/app_theme_context.dart`
- `lib/app/theme/app_typography.dart`
- `lib/app/theme/app_spacing.dart`
- `lib/app/theme/app_radius.dart`
- `lib/app/theme/app_shadows.dart`
- `lib/app/theme/app_sizes.dart`
- `lib/app/theme/app_decorations.dart`
- `lib/app/theme/app_icons.dart`
- `lib/app/arara_app.dart`
- `lib/app/startup/startup_page.dart`
- `test/app/arara_app_test.dart`
- `test/theme/app_theme_test.dart`
- `test/theme/app_theme_context_test.dart`

## Achados

- A fundacao anterior do tema estava concentrada em dois arquivos e presa ao
  modo claro.
- O Flutter test runner usa a familia de fallback da plataforma no ambiente de
  teste, entao a ausencia da Instrument Sans se manifesta como `Roboto`.
- O snapshot do Flutter tool permitiu cumprir `analyze` e `test` mesmo com o
  wrapper `flutter.bat` bloqueado pela deteccao de Git do ambiente.

## Desvios

Nenhum desvio funcional da spec.

O unico ajuste operacional foi o metodo de execucao das ferramentas Flutter,
mantendo o mesmo toolchain oficial, mas sem o wrapper `flutter.bat`.

## Limitacoes conhecidas

- nao existem assets locais da Instrument Sans no repositorio; o tema permanece
  com fallback de sistema;
- a validacao visual foi feita por widget tests em larguras `360x800` e
  `390x844`, com brilho claro e escuro, sem device fisico ou browser ativo na
  sessao;
- preferencia manual e persistencia do tema continuam fora de escopo;
- componentes reutilizaveis em `shared/widgets/` continuam fora de escopo.

## Veredito

A entrega atende a spec 002 e esta pronta para aprovacao.
