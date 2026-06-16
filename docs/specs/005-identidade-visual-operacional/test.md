# Spec 005 - Plano de Testes

## Objetivo

Validar que a nova identidade visual:

- remove a aparencia reconhecivel de componentes Material padrao nas superficies
  principais;
- preserva comportamento, navegacao, permissoes e estados;
- permanece legivel e acessivel;
- funciona nos temas claro e escuro;
- mantém estabilidade visual em larguras mobile representativas.

## Ambiente de referencia

Registrar durante a implementacao:

```text
Flutter:
Dart:
Plataforma:
Dispositivo ou navegador:
Escala de texto:
Tema:
Modo de dados: fixture local / outro fallback aprovado
```

## Preparacao dos testes visuais

O harness de golden deve:

- carregar Instrument Sans pelos assets reais;
- fixar `Locale('pt', 'BR')` quando aplicavel;
- fixar tamanho em `390x844`;
- controlar `MediaQuery` e escala de texto;
- desativar ou concluir animacoes antes da captura;
- usar dados deterministas;
- nao depender de rede, relogio real ou plataforma.

## Testes automatizados

### T-001 - Tipografia empacotada

**Tipo:** unidade/configuracao

**Resultado esperado:**

- `pubspec.yaml` declara Instrument Sans;
- pesos 400, 500, 600 e 700 existem nos assets;
- arquivos usam os nomes e diretorio normativos;
- declaracao do `pubspec.yaml` corresponde ao snippet da spec;
- `AppTypography` usa a familia;
- estilos nao solicitam pesos ausentes;
- a licenca esta presente no repositorio.

### T-002 - Iconografia encapsulada

**Tipo:** arquitetura

**Resultado esperado:**

- `lucide_icons_flutter` esta declarado;
- apenas `app_icons.dart` importa `LucideIcons`;
- widgets e features consomem `AppIcons`;
- aliases globais continuam semanticos;
- todos os aliases seguem a tabela normativa;
- categorias Protecao, Eletrica e Acessorios usam os aliases definidos;
- categoria nula ou desconhecida usa `AppIcons.productFallback`.

### T-003 - Tokens escuros normativos

**Tipo:** unidade/tema

**Resultado esperado:**

- background, superficies, texto, borda, primary e status correspondem aos
  valores hex documentados;
- containers de success, warning, danger e restricted usam seus pares;
- tema escuro nao e derivado automaticamente do tema claro;
- alteracao de token exige atualizacao explicita do golden.

### T-004 - Tokens claros e nomenclatura de erro

**Tipo:** unidade/tema/arquitetura

**Resultado esperado:**

- containers claros correspondem aos valores HSL e hex documentados;
- cada container usa seu foreground dedicado;
- `AppColors.danger*` permanece como origem dos valores da marca;
- `ColorScheme.error`, `errorContainer` e `onErrorContainer` recebem os valores
  `danger*` correspondentes;
- widgets usam `ColorScheme.error*`, nao `AppColors.danger*` diretamente;
- `AppStatusTone.error` e `AppIcons.error` permanecem aliases semanticos;
- `AppColorTokens` nao declara propriedades customizadas de danger/error.

### T-005 - Bottom navigation propria

**Tipo:** widget

**Resultado esperado:**

- `AppBottomNavigation` nao contem `NavigationBar`;
- os tres destinos atuais sao exibidos;
- item selecionado possui indicador, icone e label;
- toque chama `onSelect` com o indice correto;
- cada destino possui alvo minimo de 48 por 48;
- semantica informa o destino selecionado;
- escala de texto aumentada nao causa overflow;
- com inset inferior de 34, a altura total cresce exatamente 34;
- com inset inferior zero, a altura total usa apenas a altura visual;
- o inset fica abaixo dos destinos e nao reduz os alvos;
- nao existe padding inferior duplicado.

### T-006 - Shell e safe areas

**Tipo:** widget

**Resultado esperado:**

- blur permanece restrito a barra inferior;
- conteudo pode rolar sem ficar oculto;
- notch, status bar e area inferior sao respeitados;
- troca de branch preserva navegacao esperada;
- nenhum destino secundario invade a navegacao primaria.

### T-007 - OperationalTopBar

**Tipo:** widget

**Resultado esperado:**

- titulo e subtitulo possuem hierarquia clara;
- leading e acoes opcionais funcionam;
- ausencia de subtitulo nao deixa espaco residual;
- titulo aceita ate duas linhas;
- acoes passam para linha propria com texto aumentado;
- texto excedente do titulo usa ellipsis apenas apos a segunda linha;
- nao existem metricas, tags ou circulos decorativos.

### T-008 - DashboardHero

**Tipo:** widget

**Resultado esperado:**

- hero usa superficie navy e texto com contraste adequado;
- aparece apenas no dashboard;
- exibe no maximo dois metadados secundarios;
- nao renderiza CTA sem comportamento;
- nao renderiza grafico ou serie temporal.

### T-009 - KpiCard

**Tipo:** widget

**Cenarios:**

- neutro;
- positivo;
- warning;
- critico;
- restrito.

**Resultado esperado:**

- valor domina a composicao;
- label e subtitulo permanecem legiveis;
- card cresce verticalmente com texto aumentado;
- valor financeiro ou quantidade nunca usa ellipsis;
- variante critica usa texto e tom, nao apenas cor;
- variante restrita nao apresenta erro tecnico;
- card nao se transforma em mini hero.

### T-010 - ProductCard

**Tipo:** widget

**Cenarios:**

- estoque saudavel;
- estoque baixo;
- sem saldo;
- preco visivel;
- preco restrito;
- categoria conhecida;
- categoria desconhecida.

**Resultado esperado:**

- nome, SKU, quantidade e status principal sao visiveis;
- categoria conhecida usa alias adequado;
- categoria desconhecida usa fallback;
- placeholder possui 48 por 48, raio 12 e icone outline;
- nenhuma inicial, avatar ou imagem remota e renderizada;
- existe no maximo um status principal;
- nome aceita duas linhas e SKU usa uma linha com ellipsis;
- com text scaler 2.0, quantidade e status passam para bloco inferior;
- quantidade e preco nunca sao truncados;
- `price = null` nao gera falha;
- o widget nao acessa repositorio nem carrega imagem.

### T-011 - Startup

**Tipo:** widget

**Resultado esperado:**

- marca e mensagem aparecem;
- progresso e erro permanecem distintos;
- retry continua funcional;
- nao existe simulacao de login;
- composicao funciona com texto aumentado.

### T-012 - Dashboard por estado

**Tipo:** widget

**Cenarios:**

- loading;
- ready;
- refreshing;
- empty;
- offline;
- restricted;
- failure.

**Resultado esperado:**

- estados continuam semanticamente distintos;
- refresh preserva conteudo existente;
- restricao financeira nao vira erro;
- alertas e movimentos mantem leitura compacta;
- nao existe novo grafico.

### T-013 - Catalogo por estado

**Tipo:** widget

**Cenarios:**

- loading;
- ready;
- empty por filtro;
- feature desativada;
- permissao ausente;
- offline;
- failure.

**Resultado esperado:**

- busca e filtros permanecem funcionais;
- cards seguem a composicao compacta;
- feature e permissao usam mensagens diferentes;
- dados locais permanecem visiveis quando aplicavel;
- nao existe FAB sem acao.

### T-014 - Mais e contexto

**Tipo:** widget

**Resultado esperado:**

- telas usam `OperationalTopBar`;
- destinos estao agrupados;
- ativo, futuro e externo sao distinguiveis;
- tenant, usuario, features e permissoes permanecem legiveis;
- autorizacao remota continua explicada;
- nao existem metricas ficticias.

### T-015 - Estados compartilhados

**Tipo:** widget

**Resultado esperado:**

- vazio, falha, offline e restricao possuem texto e semantica;
- cor nao e o unico sinal;
- acoes de retry continuam externas ao componente;
- layouts nao acumulam cards aninhados desnecessarios.

### T-016 - Reflow e text scaling

**Tipo:** widget/acessibilidade

**Cenarios:**

- `textScaler` 1.0;
- `textScaler` 1.3;
- `textScaler` 2.0.

**Resultado esperado:**

- nenhum `RenderFlex overflow` ocorre;
- layouts crescem verticalmente antes de truncar informacao essencial;
- titulos usam no maximo duas linhas;
- SKU, datas e labels curtas usam uma linha com ellipsis;
- valores e quantidades permanecem completos;
- trailing migra para linha inferior quando necessario;
- badges usam `Wrap`;
- nenhum conteudo informativo usa `FittedBox`.

### T-017 - Fronteiras arquiteturais

**Tipo:** arquitetura

**Resultado esperado:**

- alteracoes visuais nao introduzem acesso a Dio ou Drift em presentation;
- application e domain permanecem sem Flutter;
- nenhum campo ou endpoint e inventado;
- nenhum estado visual de outbox e antecipado;
- iconografia e fonte nao vazam para regras de negocio.

## Golden tests

### G-001 - Shell claro

- tamanho: `390x844`;
- tema claro;
- destino Painel selecionado.

### G-002 - Shell escuro

- tamanho: `390x844`;
- tema escuro;
- destino Produtos selecionado.

### G-003 - Dashboard claro

- estado ready;
- KPIs neutro e critico;
- alertas e movimentos presentes.

### G-004 - Dashboard escuro

- mesmo conteudo determinista;
- contraste do hero e superficies validado.

### G-005 - Catalogo claro

- produtos com estoque saudavel, baixo e zerado;
- um produto com preco restrito.

### G-006 - Catalogo escuro

- mesmo conteudo determinista;
- bordas, status e metadata legiveis.

Golden tests nao substituem aprovacao visual humana.

## Verificacoes estaticas

Executar durante a implementacao:

```text
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Tambem verificar:

```text
rg "LucideIcons" lib
rg "NavigationBar|BottomNavigationBar" lib/shared lib/features
rg "InstrumentSans-" pubspec.yaml
```

Resultados esperados:

- `LucideIcons` aparece apenas em `app_icons.dart`;
- a shell nao usa barras Material prontas;
- os quatro arquivos de fonte estao declarados;
- analise e testes passam sem avisos ou erros.

## Validacao visual manual

Validar:

| Cenario | Tamanhos |
| --- | --- |
| Tema claro | `360x800`, `390x844`, `412x915` |
| Tema escuro | `360x800`, `390x844`, `412x915` |
| Texto aumentado | ao menos `390x844` |

Checklist:

- identidade Arara-Gastos reconhecivel;
- dashboard continua sendo a tela mais rica;
- demais telas sao compactas e sobrias;
- navegacao nao parece `NavigationBar` padrao;
- cards nao parecem templates Material;
- nenhum texto, badge ou acao fica cortado;
- ultimo item permanece acessivel acima da barra inferior;
- status continuam compreensiveis sem depender apenas de cor;
- nao aparecem nomes ou marcas das referencias;
- nao existem graficos, FABs ou CTAs sem comportamento real.

## Criterio de aprovacao

A validacao tecnica so e concluida quando:

- verificacoes estaticas passam;
- testes de widget passam;
- golden tests passam;
- validacao manual cobre os tamanhos e temas definidos;
- nenhuma regra de negocio ou contrato foi alterado;
- o usuario aprova visualmente a identidade.
