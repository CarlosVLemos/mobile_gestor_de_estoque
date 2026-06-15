# Spec 003 - Catalogo de Componentes Compartilhados

## Objetivo

Documentar os componentes reutilizaveis criados para a interface operacional
inicial. Este arquivo nao substitui testes ou a propria API do widget. Ele
serve para orientar reuso e evitar que um padrao global acabe copiado para
varias features com pequenas variacoes.

## Como preencher

Para cada componente criado em `lib/shared/widgets/`, registrar:

- nome;
- objetivo;
- onde usar;
- onde nao usar;
- parametros publicos;
- variacoes visuais;
- estados suportados;
- exemplo curto;
- observacoes de acessibilidade ou limites.

### `AppShellScaffold`

**Objetivo**

- estruturar a shell operacional com corpo principal, bottom navigation e
  banner opcional.

**Onde usar**

- ponto central da navegacao primaria do app.

**Onde nao usar**

- telas internas de feature que nao controlam a shell.

**API publica**

```dart
AppShellScaffold(
  body: ...,
  currentIndex: 0,
  destinations: const [...],
  onSelect: (index) {},
  banner: null,
)
```

**Variacoes**

- com ou sem `banner`.

**Estados suportados**

- shell pronta;
- shell com aviso global.

**Exemplo**

```dart
AppShellScaffold(
  body: navigationShell,
  currentIndex: navigationShell.currentIndex,
  destinations: const [...],
  onSelect: navigationShell.goBranch,
)
```

**Observacoes**

- nao define regras de permissao nem de roteamento.

### `AppBottomNavigation`

**Objetivo**

- encapsular a `NavigationBar` do app com API pequena e orientada a destinos.

**Onde usar**

- shell operacional e futuras shells equivalentes.

**Onde nao usar**

- listas locais de acoes ou filtros.

**API publica**

```dart
AppBottomNavigation(
  currentIndex: 0,
  destinations: const [
    AppBottomNavigationDestination(label: 'Painel', icon: AppIcons.dashboard),
  ],
  onSelect: (index) {},
)
```

**Variacoes**

- quantidade variavel de destinos.

**Estados suportados**

- item selecionado;
- troca de destino.

**Exemplo**

```dart
AppBottomNavigation(
  currentIndex: 1,
  destinations: destinations,
  onSelect: (index) {},
)
```

**Observacoes**

- nao faz `go_router` sozinho; recebe callback externo.

### `SectionHeader`

**Objetivo**

- padronizar cabecalhos de secao com titulo, subtitulo e acao opcional.

**Onde usar**

- dashboard, catalogo, mais e contexto operacional.

**Onde nao usar**

- app bar principal ou hero de tela.

**API publica**

```dart
SectionHeader(
  title: 'KPIs resumidos',
  subtitle: 'Leitura compacta para operacao em campo.',
  action: TextButton(onPressed: () {}, child: const Text('Ver mais')),
)
```

**Variacoes**

- apenas titulo;
- titulo + subtitulo;
- titulo + subtitulo + acao.

**Estados suportados**

- leitura estatica.

**Exemplo**

```dart
const SectionHeader(
  title: 'Movimentos recentes',
  subtitle: 'Resumo do fluxo operacional.',
)
```

**Observacoes**

- usar apenas para agrupamento de conteudo, nao como componente de status.

### `StatusBadge`

**Objetivo**

- representar estados compactos com semantica consistente de tom.

**Onde usar**

- estoque, disponibilidade, restricao, offline, feature e permissao.

**Onde nao usar**

- mensagens longas ou erro completo de tela.

**API publica**

```dart
const StatusBadge(
  label: 'Restrito',
  tone: AppStatusTone.restricted,
)
```

**Variacoes**

- `success`;
- `warning`;
- `error`;
- `restricted`.

**Estados suportados**

- status curto e contextual.

**Exemplo**

```dart
const StatusBadge(
  label: 'Offline',
  tone: AppStatusTone.warning,
)
```

**Observacoes**

- cor nao deve ser o unico sinal; sempre ha texto.

### `EmptyStateCard`

**Objetivo**

- mostrar ausencia de dados ou filtros sem resultado com copy acionavel.

**Onde usar**

- dashboard e catalogo.

**Onde nao usar**

- erros tecnicos ou restricao de acesso.

**API publica**

```dart
EmptyStateCard(
  title: 'Nenhum produto encontrado',
  message: 'Ajuste a busca ou aguarde a proxima atualizacao.',
  action: null,
)
```

**Variacoes**

- com ou sem acao.

**Estados suportados**

- vazio geral;
- vazio por filtro.

**Exemplo**

```dart
const EmptyStateCard(
  title: 'Sem dados suficientes',
  message: 'O painel sera preenchido quando houver recorte valido.',
)
```

**Observacoes**

- preferir copy especifica por tela.

### `FailureStateCard`

**Objetivo**

- comunicar falha tecnica preservando um CTA externo de retry.

**Onde usar**

- dashboard, catalogo e contexto operacional.

**Onde nao usar**

- restricoes funcionais ou falta de dados.

**API publica**

```dart
FailureStateCard(
  title: 'Falha ao consultar o catalogo',
  message: 'Tente novamente em instantes.',
  action: TextButton(onPressed: () {}, child: const Text('Tentar novamente')),
)
```

**Variacoes**

- falha completa;
- falha sobre dados ainda visiveis.

**Estados suportados**

- erro tecnico com CTA opcional.

**Exemplo**

```dart
FailureStateCard(
  title: 'Atualizacao remota indisponivel',
  message: 'O conteudo local permanece visivel.',
)
```

**Observacoes**

- retry deve ficar no controller, nao no componente.

### `OfflineStateBanner`

**Objetivo**

- destacar estado offline sem apagar o conteudo ja visivel.

**Onde usar**

- telas que preservam dados durante desconexao.

**Onde nao usar**

- como substituto de `FailureStateCard`.

**API publica**

```dart
const OfflineStateBanner(
  message: 'Voce esta vendo o ultimo recorte local disponivel.',
)
```

**Variacoes**

- copy curta por feature.

**Estados suportados**

- offline com dados mantidos.

**Exemplo**

```dart
const OfflineStateBanner(
  message: 'A lista local continua visivel ate a proxima sincronizacao.',
)
```

**Observacoes**

- usa badge textual para nao depender apenas de cor.

### `RestrictedInfoCard`

**Objetivo**

- representar indisponibilidade funcional ou permissao ausente sem parecer erro
  tecnico.

**Onde usar**

- catalogo, dashboard e contexto operacional.

**Onde nao usar**

- respostas vazias ou falhas de rede.

**API publica**

```dart
RestrictedInfoCard(
  title: 'Seu perfil nao pode consultar produtos',
  message: 'O backend indicou restricao para este modulo.',
  action: null,
)
```

**Variacoes**

- com ou sem acao.

**Estados suportados**

- permissao restrita;
- feature desativada.

**Exemplo**

```dart
const RestrictedInfoCard(
  title: 'Catalogo indisponivel para este tenant',
  message: 'O modulo esta desativado neste contexto.',
)
```

**Observacoes**

- usar copy distinta para permissao e feature.

### `KpiCard`

**Objetivo**

- consolidar o visual dos indicadores do dashboard, incluindo variante hero e
  restricao financeira explicita.

**Onde usar**

- dashboard e futuras telas de indicadores compactos.

**Onde nao usar**

- cards de listagem de produto ou contexto.

**API publica**

```dart
const KpiCard(
  label: 'Pedidos em campo',
  value: '128',
  subtitle: '26 aguardando conferencia',
  highlight: true,
)
```

**Variacoes**

- hero destacado;
- card padrao;
- valor restrito.

**Estados suportados**

- dado disponivel;
- dado restrito.

**Exemplo**

```dart
const KpiCard(
  label: 'Receita prevista',
  value: null,
  subtitle: 'Liberada apenas para perfis com permissao financeira',
)
```

**Observacoes**

- recebe valor ja pronto para exibicao.

### `ProductCard`

**Objetivo**

- renderizar item de catalogo com dados de apresentacao, sem depender da
  entidade da feature.

**Onde usar**

- listas e grids operacionais de produto.

**Onde nao usar**

- detalhe completo de produto ou formularios.

**API publica**

```dart
const ProductCard(
  product: ProductCardData(
    name: 'Capacete Trail Pro',
    sku: 'SKU-TRAIL-001',
    brand: 'Arara Motion',
    stockQuantity: 3,
    stockTone: ProductCardStockTone.low,
    availableForSale: true,
    updatedAtLabel: '12 jun, 09:10',
    price: null,
    categoryName: 'Protecao',
  ),
)
```

**Variacoes**

- com preco;
- com preco restrito;
- com categorias e estados de estoque diferentes.

**Estados suportados**

- estoque disponivel, baixo ou zerado;
- venda disponivel ou revalidada;
- preco presente ou restrito.

**Exemplo**

```dart
const ProductCard(
  product: ProductCardData(
    name: 'Kit Sinalizacao LED',
    sku: 'SKU-LED-443',
    brand: 'Visio',
    stockQuantity: 18,
    stockTone: ProductCardStockTone.available,
    availableForSale: true,
    updatedAtLabel: '12 jun, 08:42',
    price: 49.9,
  ),
)
```

**Observacoes**

- o componente nao carrega imagem nem consulta repositorio.

### `MovementListItem`

**Objetivo**

- padronizar a leitura compacta de movimentos recentes.

**Onde usar**

- dashboard e futuros feeds operacionais.

**Onde nao usar**

- timeline detalhada com multiplas acoes por item.

**API publica**

```dart
const MovementListItem(
  data: MovementListItemData(
    title: 'Capacete Trail Pro',
    subtitle: 'Saida para venda • 12 jun, 08:20',
    trailing: '2 unidades',
  ),
)
```

**Variacoes**

- qualquer combinacao de titulo, subtitulo e destaque final.

**Estados suportados**

- item de lista pronto.

**Exemplo**

```dart
const MovementListItem(
  data: MovementListItemData(
    title: 'Kit Sinalizacao LED',
    subtitle: 'Reposicao recebida • 12 jun, 07:45',
    trailing: '15 unidades',
  ),
)
```

**Observacoes**

- valores devem chegar formatados para apresentacao.

### `TenantContextCard`

**Objetivo**

- resumir tenant e usuario no topo do contexto operacional.

**Onde usar**

- tela de contexto e futuras telas de sessao.

**Onde nao usar**

- cards pequenos de lista.

**API publica**

```dart
const TenantContextCard(
  tenantName: 'Arara Centro Logistico',
  tenantSlug: 'arara-centro-logistico',
  userName: 'Maria Oliveira',
  userEmail: 'maria@arara-gastos.test',
)
```

**Variacoes**

- leitura estatica unica.

**Estados suportados**

- contexto pronto.

**Exemplo**

```dart
const TenantContextCard(
  tenantName: 'Empresa Teste',
  tenantSlug: 'empresa-teste',
  userName: 'Maria',
  userEmail: 'maria@empresa.test',
)
```

**Observacoes**

- manter foco em contexto operacional, nao em perfil completo.

### `FeaturePill`

**Objetivo**

- comunicar features ativas ou indisponiveis em formato compacto.

**Onde usar**

- contexto operacional e sumarios de modulo.

**Onde nao usar**

- badges de erro ou acao.

**API publica**

```dart
const FeaturePill(label: 'catalog', enabled: true)
```

**Variacoes**

- habilitada;
- desabilitada.

**Estados suportados**

- ativo/inativo.

**Exemplo**

```dart
const FeaturePill(label: 'reports', enabled: false)
```

**Observacoes**

- nomes de feature devem vir do contrato ou de copy claramente mapeada.

### `PermissionListTile`

**Objetivo**

- listar permissoes relevantes com descricao curta e estado visual.

**Onde usar**

- contexto operacional e futuras telas administrativas compactas.

**Onde nao usar**

- listas muito densas com dezenas de permissoes tecnicas.

**API publica**

```dart
const PermissionListTile(
  label: 'Consultar catalogo',
  description: 'Habilita leitura do modulo de produtos.',
  allowed: true,
)
```

**Variacoes**

- permitido;
- restrito.

**Estados suportados**

- leitura de permissao pontual.

**Exemplo**

```dart
const PermissionListTile(
  label: 'Ver metricas financeiras',
  description: 'Controla preco e indicadores sensiveis.',
  allowed: false,
)
```

**Observacoes**

- texto deve explicar impacto operacional, nao so repetir a chave tecnica.
