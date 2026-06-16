# Spec 005 - Identidade Visual Operacional

## Status

Planejada em 15 de junho de 2026. Nao implementada.

Esta spec exige aprovacao explicita antes de qualquer alteracao em `lib/`,
`pubspec.yaml`, assets, dependencias ou testes do aplicativo.

## Classificacao

- interface;
- sistema visual;
- componentes reutilizaveis;
- acessibilidade;
- documentacao.

## Fontes e hierarquia

Esta spec e governada pelo `AGENTS.md` da raiz e usa
`para mobile/00-contexto-operacional.md` como ponto de entrada.

Fontes aplicaveis, na ordem de precedencia do projeto:

1. decisoes aceitas em `para mobile/06-registro-decisoes.md`;
2. arquitetura em `para mobile/05-arquitetura-mobile.md`;
3. regras de negocio em `para mobile/04-regras-e-necessidades-mobile.md`;
4. interface em `para mobile/02-definicoes-de-interface.md`;
5. contratos existentes em `para mobile/03-endpoints-mobile.md`;
6. blueprint visual em `para mobile/designmobile.md`;
7. processo em `para mobile/08-processo-de-trabalho.md`;
8. implementacao atual em `lib/`.

As imagens em `docs/specs/Img/` sao referencias de composicao, densidade,
hierarquia e ritmo. Nao sao alvos de copia pixel a pixel e nao autorizam a
criacao de campos, acoes, modulos ou dados ausentes.

## Contexto

As Specs 002, 003 e 004 entregaram:

- tema claro e escuro;
- shell operacional;
- dashboard, catalogo, Mais e contexto operacional;
- componentes compartilhados;
- gradientes, blur e transicoes;
- estados visuais explicitos.

A base e funcional, mas parte relevante da interface ainda revela a linguagem
padrao do Material 3. O problema nao e falta de efeitos: e falta de uma
assinatura de produto consistente entre tipografia, navegacao, headers, cards,
listas e iconografia.

## Problema

O aplicativo ainda e percebido como generico pelos seguintes motivos:

- `Instrument Sans` esta documentada, mas nao empacotada; o app usa a fonte
  padrao da plataforma;
- a navegacao inferior encapsula uma `NavigationBar` Material quase integral;
- headers reutilizam uma composicao hero em telas que pedem leitura compacta;
- cards acumulam badges, containers e raios grandes, reduzindo a hierarquia;
- placeholders por inicial parecem dados demonstrativos, nao linguagem final;
- profundidade, blur e gradiente aparecem em mais lugares do que o necessario;
- dashboard, catalogo e telas auxiliares nao compartilham um ritmo editorial
  suficientemente reconhecivel.

## Objetivo

Estabelecer uma identidade visual operacional propria para o Arara-Gastos
mobile, combinando:

- clareza e densidade das referencias em `docs/specs/Img/`;
- identidade azul, fria e analitica do produto;
- hero escuro exclusivo do dashboard;
- tipografia Instrument Sans;
- iconografia outline consistente;
- componentes compactos com hierarquia forte;
- interacoes curtas e funcionais.

O resultado deve parecer uma extensao intencional do Arara-Gastos, e nao um
tema aplicado sobre componentes Material padrao.

## Principios visuais

### 1. Clareza antes de ornamentacao

- uma superficie deve ter uma funcao visual clara;
- evitar cards dentro de cards sem necessidade estrutural;
- evitar varios badges competindo pelo mesmo item;
- usar cor para estado, nao para preencher espaco.

### 2. Profundidade seletiva

- manter hero escuro apenas no dashboard;
- manter blur apenas na shell inferior;
- usar borda sutil como separacao primaria;
- reservar sombras para superficies realmente elevadas.

### 3. Hierarquia operacional

- valores e quantidades dominam cards de leitura rapida;
- titulo, codigo e metadata devem ter niveis inequivocos;
- status principal deve ser identificado por texto e tom;
- a informacao mais importante deve ser compreendida sem abrir detalhes.

### 4. Densidade mobile controlada

- manter padding horizontal base de 16;
- usar gaps de 12 ou 16 em listas e cards;
- reservar gaps de 24 para mudanca real de secao;
- manter controles com alvo minimo de 48 por 48;
- evitar espacos vazios que diluam a leitura operacional.

### 5. Reflow antes de truncamento

- componentes devem crescer verticalmente quando a escala de texto aumentar;
- `Row` com texto e trailing deve migrar para `Wrap`, `Column` ou layout
  adaptativo antes de causar overflow;
- titulos operacionais podem usar no maximo duas linhas com ellipsis;
- codigos, SKU, datas e labels curtas permanecem em uma linha com ellipsis;
- valores financeiros e quantidades nao devem ser truncados;
- quando valor e metadata nao couberem lado a lado, a metadata deve ir para a
  linha seguinte;
- badges devem quebrar em `Wrap`, nunca reduzir o texto abaixo da escala do
  usuario;
- nao usar `FittedBox` para contornar text scaling em conteudo informativo.

Regras por componente:

| Componente | Escala normal | Texto aumentado |
| --- | --- | --- |
| `OperationalTopBar` | titulo e acoes na mesma faixa quando couber | acoes passam para linha propria; titulo aceita duas linhas |
| `KpiCard` | label, valor e subtitulo em coluna | card cresce verticalmente; valor nunca usa ellipsis |
| `ProductCard` | nucleo e trailing lado a lado | trailing passa para bloco inferior; nome aceita duas linhas |
| Bottom navigation | icone sobre label | label aceita duas linhas curtas; altura inclui o reflow |
| Listas auxiliares | titulo e trailing lado a lado | trailing passa para linha inferior alinhada ao inicio |

### 6. Material como infraestrutura

Material continua permitido para acessibilidade, foco, semantica e primitivas.
Widgets Material reconheciveis nao devem determinar a aparencia final da shell,
da navegacao, dos headers ou dos cards principais.

## Decisoes aplicaveis

| Decisao | Aplicacao nesta spec |
| --- | --- |
| MOB-002 | Mudancas permanecem organizadas nas camadas e features existentes |
| MOB-004 | Estado continua sob Riverpod, sem logica nova nos widgets |
| MOB-007 | Navegacao continua controlada por `go_router` |
| MOB-014 | Azul operacional e identidade web permanecem reconheciveis |
| MOB-015 | Permissoes orientam a UI sem substituir autorizacao remota |
| MOB-016 | Referencia visual nao transforma contrato planejado em implementado |
| UI-001 | Navegacao primaria permanece inferior e destinos secundarios em Mais |
| UI-002 | Conteudo operacional continua em cards e listas mobile |
| UI-003 | Dashboard preserva hero escuro |
| UI-004 | Status mantem semantica consistente |
| UI-005 | Dados visiveis permanecem durante refresh |
| UI-006 | `price = null` continua sendo estado restrito valido |

Nenhuma nova decisao arquitetural e necessaria. A spec detalha a aplicacao das
decisoes de interface ja aceitas.

## Escopo funcional

A identidade deve cobrir:

- startup;
- shell operacional;
- bottom navigation;
- dashboard;
- catalogo;
- tela Mais;
- contexto operacional;
- estados compartilhados aplicaveis.

Estados preservados:

- `loading`;
- `ready`;
- `refreshing`;
- `empty`;
- `offline`;
- `restricted`;
- `failure`.

## Fundações visuais

### Tipografia

Empacotar localmente Instrument Sans nos pesos:

- 400 regular;
- 500 medium;
- 600 semibold;
- 700 bold.

Regras:

- incluir arquivos de fonte e respectiva licenca;
- declarar apenas pesos realmente empacotados;
- usar fallback do sistema somente se o asset falhar;
- manter numeros de KPI com leitura tabular quando suportado;
- limitar uppercase a labels curtas e contextuais;
- evitar tracking alto em textos corridos.

Estrutura obrigatoria:

```text
assets/
  fonts/
    instrument_sans/
      InstrumentSans-Regular.ttf
      InstrumentSans-Medium.ttf
      InstrumentSans-SemiBold.ttf
      InstrumentSans-Bold.ttf
      OFL.txt
```

Os nomes internos podem vir de arquivos oficiais ou de instancias estaticas
geradas a partir da fonte variavel oficial, mas os arquivos versionados no
repositorio devem usar exatamente os nomes acima. Nao versionar simultaneamente
a fonte variavel e os quatro pesos estaticos.

Declaracao obrigatoria em `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  fonts:
    - family: Instrument Sans
      fonts:
        - asset: assets/fonts/instrument_sans/InstrumentSans-Regular.ttf
          weight: 400
        - asset: assets/fonts/instrument_sans/InstrumentSans-Medium.ttf
          weight: 500
        - asset: assets/fonts/instrument_sans/InstrumentSans-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/instrument_sans/InstrumentSans-Bold.ttf
          weight: 700
```

Fonte de referencia:

- Google Fonts, familia `Instrument Sans`;
- licenca SIL Open Font License em `OFL.txt`;
- conferir integridade e licenca antes de versionar.

### Iconografia

Adicionar `lucide_icons_flutter ^3.1.14+2`.

Regras:

- imports da dependencia ficam encapsulados em `AppIcons`;
- features consomem aliases semanticos, nao `LucideIcons` diretamente;
- usar estilo outline e peso visual consistente;
- aliases globais ficam em `AppIcons`;
- icones muito especificos permanecem proximos da feature;
- manter fallback generico para categoria desconhecida.

Todos os aliases atuais de `AppIcons` devem ser migrados conforme esta tabela.
Os nomes Lucide devem ser reconfirmados contra a versao travada no
`pubspec.lock`; divergencia de API exige atualizar a spec antes de escolher
outro glifo.

| Alias `AppIcons` | Material atual | Lucide obrigatorio |
| --- | --- | --- |
| `dashboard` | `Icons.space_dashboard_outlined` | `LucideIcons.layoutDashboard` |
| `insights` | `Icons.insights_outlined` | `LucideIcons.barChart3` |
| `products` | `Icons.inventory_2_outlined` | `LucideIcons.package` |
| `sales` | `Icons.receipt_long_outlined` | `LucideIcons.receipt` |
| `inventory` | `Icons.warehouse_outlined` | `LucideIcons.warehouse` |
| `more` | `Icons.grid_view_rounded` | `LucideIcons.grid2X2` |
| `account` | `Icons.person_outline_rounded` | `LucideIcons.userCircle` |
| `tenant` | `Icons.apartment_rounded` | `LucideIcons.building2` |
| `openInNew` | `Icons.open_in_new_rounded` | `LucideIcons.externalLink` |
| `lock` | `Icons.lock_outline_rounded` | `LucideIcons.lock` |
| `wifiOff` | `Icons.wifi_off_rounded` | `LucideIcons.wifiOff` |
| `storefront` | `Icons.storefront_outlined` | `LucideIcons.store` |
| `schedule` | `Icons.schedule_rounded` | `LucideIcons.clock` |
| `refresh` | `Icons.sync_rounded` | `LucideIcons.refreshCw` |
| `bolt` | `Icons.bolt_rounded` | `LucideIcons.zap` |
| `arrowForward` | `Icons.arrow_forward_rounded` | `LucideIcons.arrowRight` |
| `tune` | `Icons.tune_rounded` | `LucideIcons.slidersHorizontal` |
| `shield` | `Icons.shield_outlined` | `LucideIcons.shield` |
| `search` | `Icons.search_rounded` | `LucideIcons.search` |
| `filter` | `Icons.filter_list_rounded` | `LucideIcons.listFilter` |
| `settings` | `Icons.settings_outlined` | `LucideIcons.settings` |
| `themeLight` | `Icons.light_mode_outlined` | `LucideIcons.sun` |
| `themeDark` | `Icons.dark_mode_outlined` | `LucideIcons.moon` |
| `success` | `Icons.check_circle_outline_rounded` | `LucideIcons.checkCircle` |
| `warning` | `Icons.warning_amber_rounded` | `LucideIcons.alertTriangle` |
| `error` | `Icons.error_outline_rounded` | `LucideIcons.xCircle` |

Aliases adicionais obrigatorios para o catalogo:

| Alias `AppIcons` | Lucide obrigatorio | Uso |
| --- | --- | --- |
| `productProtection` | `LucideIcons.shieldCheck` | categoria Protecao |
| `productElectrical` | `LucideIcons.cable` | categoria Eletrica |
| `productAccessories` | `LucideIcons.tag` | categoria Acessorios |
| `productFallback` | `LucideIcons.package` | categoria nula ou desconhecida |

O mapeamento de categoria para alias deve ficar na camada de presentation do
catalogo e usar comparacao normalizada, sem alterar o dominio:

```text
Protecao   -> AppIcons.productProtection
Eletrica   -> AppIcons.productElectrical
Acessorios -> AppIcons.productAccessories
outro/null -> AppIcons.productFallback
```

### Tokens do tema escuro

A Spec 005 preserva como paleta normativa os valores escuros ja materializados
no tema. A notacao HSL e a referencia de design; o hexadecimal e a referencia
de implementacao.

| Token | HSL | Hex |
| --- | --- | --- |
| background | `hsl(215 63% 7%)` | `#07111F` |
| surface | `hsl(215 57% 10%)` | `#0B1728` |
| surface-muted | `hsl(216 48% 13%)` | `#111E31` |
| surface-hero | `hsl(214 66% 7%)` | `#06101D` |
| border | `hsl(217 36% 21%)` | `#223149` |
| text-primary | `hsl(215 52% 94%)` | `#E6EDF7` |
| text-secondary | `hsl(216 23% 68%)` | `#9BAAC0` |
| primary | `hsl(216 100% 72%)` | `#6EA8FF` |
| success | `hsl(158 64% 52%)` | `#36D399` |
| warning | `hsl(43 96% 56%)` | `#FBBF24` |
| danger | `hsl(351 95% 71%)` | `#FB7185` |
| success-container | `hsl(152 51% 14%)` | `#123726` |
| on-success-container | `hsl(151 71% 79%)` | `#A5F0CC` |
| warning-container | `hsl(38 76% 16%)` | `#49320A` |
| on-warning-container | `hsl(42 100% 81%)` | `#FFE3A0` |
| danger-container | `hsl(344 52% 19%)` | `#4B1826` |
| on-danger-container | `hsl(350 100% 88%)` | `#FFC0CB` |
| restricted | `hsl(213 37% 14%)` | `#172332` |
| on-restricted | `hsl(214 30% 84%)` | `#C9D4E2` |

Regras:

- nao derivar automaticamente o tema escuro da paleta clara;
- usar `surface` para cards e `surface-muted` para agrupamentos tonais;
- reservar `surface-hero` ao dashboard e superficies de contraste equivalente;
- bordas devem permanecer visiveis sem criar contorno luminoso;
- status usam seus containers dedicados;
- qualquer alteracao nos valores acima exige atualizar golden tests e esta
  tabela.

### Tokens tonais do tema claro

Os containers semanticos claros tambem sao normativos. A notacao HSL e a
referencia de design; o hexadecimal e a referencia de implementacao.

| Token | HSL | Hex |
| --- | --- | --- |
| success-container | `hsl(150 47% 93%)` | `#E6F6EE` |
| on-success-container | `hsl(153 57% 27%)` | `#1D6B48` |
| warning-container | `hsl(40 100% 92%)` | `#FFF1D6` |
| on-warning-container | `hsl(40 100% 27%)` | `#8A5B00` |
| error-container | `hsl(346 84% 95%)` | `#FDE8ED` |
| on-error-container | `hsl(345 70% 38%)` | `#A41D3E` |
| restricted | `hsl(213 36% 95%)` | `#EEF2F7` |
| on-restricted | `hsl(214 21% 37%)` | `#4B5C73` |

Regras:

- containers claros usam texto foreground dedicado;
- nao aplicar branco ou preto generico sobre containers sem validar contraste;
- warning e error nao devem compartilhar o mesmo container;
- restricted permanece fora de `ColorScheme` por nao possuir equivalente
  semantico nativo;
- qualquer alteracao nos valores acima exige atualizar golden tests e esta
  tabela.

### Nomenclatura `danger` e `error`

A identidade visual usa `danger` como nome do token bruto da marca. A API
semantica do Flutter e dos componentes usa `error`.

Mapeamento obrigatorio:

| Camada | Nomenclatura | Responsabilidade |
| --- | --- | --- |
| `AppColors` | `danger`, `dangerDark`, `dangerContainer*`, `dangerForeground*` | valores primitivos da marca |
| `ColorScheme` | `error`, `errorContainer`, `onErrorContainer` | exposicao semantica nativa do Flutter |
| `AppStatusTone` | `error` | selecao de estado critico em widgets |
| `AppIcons` | `error` | alias semantico do icone critico |
| `AppColorTokens` | nenhuma propriedade `danger` ou `error` adicional | evitar duplicacao do `ColorScheme` |

Regras:

- `AppTheme` mapeia `AppColors.danger*` para os campos `error*` de
  `ColorScheme`;
- widgets devem consumir `context.colors.error`, `errorContainer` e
  `onErrorContainer`;
- componentes nao devem acessar `AppColors.danger*` diretamente;
- nao adicionar propriedades customizadas de danger em `AppColorTokens`;
- documentacao de design pode usar danger; APIs Dart expostas a widgets usam
  error.

### Superficies

- reduzir raio de cards operacionais para a faixa visual de 12 a 16;
- reservar raio de 24 a 28 para hero e modais;
- usar borda sutil em cards claros;
- evitar glassmorphism dentro do conteudo;
- manter fundo atmosferico discreto, sem manchas competindo com dados.

### Motion

- manter transicoes entre 160 e 250 ms;
- usar motion para mudanca de estado, press e navegacao;
- nao adicionar animacoes decorativas, looping ou parallax;
- respeitar reducao de movimento quando exposta pela plataforma.

## Componentes e interfaces publicas

Os nomes abaixo definem a direcao da API. A implementacao pode preservar
arquivos existentes durante a migracao, mas o resultado final deve expor estes
contratos ou equivalentes documentados.

### `OperationalTopBar`

Substitui o header hero nas telas compactas.

```dart
OperationalTopBar(
  title: 'Produtos',
  subtitle: 'Consulta operacional',
  leading: null,
  actions: const [],
)
```

Requisitos:

- titulo dominante;
- subtitulo opcional;
- leading e acoes opcionais;
- sem metricas, tags ou circulos decorativos;
- altura adaptavel a escala de texto.

### `DashboardHero`

Uso exclusivo no dashboard.

```dart
DashboardHero(
  title: 'Painel operacional',
  message: 'Resumo do tenant',
  updatedAtLabel: 'Atualizado agora',
  financialAccess: true,
)
```

Requisitos:

- gradiente navy;
- identidade Arara-Gastos;
- no maximo dois metadados secundarios;
- nenhuma acao sem comportamento real;
- sem grafico ou serie temporal inventada.

### `AppBottomNavigation`

Mantem a API orientada a destinos, mas deixa de renderizar `NavigationBar`.

```dart
AppBottomNavigation(
  currentIndex: 0,
  destinations: const [...],
  onSelect: (index) {},
)
```

Requisitos:

- tres destinos atuais;
- indicador ativo discreto;
- icone e label sempre legiveis;
- alvo minimo de 48 por 48;
- sem animacao elastica;
- sem dependencia de cor como unico sinal;
- incluir a SafeArea inferior dentro do proprio componente;
- calcular o inset com `MediaQuery.paddingOf(context).bottom`;
- aplicar o inset abaixo da area visual dos destinos, sem reduzir seus alvos;
- altura total = altura visual da barra + inset inferior;
- o componente pai nao deve aplicar a SafeArea inferior uma segunda vez.

Contrato estrutural esperado:

```dart
final bottomInset = MediaQuery.paddingOf(context).bottom;

Padding(
  padding: EdgeInsets.only(bottom: bottomInset),
  child: SizedBox(
    height: AppSizes.bottomNavigationHeight,
    child: ...,
  ),
)
```

`AppShellScaffold` deve usar a mesma altura visual mais o inset para calcular o
padding de conteudo. Em dispositivos sem inset, o comportamento permanece
inalterado.

### `KpiCard`

Evoluir o contrato para tom semantico explicito.

```dart
KpiCard(
  label: 'Estoque baixo',
  value: '24',
  subtitle: 'Acao necessaria',
  tone: KpiTone.critical,
)
```

Variantes:

- `neutral`;
- `positive`;
- `warning`;
- `critical`;
- `restricted`.

O destaque nao deve transformar qualquer KPI em mini hero.

### `ProductCard`

Manter `ProductCardData` desacoplado da entidade da feature e reorganizar a
apresentacao em linha compacta.

```dart
ProductCard(
  product: ProductCardData(...),
  categoryIcon: AppIcons.productFallback,
)
```

Requisitos:

- icone de categoria ou fallback;
- placeholder e um bloco tonal quadrado de 48 por 48, raio 12, contendo apenas
  o icone outline de categoria em 22 a 24;
- fundo do placeholder usa `primaryContainer` em estado neutro;
- estoque baixo ou zerado pode alterar borda/indicador do card, mas nao recolore
  arbitrariamente o icone da categoria;
- iniciais, avatares, imagens remotas e padroes geometricos nao sao usados;
- nome e SKU como nucleo;
- quantidade com prioridade visual;
- um status principal;
- preco opcional e sem erro quando ausente;
- metadata secundaria reduzida;
- nenhum carregamento de imagem ou acesso a repositorio.

## Aplicacao por tela

### Startup

- remover composicao de card promocional;
- apresentar marca, mensagem curta e progresso;
- manter erro e retry acessiveis;
- nao simular login.

### Dashboard

- usar `DashboardHero`;
- manter KPIs em grade adaptativa de duas colunas;
- aplicar variante critica somente a indicadores realmente criticos;
- manter alertas e movimentos em grupos compactos;
- nao adicionar grafico sem contrato ou fixture aprovada em spec propria;
- remover CTAs sem comportamento implementado.

### Catalogo

- usar `OperationalTopBar`;
- manter busca e filtros compactos;
- mostrar contagem e estado critico apenas com dados existentes;
- usar cards em linha, com um status principal;
- nao adicionar FAB sem caso de uso real.

### Mais

- usar `OperationalTopBar`;
- organizar destinos em grupos de lista;
- diferenciar destinos ativos, futuros e externos;
- evitar hero, metricas ficticias e badges redundantes.

### Contexto operacional

- usar `OperationalTopBar` com voltar;
- manter tenant e usuario em resumo compacto;
- agrupar features e permissoes;
- explicar restricoes sem parecer erro tecnico.

## Fora de escopo

- alterar regras de negocio;
- alterar controllers, use cases ou repositories por motivo nao visual;
- adicionar endpoints, DTOs ou persistencia;
- implementar autenticacao;
- adicionar vendas, estoque dedicado, historico ou relatorios;
- adicionar grafico com dados inventados;
- adicionar FAB ou CTA sem acao real;
- definir cores ou badges para estados futuros de outbox/sincronizacao;
- copiar nomes, textos ou marca `InventoryPro`;
- alterar imagens existentes em `docs/specs/Img/`;
- criar tema administrativo mobile.

Estados futuros como `pending`, `syncing`, `confirmed` e `failed_permanent`
devem ter sua semantica visual definida na spec responsavel pela implementacao
da outbox. A Spec 005 nao deve antecipar esse contrato.

## Riscos e mitigacoes

| Risco | Impacto | Mitigacao |
| --- | --- | --- |
| Regressao visual extensa | Alto | Migrar fundacoes e componentes antes das paginas; validar por etapa |
| Fonte aumenta tamanho do app | Baixo | Empacotar apenas quatro pesos e registrar licenca |
| Dependencia de icones se espalhar | Medio | Encapsular todos os imports em `AppIcons` |
| Golden tests ficarem frageis | Medio | Fixar tamanho, tema, locale, fontes e desativar animacoes |
| Texto grande causar overflow | Alto | Testar escala aumentada e usar layouts flexiveis |
| Dark mode perder contraste | Medio | Validar tokens e golden dedicado |
| Simplificacao esconder estados | Alto | Preservar texto e semantica de status, permissao e restricao |
| Spec 004 conflitar com a nova direcao | Medio | Registrar que a 005 substitui apenas escolhas visuais conflitantes |

## Criterios de aceite

- [ ] Instrument Sans esta empacotada nos pesos 400, 500, 600 e 700.
- [ ] A licenca da fonte esta versionada junto dos assets.
- [ ] `lucide_icons_flutter` esta encapsulado por `AppIcons`.
- [ ] Nenhuma feature importa `LucideIcons` diretamente.
- [ ] Todos os aliases de `AppIcons` seguem a tabela normativa.
- [ ] Categorias conhecidas e desconhecidas seguem o mapeamento definido.
- [ ] Tema escuro usa os tokens HSL e hex documentados.
- [ ] Containers claros usam os tokens HSL e hex documentados.
- [ ] `danger` permanece token bruto e `error` permanece API semantica.
- [ ] `AppColorTokens` nao duplica os campos de erro do `ColorScheme`.
- [ ] A shell nao renderiza `NavigationBar` ou `BottomNavigationBar`.
- [ ] A navegacao possui tres destinos, indicador ativo e alvos de 48 por 48.
- [ ] A bottom navigation absorve o inset inferior exatamente uma vez.
- [ ] Hero escuro aparece somente no dashboard.
- [ ] Catalogo, Mais e contexto usam header compacto.
- [ ] KPIs possuem hierarquia clara e variante critica sem excesso decorativo.
- [ ] Produtos usam linha compacta, icone de categoria e um status principal.
- [ ] Placeholders por inicial foram removidos.
- [ ] `price = null` continua sendo representado como restricao valida.
- [ ] Nao existem novos graficos, FABs ou CTAs sem comportamento real.
- [ ] Nenhuma semantica visual de outbox foi antecipada nesta spec.
- [ ] Startup, dashboard, catalogo, Mais e contexto compartilham a nova linguagem.
- [ ] Estados existentes continuam distinguiveis e acessiveis.
- [ ] Temas claro e escuro passam pela validacao visual.
- [ ] Escala de texto aumentada nao causa overflow bloqueante.
- [ ] Reflow segue as regras por componente e valores nao sao truncados.
- [ ] `dart format`, `flutter analyze` e `flutter test` passam.
- [ ] Golden tests de shell, dashboard e catalogo passam em `390x844`.
- [ ] O usuario aprova visualmente a nova identidade.

## Gate de implementacao

Esta spec pode ser revisada e aprovada como documento sem autorizar sua
execucao.

A implementacao somente pode comecar depois de uma solicitacao explicita do
usuario para executar a Spec 005. Ate esse momento:

- nao alterar `lib/`;
- nao alterar `pubspec.yaml` ou `pubspec.lock`;
- nao baixar ou adicionar fontes;
- nao adicionar dependencias;
- nao atualizar testes do aplicativo;
- nao marcar tarefas de implementacao como concluidas.
