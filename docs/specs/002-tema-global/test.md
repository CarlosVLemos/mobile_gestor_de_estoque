# Spec 002 - Plano de Testes

## Objetivo

Validar que o sistema de tema global oferece uma linguagem visual centralizada,
coerente e utilizavel nos modos claro e escuro, sem introduzir regra de feature
ou estilos presos a um unico brilho.

## Ambiente de referencia

Registrar durante a implementacao:

```text
Flutter:
Dart:
Plataforma:
Dispositivo ou navegador:
Fonte Instrument Sans:
```

## Testes automatizados

### T-000 - Estrutura do tema

**Tipo:** estrutura

**Resultado esperado:**

- os onze arquivos definidos na spec existem em `lib/app/theme/`;
- nao existem widgets de feature dentro de `app/theme/`;
- os arquivos possuem responsabilidades distintas;
- nenhum arquivo importa Dio, Drift, repositorio ou feature.

### T-001 - Tokens claros canonicos

**Tipo:** unidade

**Resultado esperado:**

- background, foreground, surface, primary, border, success, warning e danger
  correspondem aos valores documentados;
- sidebar operacional usa `#0B1A2B`;
- sidebar admin usa `#0D1B2A`;
- admin accent usa `#6D4DFF`.
- os HSL canonicos foram convertidos para constantes hexadecimais equivalentes.

### T-002 - Separacao entre primitivos e semanticos

**Tipo:** arquitetura/unidade

**Resultado esperado:**

- `app_colors.dart` contem cores primitivas e nao uma API de widget;
- `app_color_tokens.dart` contem `ThemeExtension<AppColorTokens>`;
- widgets migrados usam `ColorScheme` ou `AppColorTokens`;
- uso direto de `AppColors` fica restrito a montagem do tema e dos tokens.

### T-003 - Paleta escura dedicada

**Tipo:** unidade

**Resultado esperado:**

- os valores iniciais correspondem a baseline documentada ou possuem desvio
  justificado no review;
- o tema escuro possui background, surface, texto, borda e primary proprios;
- os valores nao sao simples inversoes do tema claro;
- background, surface e hero permanecem visualmente distintos;
- texto principal e secundario possuem contraste util.

### T-004 - Extensao semantica

**Tipo:** unidade

**Resultado esperado:**

- a extensao esta registrada nos dois `ThemeData`;
- todos os papeis adicionais obrigatorios estao preenchidos;
- `copyWith` preserva campos nao substituidos;
- `lerp` produz valores intermediarios sem excecao.

### T-005 - Mapeamento Material 3

**Tipo:** unidade/estatico

**Resultado esperado:**

- background conceitual e aplicado por scaffold/surface;
- foreground conceitual usa `onSurface`;
- card usa `surfaceContainerLow` ou `surface`;
- muted usa `surfaceContainerHighest` ou token adicional;
- nao existem usos de `background`, `onBackground` ou `surfaceVariant`
  depreciados.

### T-006 - Extensoes de BuildContext

**Tipo:** unidade/widget

**Resultado esperado:**

- `context.colors` retorna o `ColorScheme` ativo;
- `context.appColors` retorna `AppColorTokens`;
- `context.textTheme` retorna o `TextTheme` ativo;
- nao existe fallback silencioso para extensao ausente.

### T-007 - Escala de espacamento

**Tipo:** unidade

**Resultado esperado:**

- os tokens seguem ordem estritamente crescente;
- nenhum valor e negativo;
- os valores correspondem a `2, 4, 8, 12, 16, 24, 32, 40`.

### T-008 - Raios

**Tipo:** unidade

**Resultado esperado:**

- os valores correspondem a `8, 10, 12, 16, 28`;
- o token pill representa arredondamento completo;
- os aliases de `BorderRadius` correspondem aos raios escalares.

### T-009 - Tamanhos e toque

**Tipo:** unidade

**Resultado esperado:**

- alvos interativos globais nao ficam abaixo de 48;
- tamanhos de icone seguem a escala definida;
- o limite compacto da tela transitoria permanece em 440.

### T-010 - Tipografia

**Tipo:** unidade/widget

**Resultado esperado:**

- titulos usam peso semibold ou bold;
- corpo fica entre 14 e 16;
- captions ficam entre 12 e 13;
- labels de secao possuem tracking apropriado;
- Instrument Sans so e declarada quando o asset esta presente;
- fallback do sistema permanece valido.

### T-011 - ThemeData claro

**Tipo:** unidade/widget

**Resultado esperado:**

- Material 3 esta habilitado;
- `ColorScheme` usa `Brightness.light`;
- temas de card, input, botoes e navegacao usam os tokens claros;
- foco e estados desabilitados permanecem identificaveis.

### T-012 - ThemeData escuro

**Tipo:** unidade/widget

**Resultado esperado:**

- Material 3 esta habilitado;
- `ColorScheme` usa `Brightness.dark`;
- cards, inputs, dialogs e navigation bar nao usam superficies claras fixas;
- foco, selecao e estados desabilitados permanecem identificaveis.

### T-013 - Configuracao do aplicativo

**Tipo:** widget

**Passos:**

1. Construir `AraraApp`.
2. Obter `MaterialApp`.

**Resultado esperado:**

- `theme` esta configurado;
- `darkTheme` esta configurado;
- `themeMode` e `ThemeMode.system`;
- router e titulo permanecem inalterados.

### T-014 - Startup clara

**Tipo:** widget

**Resultado esperado:**

- a tela renderiza sem excecao;
- textos da Spec 001 continuam presentes;
- background, card, borda, sombra e icone usam o tema claro;
- nao ha overflow em 360x800 e 390x844.

### T-015 - Startup escura

**Tipo:** widget

**Resultado esperado:**

- a tela renderiza sem excecao;
- textos permanecem legiveis;
- card e background possuem niveis distintos;
- nenhuma superficie relevante permanece branca por valor fixo;
- nao ha overflow em 360x800 e 390x844.

### T-016 - Decoracoes dependentes do tema

**Tipo:** unidade/widget

**Resultado esperado:**

- card claro e escuro usam superficies diferentes;
- hero permanece navy nos dois modos;
- background atmosferico possui versoes adequadas aos dois modos;
- status tonais preservam sua semantica.

### T-017 - Composicao mobile

**Tipo:** unidade/widget

**Resultado esperado:**

- padding horizontal padrao e 16;
- gap de secao e 24;
- gap de lista usa 12 ou 16;
- card operacional usa padding interno de 16;
- controles mantem alvo minimo de 48.

### T-018 - Temas de controles

**Tipo:** widget

**Resultado esperado:**

- botao principal tem altura minima de toque;
- input possui borda, foco e erro coerentes;
- card possui borda e sombra leve;
- navigation bar distingue item selecionado;
- dialog e bottom sheet usam superficies do tema ativo;
- snackbar de erro nao e confundida com estado neutro.

### T-019 - Iconografia

**Tipo:** unidade

**Resultado esperado:**

- aliases globais existem;
- os aliases usam icones outline consistentes quando disponiveis;
- nao existem nomes de dominio ou feature no arquivo global.

### T-020 - Regressao arquitetural

**Tipo:** arquitetura

**Resultado esperado:**

- a suite de fronteiras da Spec 001 continua aprovada;
- `app/theme/` nao importa implementacoes de features;
- nenhuma nova rota, endpoint ou camada de dados e criada.

## Verificacoes estaticas

Executar:

```text
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Tambem buscar:

```text
Colors.white
Colors.black
Color(0x
fontFamily
AppColors.
onBackground
surfaceVariant
```

Ocorrencias nao sao automaticamente erros, mas cada uso em superficie ou texto
migrado deve ser revisado.

## Validacao visual

Validar os dois temas em pelo menos:

- 360x800;
- 390x844.

Verificar:

- identidade azul preservada;
- background atmosferico discreto;
- cards com borda sutil;
- hierarquia entre background, surface e hero;
- tipografia compacta e legivel;
- foco e estados semanticos;
- contraste de texto principal e secundario;
- ausencia de flashes ou superficies claras no dark mode;
- ausencia de overflow;
- coerencia com `designmobile.md`.

Quando uma ferramenta de navegador nao estiver disponivel, usar renderizacao de
widget test ou dispositivo Flutter disponivel e registrar a limitacao.

## Contraste

Verificar ao menos:

- texto normal contra background e surface;
- texto principal de botoes;
- labels de status;
- texto sobre hero;
- icones selecionados e nao selecionados;
- borda de input em repouso e foco;
- mensagens de erro.

Como referencia, buscar WCAG AA:

- `4.5:1` para texto normal;
- `3:1` para texto grande e elementos graficos essenciais.

## Regressao

- o aplicativo continua iniciando na rota transitoria;
- os testes da Spec 001 continuam passando;
- nenhum componente de negocio e adicionado;
- nenhum package de tema e introduzido;
- nenhuma fonte ausente e declarada;
- o tema claro nao muda de identidade;
- o tema escuro nao usa inversao automatica;
- arquivos nativos nao sao alterados.

## Evidencias

Registrar em `review.md`:

- comandos e resultados;
- valores finais da paleta escura;
- pesos da fonte incluidos;
- capturas ou metodo de validacao visual;
- desvios;
- limitacoes;
- veredito final.
