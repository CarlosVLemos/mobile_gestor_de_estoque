# Spec 002 - Tema Global Claro e Escuro

## Status

Implementada em 11 de junho de 2026.

## Classificacao

- arquitetura de interface;
- design system;
- tema global;
- acessibilidade visual;
- refactor de fundacao;
- documentacao.

## Fontes e hierarquia

Esta spec e governada pelo `AGENTS.md` da raiz e usa
`para mobile/00-contexto-operacional.md` como ponto de entrada.

Fontes aplicaveis, na ordem de precedencia do projeto:

1. decisoes aceitas em `para mobile/06-registro-decisoes.md`;
2. arquitetura em `para mobile/05-arquitetura-mobile.md`;
3. interface em `para mobile/02-definicoes-de-interface.md`;
4. blueprint visual em `para mobile/designmobile.md`;
5. processo em `para mobile/08-processo-de-trabalho.md`;
6. implementacao atual em `lib/app/theme/`.

As imagens em `docs/specs/Img/` sao referencias de composicao e componentes.
Elas nao substituem os tokens, as decisoes aceitas ou os contratos do projeto.

## Problema

A fundacao atual possui apenas um tema claro minimo, concentrado em
`app_theme.dart` e `app_colors.dart`. Ainda nao existem:

- tema escuro;
- separacao entre cores primitivas e papeis semanticos;
- tokens completos de superficie, texto, estados e graficos;
- escala central de espacamento;
- escala central de raios;
- tipografia completa;
- sombras globais;
- tamanhos de controles e icones;
- decoracoes reutilizaveis e dependentes do tema;
- aliases semanticos de iconografia;
- configuracao de `darkTheme` e `themeMode` no aplicativo;
- testes que garantam paridade semantica entre os temas.

Sem essa base, cada feature pode criar cores, dimensoes, sombras e estilos
proprios. Isso aumentaria a divergencia visual e favoreceria valores fixos que
nao funcionam nos dois modos.

## Objetivo

Criar o equivalente ao CSS global da aplicacao em `lib/app/theme/`, com:

- `ThemeData` claro e escuro;
- tokens semanticos coerentes entre os dois modos;
- identidade azul, fria, analitica e operacional;
- suporte ao tema do sistema operacional;
- tipografia Instrument Sans quando os arquivos da fonte forem incluidos;
- escalas reutilizaveis de espacamento, raio, tamanho e sombra;
- decoracoes globais que respeitem o tema ativo;
- temas Material 3 para controles recorrentes;
- API simples para features e componentes compartilhados;
- testes unitarios, de widget e validacao visual.

## Decisoes aplicaveis

| Decisao | Aplicacao nesta spec |
| --- | --- |
| MOB-002 | O tema permanece na camada global `app/`, sem regra de feature |
| MOB-004 | Uma futura preferencia controlada pelo app devera usar Riverpod |
| MOB-014 | Os dois temas preservam a identidade azul operacional |
| MOB-016 | Nenhuma tela ou feature futura sera simulada |
| UI-003 | O token de hero escuro sera preservado para o dashboard |
| UI-004 | Sucesso, alerta e erro terao semantica consistente |
| UI-005 | Tokens suportarao conteudo visivel durante refresh |
| UI-006 | O estado restrito tera apresentacao neutra, nao destrutiva |
| UI-007 | Estados de sincronizacao e conflito nao serao ocultados por cor |

Esta spec materializa a identidade visual ja documentada. Ela nao altera uma
decisao aceita e nao exige, por si so, uma nova entrada em
`06-registro-decisoes.md`.

## Arquitetura

### Estrutura alvo

```text
lib/
  app/
    theme/
      app_theme.dart
      app_colors.dart
      app_color_tokens.dart
      app_theme_context.dart
      app_typography.dart
      app_spacing.dart
      app_radius.dart
      app_shadows.dart
      app_sizes.dart
      app_decorations.dart
      app_icons.dart
```

Responsabilidades:

| Arquivo | Responsabilidade |
| --- | --- |
| `app_theme.dart` | Construir `ThemeData` claro e escuro e registrar extensoes |
| `app_colors.dart` | Cores primitivas, paletas base e conversoes documentadas |
| `app_color_tokens.dart` | `ThemeExtension<AppColorTokens>` com papeis semanticos adicionais |
| `app_theme_context.dart` | Acesso ergonomico e seguro ao tema a partir de `BuildContext` |
| `app_typography.dart` | Escala tipografica e familia da fonte |
| `app_spacing.dart` | Escala de espacamento, gaps e paddings |
| `app_radius.dart` | Raios e `BorderRadius` recorrentes |
| `app_shadows.dart` | Sombras de card, hero e superficies flutuantes |
| `app_sizes.dart` | Alturas de toque, icones, app bars e limites recorrentes |
| `app_decorations.dart` | Fabrica de decoracoes dependentes do tema |
| `app_icons.dart` | Aliases semanticos de icones globais |

### Fronteiras

`app/theme/` deve conter somente linguagem visual global. Nao deve conter:

- widgets de produto, dashboard, venda ou qualquer outra feature;
- regra de negocio;
- permissao;
- estado de sincronizacao;
- acesso a Riverpod, Dio, Drift ou repositorios;
- textos de interface;
- navegacao;
- valores financeiros ou formatacao de dominio.

`shared/widgets/` recebera componentes reutilizaveis em specs posteriores.
Esta spec nao cria `AppButton`, `AppCard`, `AppTextField` ou estados vazios.

Widgets especificos permanecem em
`features/<feature>/presentation/widgets/`. Uma feature so deve criar tokens
proprios se houver identidade visual realmente distinta e documentada.

### Modelo de cores

O sistema de cores tera duas camadas que nao devem ser confundidas.

#### Cores primitivas

`app_colors.dart` contem somente valores base e paletas de implementacao, por
exemplo tons de azul, navy, verde, amarelo e vermelho. Esses valores existem
para montar os temas, mas nao formam a API preferencial dos widgets.

Widgets de aplicacao nao devem consultar diretamente tons como:

```dart
AppColors.blue900
AppColors.navy950
```

O uso direto de uma cor primitiva so e aceitavel dentro da montagem do tema,
dos tokens ou de uma excecao visual documentada.

#### Papeis semanticos

`ColorScheme` sera a fonte principal para papeis Material 3. Cores sem papel
equivalente no Material devem ser expostas por
`ThemeExtension<AppColorTokens>`.

Uso esperado:

```dart
final colors = Theme.of(context).colorScheme;
final tokens = Theme.of(context).extension<AppColorTokens>()!;

Container(color: colors.surface);
Container(color: tokens.surfaceHero);
```

Uso incorreto em widgets:

```dart
Container(color: AppColors.blue900);
```

Essa separacao evita que features dependam de um tom especifico e permite que
o mesmo papel visual mude entre os temas.

### Mapeamento Material 3

Os nomes `background`, `foreground`, `card`, `muted` e `border` continuam
validos como conceitos do design system herdado da web. Eles nao significam
que a implementacao deva usar campos de mesmo nome no `ColorScheme`.

Este mapeamento segue a migracao oficial do Flutter para os novos papeis de
superficie do Material 3.

No Flutter Material 3:

| Conceito do design | Implementacao preferencial |
| --- | --- |
| background | `scaffoldBackgroundColor` e `colorScheme.surface` |
| foreground | `colorScheme.onSurface` |
| card | `colorScheme.surfaceContainerLow` ou `surface` |
| surface muted | `colorScheme.surfaceContainerHighest` ou token adicional |
| border | `AppColorTokens.borderSubtle` |
| hero | `AppColorTokens.surfaceHero` |
| chart 1 a 5 | `AppColorTokens.chart1` a `chart5` |

Nao usar os campos depreciados `ColorScheme.background`,
`ColorScheme.onBackground` ou `ColorScheme.surfaceVariant`. Quando necessario,
usar respectivamente `surface`, `onSurface` e
`surfaceContainerHighest`.

Papeis adicionais minimos:

- `surfaceMuted`;
- `surfaceHero`;
- `onSurfaceHero`;
- `onSurfaceMuted`;
- `success`;
- `onSuccess`;
- `successContainer`;
- `onSuccessContainer`;
- `warning`;
- `onWarning`;
- `warningContainer`;
- `onWarningContainer`;
- `restricted`;
- `onRestricted`;
- `borderSubtle`;
- `sidebarOperational`;
- `sidebarOperationalForeground`;
- `sidebarAdmin`;
- `sidebarAdminAccent`;
- `chart1` a `chart5`;
- gradientes atmosferico, hero e auth.

Widgets devem preferir:

```dart
Theme.of(context).colorScheme
```

e, para papeis adicionais:

```dart
Theme.of(context).extension<AppColorTokens>()
```

Para reduzir repeticao sem esconder a origem do tema,
`app_theme_context.dart` pode expor:

```dart
extension AppThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  AppColorTokens get appColors =>
      Theme.of(this).extension<AppColorTokens>()!;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
```

Essa extensao deve apenas encaminhar acesso. Ela nao deve conter regra visual,
fallback silencioso ou estado.

Nao sera permitido usar `Colors.white`, `Colors.black` ou uma cor clara fixa
como superficie de um widget que deva funcionar nos dois temas.

## Tokens

### Tema claro

Os valores documentados permanecem canonicos:

| Papel | Valor |
| --- | --- |
| background | `hsl(210 33% 98%)` |
| foreground | `hsl(215 34% 15%)` |
| surface/card | `hsl(0 0% 100%)` |
| primary | `hsl(213 77% 46%)` |
| primary foreground | `hsl(0 0% 100%)` |
| secondary | `hsl(210 21% 94%)` |
| secondary foreground | `hsl(215 25% 28%)` |
| muted | `hsl(210 18% 92%)` |
| muted foreground | `hsl(215 13% 42%)` |
| accent | `hsl(212 41% 95%)` |
| accent foreground | `hsl(213 77% 38%)` |
| border/input | `hsl(214 23% 88%)` |
| success | `hsl(152 60% 42%)` |
| warning | `hsl(38 92% 50%)` |
| danger | `hsl(348 83% 55%)` |
| sidebar operational | `#0B1A2B` |
| sidebar admin | `#0D1B2A` |
| admin accent | `#6D4DFF` |

Os valores HSL sao a referencia de design. A implementacao Flutter deve
materializa-los como constantes `Color` em hexadecimal, com conversao feita
antes da execucao e coberta por teste. Nao criar helpers HSL em runtime apenas
para construir constantes estaticas.

### Tema escuro

O modo escuro nao sera gerado por inversao automatica. A proposta inicial e:

| Papel conceitual | Valor inicial |
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

Esses valores sao baseline da implementacao, nao resultado final presumido.
Eles podem ser ajustados por contraste e coerencia visual, desde que o desvio
seja registrado no `review.md`.

A paleta dedicada deve manter:

- background azul-preto;
- superficies azul-grafite em niveis distintos;
- texto principal quase branco, sem branco absoluto como padrao;
- texto secundario azul-acinzentado claro;
- primary mais clara que no tema claro;
- bordas frias visiveis sem contraste excessivo;
- sucesso, alerta e erro ajustados para legibilidade;
- hero mais escuro que a superficie comum;
- sidebar operacional mais escura que o background;
- charts distinguiveis entre si e nos dois modos.

Os valores finais do tema escuro devem ser registrados no `review.md` e
validados por contraste antes do fechamento. Esta spec nao autoriza copiar
automaticamente cores geradas por `ColorScheme.fromSeed`.

### Graficos

A ordem semantica deve ser preservada:

1. azul principal;
2. verde petroleo;
3. azul profundo;
4. amarelo ouro;
5. laranja suave.

Os tons podem variar por brilho, mas a ordem e o reconhecimento entre web e
mobile devem permanecer.

### Espacamento

Escala base:

| Token | Valor |
| --- | --- |
| `xxs` | `2` |
| `xs` | `4` |
| `sm` | `8` |
| `md` | `12` |
| `lg` | `16` |
| `xl` | `24` |
| `xxl` | `32` |
| `xxxl` | `40` |

O nome do token deve comunicar escala, nao contexto de uma feature.

### Raios

| Token | Valor |
| --- | --- |
| `sm` | `8` |
| `md` | `10` |
| `lg` | `12` |
| `xl` | `16` |
| `hero` | `28` |
| `pill` | circular completo |

Devem existir valores `Radius` e `BorderRadius` quando isso reduzir repeticao
sem esconder a geometria do componente.

### Tamanhos

Valores globais minimos:

- alvo de toque: no minimo `48`;
- input e botao principal: `48`;
- icone inline: `18`;
- icone de acao: `20`;
- icone de navegacao: `22`;
- icone de destaque: `24`;
- largura maxima de conteudo compacto da tela transitoria: `440`.

### Sombras

Devem existir tres papeis:

- `card`: leve, curta e difusa;
- `hero`: media e difusa;
- `floating`: para sheets, menus e modais.

Cards comuns devem depender principalmente de borda e contraste de superficie,
com sombra quase imperceptivel. Hero e superficies flutuantes podem usar sombra
moderada. No tema escuro, elevacao deve depender de borda e niveis de
superficie, nao de sombra preta intensa.

### Composicao mobile

Regras globais de composicao:

- telas usam padding horizontal padrao de `16`;
- secoes principais usam gap vertical de `24`;
- listas e grupos de cards usam gap de `12` ou `16`;
- cards operacionais usam padding interno de `16`;
- controles interativos usam altura minima de `48`;
- telas transitorias podem limitar conteudo compacto a `440`;
- blocos nao devem ficar colados as bordas fisicas da tela.

Essas regras usam tokens existentes e nao criam componentes nesta spec.

### Tipografia

Familia principal:

```text
Instrument Sans
```

Fallback:

```text
system-ui, sans-serif
```

A implementacao deve:

- incluir os arquivos locais da fonte como assets antes de declarar a familia;
- usar pesos realmente empacotados;
- manter titulos compactos em `semibold` ou `bold`;
- usar labels de secao entre 10 e 12, frequentemente em uppercase;
- usar corpo entre 14 e 16;
- usar captions entre 12 e 13;
- evitar tamanhos fixos fora da escala sem justificativa.

Se os arquivos da Instrument Sans nao estiverem disponiveis durante a
implementacao, o fallback deve permanecer e a limitacao deve ser registrada.
Nao se deve declarar uma fonte ausente.

### Iconografia

`app_icons.dart` deve oferecer aliases semanticos apenas para conceitos globais,
por exemplo:

- inicio/painel;
- produtos;
- vendas/pedidos;
- estoque;
- mais;
- busca;
- filtro;
- configuracoes;
- tema claro/escuro;
- sucesso, alerta e erro.

Os icones devem usar estilo outline consistente. O arquivo nao deve virar um
catalogo de icones especificos de cada feature.

## ThemeData

`AppTheme` deve expor dois temas completos:

```dart
AppTheme.light
AppTheme.dark
```

ou getters/metodos equivalentes, mantendo uma API unica e previsivel.

Cada tema deve configurar, quando aplicavel:

- `ColorScheme`;
- `TextTheme`;
- `scaffoldBackgroundColor`;
- `appBarTheme`;
- `cardTheme`;
- `dividerTheme`;
- `inputDecorationTheme`;
- `filledButtonTheme`;
- `outlinedButtonTheme`;
- `textButtonTheme`;
- `iconButtonTheme`;
- `floatingActionButtonTheme`;
- `navigationBarTheme`;
- `bottomSheetTheme`;
- `dialogTheme`;
- `chipTheme`;
- `progressIndicatorTheme`;
- `snackBarTheme`;
- `tooltipTheme`;
- `visualDensity`;
- `extensions`.

Componentes Material devem obter seus estilos por `ThemeData`. Decoracoes
manuais ficam reservadas para assinaturas que o tema Material nao representa,
como background atmosferico e hero.

## Decoracoes

`AppDecorations` deve expor fabricas ou metodos que recebam `BuildContext`,
`ThemeData`, `ColorScheme` ou tokens explicitos.

Permitido:

```dart
AppDecorations.card(context)
AppDecorations.hero(context)
AppDecorations.atmosphericBackground(context)
```

Evitar:

```dart
static final card = BoxDecoration(color: Colors.white);
```

As decoracoes globais previstas sao:

- card padrao;
- card elevado;
- hero escuro;
- superficie flutuante;
- fundo atmosferico;
- badge tonal de sucesso, alerta, erro e restrito.

Badges completos, com layout e texto, permanecem fora de escopo.

Papeis tonais previstos:

| Estado | Fundo | Conteudo |
| --- | --- | --- |
| sucesso | `successContainer` | `onSuccessContainer` |
| alerta | `warningContainer` | `onWarningContainer` |
| erro | `colorScheme.errorContainer` | `colorScheme.onErrorContainer` |
| restrito | `restricted` | `onRestricted` |

## Integracao no aplicativo

`AraraApp` deve configurar:

```dart
theme: AppTheme.light,
darkTheme: AppTheme.dark,
themeMode: ThemeMode.system,
```

`ThemeMode.system` e o comportamento inicial. Preferencia manual, persistencia
e tela de configuracao ficam fora desta spec.

A `StartupPage` deve ser migrada para consumir os tokens globais e funcionar
nos dois modos, sem criar uma nova tela de demonstracao.

## Regras de interface

- cor nunca deve ser o unico indicador de estado;
- contraste de texto e controles deve ser verificado nos dois temas;
- foco, selecao e estados desabilitados devem permanecer perceptiveis;
- alvos interativos devem respeitar no minimo 48 por 48;
- o tema escuro deve preservar hierarquia entre background, surface e hero;
- o tema claro deve manter o fundo atmosferico, nao branco puro;
- cards devem manter borda sutil e sombra curta;
- o dashboard futuro deve poder usar hero navy em ambos os temas;
- tema admin roxo nao deve substituir o tema operacional azul.

## Dados locais, rede e permissoes

Esta spec nao consome contrato remoto, nao cria persistencia e nao depende de
permissoes.

A preferencia manual de tema nao sera armazenada. Quando entrar no escopo,
devera ser definida em spec propria ou ampliacao formal, usando estado e
persistencia compativeis com as decisoes do projeto.

## Fora de escopo

- componentes reutilizaveis em `shared/widgets/`;
- telas de dashboard, catalogo, vendas, estoque ou configuracoes;
- bottom navigation funcional;
- preferencia manual de tema;
- persistencia do tema;
- tema automatico por horario;
- tema admin funcional;
- dark mode de imagens;
- graficos reais;
- animacoes de troca de tema;
- integracao com backend;
- alteracao de regras de negocio;
- design responsivo de features.

## Dependencias

A implementacao nao deve adicionar package de tema ou design system.

Pode ser necessario adicionar arquivos locais da Instrument Sans ao
`pubspec.yaml`. Nenhuma fonte deve ser baixada em runtime.

Antes de adicionar uma biblioteca de icones externa, deve existir justificativa
e verificacao de licenca. Esta spec pode ser concluida usando os icones Material
outline ja disponiveis.

Dependencias como `flutter_svg`, `lucide_icons_flutter` e
`accessibility_tools` podem ser avaliadas em specs que realmente precisem
delas. Elas nao sao necessarias nem autorizadas automaticamente por esta spec.
Nao usar `google_fonts` para baixar a fonte em runtime e nao introduzir
`flex_color_scheme` nesta entrega.

## Riscos

- escolher tons escuros sem contraste suficiente;
- expor paleta bruta e incentivar uso incorreto por widgets;
- usar papeis depreciados do `ColorScheme`;
- criar decoracoes estaticas presas ao tema claro;
- duplicar papeis entre `ColorScheme` e a extensao;
- tornar os arquivos de tokens excessivamente abstratos;
- declarar pesos da fonte que nao foram empacotados;
- alterar snapshots visuais sem atualizar os testes;
- transformar `app_icons.dart` em dependencia de dominio;
- antecipar componentes que pertencem a specs de features.

## Criterios de aceite

- os onze arquivos da estrutura alvo existem e possuem responsabilidade clara;
- cores primitivas e papeis semanticos estao separados;
- widgets migrados nao consultam a paleta primitiva diretamente;
- `AppTheme` oferece temas Material 3 claro e escuro;
- `AraraApp` configura `theme`, `darkTheme` e `ThemeMode.system`;
- o tema claro preserva os tokens documentados;
- o tema escuro usa paleta dedicada, nao inversao automatica;
- cores adicionais usam `ThemeExtension` ou mecanismo equivalente;
- nenhum campo depreciado de background do `ColorScheme` e usado;
- os conceitos vindos da web possuem mapeamento Material 3 documentado;
- a proposta inicial da paleta escura foi validada ou ajustada com evidencia;
- tipografia, espacamento, raios, sombras e tamanhos estao centralizados;
- decoracoes globais respeitam o tema ativo;
- a tela transitoria renderiza corretamente nos dois modos;
- nao existem cores claras fixas em superficies migradas;
- nenhuma feature, endpoint, permissao ou persistencia e inventada;
- testes automatizados cobrem os dois temas e os tokens essenciais;
- validacao visual ocorre em modo claro e escuro, em largura mobile;
- `dart format`, `flutter analyze` e testes relevantes terminam sem erro;
- resultados, valores finais do dark mode e limitacoes constam em `review.md`.
