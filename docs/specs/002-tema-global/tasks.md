# Spec 002 - Tarefas

## Preparacao

- [x] Confirmar que nao existem mudancas conflitantes em `lib/app/theme/`.
- [x] Registrar as versoes de Flutter e Dart usadas.
- [x] Confirmar os arquivos e pesos disponiveis da Instrument Sans.
- [x] Confirmar que nenhuma nova decisao arquitetural e necessaria.
- [x] Registrar ferramentas disponiveis e fallbacks em `review.md`.

## Cores

- [x] Refatorar `app_colors.dart` para conter apenas paleta e cores primitivas.
- [x] Converter os HSL canonicos para constantes hexadecimais verificadas.
- [x] Criar `app_color_tokens.dart`.
- [x] Implementar `ThemeExtension<AppColorTokens>`.
- [x] Preservar os tokens canonicos do tema claro.
- [x] Implementar a baseline documentada da paleta escura.
- [x] Ajustar a baseline somente com evidencia de contraste ou validacao visual.
- [x] Criar tokens para superficies, texto, bordas e foco.
- [x] Criar tokens de sucesso, alerta, erro e restricao.
- [x] Criar tokens de hero e background atmosferico.
- [x] Criar tokens operacionais e administrativos.
- [x] Criar os cinco tokens de graficos em ambos os temas.
- [x] Garantir interpolacao correta da extensao.
- [x] Mapear os conceitos web para papeis atuais do Material 3.
- [x] Nao usar `background`, `onBackground` ou `surfaceVariant` depreciados.
- [x] Garantir que widgets nao consultem cores primitivas diretamente.

## Ergonomia do tema

- [x] Criar `app_theme_context.dart`.
- [x] Expor acesso a `ColorScheme`, `AppColorTokens` e `TextTheme`.
- [x] Manter as extensoes como encaminhamento sem regra ou fallback silencioso.

## Escalas globais

- [x] Criar `app_spacing.dart`.
- [x] Criar `app_radius.dart`.
- [x] Criar `app_sizes.dart`.
- [x] Criar `app_shadows.dart`.
- [x] Evitar aliases duplicados sem ganho de legibilidade.
- [x] Documentar unidades e responsabilidade de cada escala.
- [x] Documentar padding de tela, gaps de secao, gaps de lista e padding de card.

## Tipografia

- [x] Criar `app_typography.dart`.
- [x] Definir escala de display, titulos, corpo, labels e captions.
- [x] Configurar pesos e alturas de linha.
- [x] Configurar tracking de titulos e labels.
- [x] Incluir Instrument Sans localmente se os arquivos estiverem disponiveis.
- [x] Atualizar `pubspec.yaml` apenas para assets realmente presentes.
- [x] Manter fallback do sistema se a fonte nao estiver disponivel.

## Iconografia

- [x] Criar `app_icons.dart`.
- [x] Definir somente aliases globais e semanticos.
- [x] Usar icones outline consistentes.
- [x] Nao adicionar package externo sem justificativa.
- [x] Nao incluir icones exclusivos de uma feature.

## ThemeData

- [x] Refatorar `app_theme.dart`.
- [x] Construir `ColorScheme` claro.
- [x] Construir `ColorScheme` escuro.
- [x] Registrar extensoes nos dois temas.
- [x] Configurar `TextTheme`.
- [x] Configurar tema de app bar.
- [x] Configurar cards e divisores.
- [x] Configurar inputs.
- [x] Configurar botoes preenchidos, contornados e textuais.
- [x] Configurar icon buttons e FAB.
- [x] Configurar navigation bar.
- [x] Configurar dialogs e bottom sheets.
- [x] Configurar chips, progress indicators e snack bars.
- [x] Configurar estados disabled, focus e selected.

## Decoracoes

- [x] Criar `app_decorations.dart`.
- [x] Implementar card padrao dependente do tema.
- [x] Implementar card elevado dependente do tema.
- [x] Implementar hero escuro.
- [x] Implementar superficie flutuante.
- [x] Implementar background atmosferico.
- [x] Implementar decoracoes tonais de status.
- [x] Mapear sucesso, alerta, erro e restrito para papeis tonais.
- [x] Garantir que nenhuma decoracao global fique presa ao tema claro.
- [x] Manter sombras de cards quase imperceptiveis.
- [x] Priorizar borda e niveis de superficie no tema escuro.

## Integracao

- [x] Configurar `darkTheme` em `AraraApp`.
- [x] Configurar `ThemeMode.system`.
- [x] Migrar `StartupPage` para os tokens globais.
- [x] Remover valores visuais duplicados da tela transitoria.
- [x] Preservar o comportamento e os textos da Spec 001.
- [x] Confirmar que nenhuma rota ou feature foi adicionada.

## Testes automatizados

- [x] Testar os tokens essenciais do tema claro.
- [x] Testar a conversao dos HSL canonicos para hex.
- [x] Testar que o tema escuro possui valores dedicados.
- [x] Testar a `ThemeExtension` em ambos os temas.
- [x] Testar interpolacao dos tokens adicionais.
- [x] Testar as extensoes de `BuildContext`.
- [x] Testar que os campos depreciados do `ColorScheme` nao sao usados.
- [x] Testar escalas de espacamento, raio e tamanho.
- [x] Testar os papeis semanticos da tipografia.
- [x] Testar `ThemeData` dos controles principais.
- [x] Testar `AraraApp` com tema claro.
- [x] Testar `AraraApp` com tema escuro.
- [x] Testar `StartupPage` nos dois modos.
- [x] Testar larguras mobile estreita e comum.
- [x] Garantir que os testes arquiteturais existentes continuam passando.

## Validacao visual

- [x] Abrir a tela transitoria em tema claro.
- [x] Abrir a tela transitoria em tema escuro.
- [x] Verificar 360x800.
- [x] Verificar 390x844.
- [x] Verificar contraste de texto, borda, icone e superficie.
- [x] Verificar background atmosferico sem excesso decorativo.
- [x] Verificar que o dark mode nao parece uma inversao automatica.
- [x] Registrar capturas temporarias ou evidencia equivalente no `review.md`.

## Qualidade

- [x] Executar `dart format`.
- [x] Executar `flutter analyze`.
- [x] Executar os testes de tema e widget.
- [x] Executar a suite completa.
- [x] Buscar `Colors.white`, `Colors.black` e cores fixas nas superficies migradas.
- [x] Buscar uso direto de `AppColors` fora da montagem do tema e tokens.
- [x] Buscar `background`, `onBackground` e `surfaceVariant` depreciados.
- [x] Verificar que nao existem assets de fonte ausentes.
- [x] Verificar que nenhum cache ou arquivo gerado entrou no diff.

## Fechamento

- [x] Registrar no `review.md` os valores finais do tema escuro.
- [x] Registrar arquivos principais e testes executados.
- [x] Registrar limitacoes de fonte, navegador ou dispositivo.
- [x] Registrar desvios aprovados da spec.
- [x] Atualizar o status da spec somente depois da aprovacao.
- [x] Nao marcar esta lista como concluida antes das evidencias.
