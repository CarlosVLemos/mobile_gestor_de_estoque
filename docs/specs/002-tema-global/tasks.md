# Spec 002 - Tarefas

## Preparacao

- [ ] Confirmar que nao existem mudancas conflitantes em `lib/app/theme/`.
- [ ] Registrar as versoes de Flutter e Dart usadas.
- [ ] Confirmar os arquivos e pesos disponiveis da Instrument Sans.
- [ ] Confirmar que nenhuma nova decisao arquitetural e necessaria.
- [ ] Registrar ferramentas disponiveis e fallbacks em `review.md`.

## Cores

- [ ] Refatorar `app_colors.dart` para conter apenas paleta e cores primitivas.
- [ ] Converter os HSL canonicos para constantes hexadecimais verificadas.
- [ ] Criar `app_color_tokens.dart`.
- [ ] Implementar `ThemeExtension<AppColorTokens>`.
- [ ] Preservar os tokens canonicos do tema claro.
- [ ] Implementar a baseline documentada da paleta escura.
- [ ] Ajustar a baseline somente com evidencia de contraste ou validacao visual.
- [ ] Criar tokens para superficies, texto, bordas e foco.
- [ ] Criar tokens de sucesso, alerta, erro e restricao.
- [ ] Criar tokens de hero e background atmosferico.
- [ ] Criar tokens operacionais e administrativos.
- [ ] Criar os cinco tokens de graficos em ambos os temas.
- [ ] Garantir interpolacao correta da extensao.
- [ ] Mapear os conceitos web para papeis atuais do Material 3.
- [ ] Nao usar `background`, `onBackground` ou `surfaceVariant` depreciados.
- [ ] Garantir que widgets nao consultem cores primitivas diretamente.

## Ergonomia do tema

- [ ] Criar `app_theme_context.dart`.
- [ ] Expor acesso a `ColorScheme`, `AppColorTokens` e `TextTheme`.
- [ ] Manter as extensoes como encaminhamento sem regra ou fallback silencioso.

## Escalas globais

- [ ] Criar `app_spacing.dart`.
- [ ] Criar `app_radius.dart`.
- [ ] Criar `app_sizes.dart`.
- [ ] Criar `app_shadows.dart`.
- [ ] Evitar aliases duplicados sem ganho de legibilidade.
- [ ] Documentar unidades e responsabilidade de cada escala.
- [ ] Documentar padding de tela, gaps de secao, gaps de lista e padding de card.

## Tipografia

- [ ] Criar `app_typography.dart`.
- [ ] Definir escala de display, titulos, corpo, labels e captions.
- [ ] Configurar pesos e alturas de linha.
- [ ] Configurar tracking de titulos e labels.
- [ ] Incluir Instrument Sans localmente se os arquivos estiverem disponiveis.
- [ ] Atualizar `pubspec.yaml` apenas para assets realmente presentes.
- [ ] Manter fallback do sistema se a fonte nao estiver disponivel.

## Iconografia

- [ ] Criar `app_icons.dart`.
- [ ] Definir somente aliases globais e semanticos.
- [ ] Usar icones outline consistentes.
- [ ] Nao adicionar package externo sem justificativa.
- [ ] Nao incluir icones exclusivos de uma feature.

## ThemeData

- [ ] Refatorar `app_theme.dart`.
- [ ] Construir `ColorScheme` claro.
- [ ] Construir `ColorScheme` escuro.
- [ ] Registrar extensoes nos dois temas.
- [ ] Configurar `TextTheme`.
- [ ] Configurar tema de app bar.
- [ ] Configurar cards e divisores.
- [ ] Configurar inputs.
- [ ] Configurar botoes preenchidos, contornados e textuais.
- [ ] Configurar icon buttons e FAB.
- [ ] Configurar navigation bar.
- [ ] Configurar dialogs e bottom sheets.
- [ ] Configurar chips, progress indicators e snack bars.
- [ ] Configurar estados disabled, focus e selected.

## Decoracoes

- [ ] Criar `app_decorations.dart`.
- [ ] Implementar card padrao dependente do tema.
- [ ] Implementar card elevado dependente do tema.
- [ ] Implementar hero escuro.
- [ ] Implementar superficie flutuante.
- [ ] Implementar background atmosferico.
- [ ] Implementar decoracoes tonais de status.
- [ ] Mapear sucesso, alerta, erro e restrito para papeis tonais.
- [ ] Garantir que nenhuma decoracao global fique presa ao tema claro.
- [ ] Manter sombras de cards quase imperceptiveis.
- [ ] Priorizar borda e niveis de superficie no tema escuro.

## Integracao

- [ ] Configurar `darkTheme` em `AraraApp`.
- [ ] Configurar `ThemeMode.system`.
- [ ] Migrar `StartupPage` para os tokens globais.
- [ ] Remover valores visuais duplicados da tela transitoria.
- [ ] Preservar o comportamento e os textos da Spec 001.
- [ ] Confirmar que nenhuma rota ou feature foi adicionada.

## Testes automatizados

- [ ] Testar os tokens essenciais do tema claro.
- [ ] Testar a conversao dos HSL canonicos para hex.
- [ ] Testar que o tema escuro possui valores dedicados.
- [ ] Testar a `ThemeExtension` em ambos os temas.
- [ ] Testar interpolacao dos tokens adicionais.
- [ ] Testar as extensoes de `BuildContext`.
- [ ] Testar que os campos depreciados do `ColorScheme` nao sao usados.
- [ ] Testar escalas de espacamento, raio e tamanho.
- [ ] Testar os papeis semanticos da tipografia.
- [ ] Testar `ThemeData` dos controles principais.
- [ ] Testar `AraraApp` com tema claro.
- [ ] Testar `AraraApp` com tema escuro.
- [ ] Testar `StartupPage` nos dois modos.
- [ ] Testar larguras mobile estreita e comum.
- [ ] Garantir que os testes arquiteturais existentes continuam passando.

## Validacao visual

- [ ] Abrir a tela transitoria em tema claro.
- [ ] Abrir a tela transitoria em tema escuro.
- [ ] Verificar 360x800.
- [ ] Verificar 390x844.
- [ ] Verificar contraste de texto, borda, icone e superficie.
- [ ] Verificar background atmosferico sem excesso decorativo.
- [ ] Verificar que o dark mode nao parece uma inversao automatica.
- [ ] Registrar capturas temporarias ou evidencia equivalente no `review.md`.

## Qualidade

- [ ] Executar `dart format`.
- [ ] Executar `flutter analyze`.
- [ ] Executar os testes de tema e widget.
- [ ] Executar a suite completa.
- [ ] Buscar `Colors.white`, `Colors.black` e cores fixas nas superficies migradas.
- [ ] Buscar uso direto de `AppColors` fora da montagem do tema e tokens.
- [ ] Buscar `background`, `onBackground` e `surfaceVariant` depreciados.
- [ ] Verificar que nao existem assets de fonte ausentes.
- [ ] Verificar que nenhum cache ou arquivo gerado entrou no diff.

## Fechamento

- [ ] Registrar no `review.md` os valores finais do tema escuro.
- [ ] Registrar arquivos principais e testes executados.
- [ ] Registrar limitacoes de fonte, navegador ou dispositivo.
- [ ] Registrar desvios aprovados da spec.
- [ ] Atualizar o status da spec somente depois da aprovacao.
- [ ] Nao marcar esta lista como concluida antes das evidencias.
