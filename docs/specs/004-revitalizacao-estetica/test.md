# Spec 004 - Plano de Testes

## Objetivo

Validar que o acabamento estético e as micro-animações reativas foram implementados com sucesso, sem introduzir regressões de layout, quebras em testes existentes ou degradação na performance visual (ex: travamentos com BackdropFilter).

## Ambiente de referencia

Registrar durante a implementação:

```text
Flutter:
Dart:
Plataforma:
Dispositivo ou navegador:
```

## Testes automatizados

### T-001 - Estabilidade das Fundação de Animações
* **Tipo**: Unidade/Widget
* **Resultado esperado**:
  * O widget `InteractiveFeedback` renderiza seu conteúdo filho corretamente.
  * O ciclo de vida do controller de animação interna do `InteractiveFeedback` é gerenciado sem vazamentos de memória (disposing correto).
  * O widget responde a eventos de toque (`TapDown` / `TapUp` / `TapCancel`) disparando a animação de escala e retornando ao estado original ao final.

### T-002 - Vidro e Blur na Barra de Navegação
* **Tipo**: Widget
* **Resultado esperado**:
  * A bottom navigation na `AppShellScaffold` renderiza com desfoque de fundo sem provocar travamentos.
  * O conteúdo principal (`body`) rola por baixo da bottom navigation quando `extendBody: true` estiver ativo.
  * A área rolável possui margem inferior segura para garantir que o último item não seja cortado visualmente pelo rodapé.

### T-003 - Transição Suave de Estados
* **Tipo**: Widget
* **Resultado esperado**:
  * A alternância entre estados em páginas como `DashboardPage` transiciona através de fade/slide usando `AnimatedSwitcher` sem gerar quebras de layout.
  * O uso do `tester.pumpAndSettle()` nos testes existentes de widget aguarda o término completo da transição antes de prosseguir com as asserções.

## Verificações estáticas

Executar:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Validação visual

Validar ao menos:
- **Tamanhos de tela**: 360x800, 390x844 e 412x915 (larguras mobile comuns).
- **Temas**: Claro e Escuro.
- **Micro-interações**:
  * Cartão de Produto reage com escala ao toque.
  * Cartão de KPI reage com escala ao toque.
  * Botões principais reagem com escala ao toque.
  * O desfoque na bottom navigation funciona perfeitamente ao rolar a lista de produtos por baixo dela.
