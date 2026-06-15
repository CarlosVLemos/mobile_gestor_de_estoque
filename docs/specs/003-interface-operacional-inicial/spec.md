# Spec 003 - Interface Operacional Inicial

## Status

Planejada em 12 de junho de 2026.

## Classificacao

- interface;
- feature;
- arquitetura de apresentacao;
- componentes reutilizaveis;
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

As imagens em `docs/specs/Img/` sao referencias de composicao e densidade
visual. Elas nao substituem contratos, decisoes aceitas ou regras de camada.

## Problema

O projeto ja possui:

- fundacao de app, router e tema global;
- contratos reais documentados para `me`, `dashboard` e `products`;
- direcao visual e estados de interface definidos.

O que ainda nao existe e a interface operacional inicial organizada por feature
e camada, pronta para receber dados reais sem acoplar pagina, mock, DTO,
permissao e navegacao em um unico lugar.

Hoje ainda nao temos:

- shell operacional com navegacao primaria;
- paginas de dashboard, catalogo e contexto operacional;
- componentes compartilhados e documentados para cards, estados e listas;
- contratos de apresentacao alinhados aos payloads existentes;
- estrategia explicita para usar dados de exemplo sem fingir que o login mobile
  ja existe.

Sem essa spec, a primeira entrega de UI corre o risco de:

- antecipar login inexistente;
- acoplar widgets a payloads crus;
- espalhar componentes duplicados entre features;
- criar placeholders que parecem prontos para producao sem estarem protegidos.

## Objetivo

Criar a primeira interface operacional navegavel do app mobile com base apenas
no que ja existe de forma comprovada:

- shell operacional com bottom navigation;
- dashboard resumido;
- catalogo de produtos;
- tela de contexto operacional/perfil;
- tela "Mais" como agregador de destinos secundarios;
- componentes reutilizaveis em `shared/widgets/`;
- documentacao desses componentes;
- assinaturas e comentarios que preparem a futura protecao de rotas quando o
  login mobile estiver pronto.

## Resultado esperado

Ao final da implementacao desta spec, o aplicativo deve conseguir:

- sair da tela transitoria e abrir uma shell operacional navegavel;
- renderizar dashboard, catalogo e contexto operacional usando fixtures
  explicitas ou dados locais controlados;
- refletir feature flags e permissoes vindas do contrato de `me`;
- mostrar estados de `loading`, `ready`, `empty`, `restricted`, `offline`,
  `refreshing` e `failure` quando aplicaveis;
- reaproveitar componentes compartilhados sem duplicar visual entre features;
- deixar claro no codigo que as rotas reais serao protegidas quando o contrato
  de autenticacao mobile existir.

## Decisoes aplicaveis

| Decisao | Aplicacao nesta spec |
| --- | --- |
| MOB-001 | A UI deve ser preparada para ler de repositorios, nao da rede |
| MOB-002 | Codigo organizado por feature e camada |
| MOB-003 | `application` nao conhece Dio, Drift ou JSON |
| MOB-004 | Controllers e injecao via Riverpod |
| MOB-007 | Navegacao via `go_router` |
| MOB-010 | Estoque, permissao e disponibilidade final continuam soberanos no backend |
| MOB-014 | Interface preserva identidade azul operacional |
| MOB-015 | Permissao orienta UX, nao substitui autorizacao remota |
| MOB-016 | Contrato planejado nao sera tratado como implementado |
| UI-001 | Navegacao primaria usa bottom navigation |
| UI-002 | Estruturas densas viram cards e listas mobile |
| UI-003 | Dashboard preserva hero escuro |
| UI-004 | Badges mantem semantica consistente |
| UI-005 | Dados visiveis permanecem durante refresh |
| UI-006 | `price = null` vira estado restrito valido |
| UI-007 | Estados de conflito e sync exigem apresentacao explicita |

Nao ha mudanca de decisao aceita nesta spec.

## Contratos consumidos

### Contratos existentes

Esta spec pode consumir somente contratos marcados como existentes em
`03-endpoints-mobile.md`:

- `GET /api/mobile/me`;
- `GET /api/mobile/dashboard`;
- `GET /api/mobile/products`.

### Contratos nao existentes

Nao entram nesta spec como fluxo implementado:

- `POST /api/mobile/login`;
- `POST /api/mobile/logout`;
- qualquer endpoint de relatorio mobile;
- qualquer endpoint de venda offline;
- confirmacao de intencao de venda.

### Regra obrigatoria

Como o login mobile por token ainda nao existe, a implementacao nao deve:

- inventar tela de login funcional;
- fingir autenticacao real com token persistido;
- chamar endpoints protegidos em producao sem uma camada de autenticacao pronta;
- tratar fixture como se fosse resposta validada do servidor.

## Estrategia de dados para esta fase

### Fonte de verdade da UI nesta entrega

A interface sera implementada por repositorios e contratos de dominio desde o
primeiro dia, mas a fonte concreta nesta spec pode ser fixture local ou fake
repository controlado.

Regras:

- `presentation` conversa com controller;
- controller conversa com use case;
- use case conversa com repository;
- repository esconde se a origem e fixture, local ou remota;
- a pagina nunca conhece o formato de fixture nem DTO remoto.

### Fixtures explicitas

Enquanto o fluxo de autenticacao mobile nao existir, os dados operacionais
usados na interface devem vir de fixtures declaradas como tal.

Formato permitido:

- classes ou arquivos de fixture em `data/local/`;
- repositorios fake em `data/repositories/`;
- comentarios objetivos indicando que o endpoint real depende de autenticacao.

Formato nao permitido:

- fixture diretamente no widget;
- `Map<String, dynamic>` solto dentro da pagina;
- usar DTO remoto como estado de widget;
- nomear fixture como se fosse cliente HTTP real.

### Assinaturas futuras

As interfaces remotas podem ser preparadas em `data/remote/`, mas devem conter
comentarios curtos como:

```dart
// TODO(auth): esta rota depende do fluxo mobile de autenticacao.
// Quando o contrato de login existir, proteger a chamada por sessao valida.
```

Esses comentarios existem para evitar ambiguidade, nao para substituir spec de
autenticacao.

## Escopo funcional

### 1. Shell operacional

Criar shell autenticada em termos visuais, mas ainda sem autenticacao real.

Responsabilidades:

- hospedar bottom navigation;
- exibir destinos primarios disponiveis;
- reagir a feature flags e permissoes do contexto operacional;
- oferecer um ponto central para banners globais, como sessao futura,
  indisponibilidade e estado offline.

Destinos minimos desta spec:

- `Painel`;
- `Produtos`;
- `Mais`.

Destinos secundarios desta spec:

- `Contexto operacional`;
- entradas visuais para modulos futuros sem navegacao funcional definitiva,
  desde que marcadas como indisponiveis ou fora de escopo.

Nao criar nesta spec:

- shell admin;
- vendas funcionais;
- estoque funcional;
- autenticacao real;
- redirecionamento final por sessao.

### 2. Dashboard mobile

Consumir visualmente os conceitos de:

- KPIs resumidos;
- alertas de estoque;
- movimentos recentes;
- CTA para abrir o dashboard web quando necessario;
- estado restrito para metricas financeiras.

A tela nao precisa consumir todos os blocos do payload real na primeira entrega.
Ela deve priorizar os blocos descritos como importantes na documentacao.

### 3. Catalogo de produtos

Consumir visualmente:

- lista de produtos em cards;
- busca;
- filtros minimos quando existirem dados para isso;
- badge de estoque;
- disponibilidade para venda como informacao de UX;
- preco opcional;
- imagem opcional com placeholder;
- estado vazio e filtros sem resultado.

Regras:

- item sem estoque continua listado;
- `price = null` vira restricao visual, nao erro;
- catalogo respeita feature `catalog` e permissao de visualizacao;
- vender ou editar produto fica fora desta spec.

### 4. Contexto operacional

Criar tela de contexto baseada em `GET /api/mobile/me` com:

- usuario;
- tenant atual;
- features ativas;
- mapa relevante de permissoes;
- leitura clara do que esta habilitado ou restrito no app.

Essa tela e funcionalmente importante porque organiza a navegacao e explica ao
usuario por que certos modulos aparecem, somem ou ficam restritos.

### 5. Tela "Mais"

Centralizar:

- link para contexto operacional;
- entradas para modulos futuros;
- configuracoes visuais ou itens informativos que nao sejam destino primario.

Ela nao deve virar deposito de placeholders sem criterio.

## Componentes reutilizaveis

Os componentes compartilhados desta spec devem ficar em `lib/shared/widgets/`
quando:

- forem usados por mais de uma feature; ou
- representarem um padrao visual operacional global.

Se um widget for exclusivo de uma unica feature, ele deve ficar em
`features/<feature>/presentation/widgets/`.

### Catalogo inicial de componentes compartilhados

Minimo recomendado:

- `AppShellScaffold`;
- `AppBottomNavigation`;
- `SectionHeader`;
- `StatusBadge`;
- `EmptyStateCard`;
- `FailureStateCard`;
- `OfflineStateBanner`;
- `RestrictedInfoCard`;
- `KpiCard`;
- `ProductCard`;
- `MovementListItem`;
- `TenantContextCard`;
- `FeaturePill` ou equivalente;
- `PermissionListTile` ou equivalente.

### Regras para componentes compartilhados

Eles devem:

- receber dados ja preparados para apresentacao;
- evitar regra de negocio;
- depender apenas de tema, formatadores e modelos visuais simples;
- ser testaveis por widget;
- expor API pequena e sem parametros redundantes;
- permitir variacoes sem duplicar arquivos.

Eles nao devem:

- chamar repositorios;
- conhecer `BuildContext` fora do ciclo normal de render;
- disparar HTTP;
- carregar fixture por conta propria;
- decidir permissao;
- esconder estados importantes.

### Documentacao obrigatoria dos componentes

Cada componente criado em `shared/widgets/` nesta spec deve ser documentado em
`docs/specs/003-interface-operacional-inicial/components.md` com:

- objetivo;
- local de uso;
- API publica;
- variacoes visuais;
- estados suportados;
- limites de uso;
- exemplo curto.

## Arquitetura alvo

### App e rotas

Estrutura minima prevista:

```text
lib/app/router/
  app_routes.dart
  app_router.dart

lib/features/dashboard/
lib/features/catalog/
lib/features/settings/
```

O modulo `settings` pode hospedar `Mais` e `Contexto operacional` se essa for a
organizacao mais clara para o estado atual do produto. O importante e manter a
fronteira entre pagina, controller, use case, repositorio e fonte de dados.

### Estrutura por feature

Cada feature envolvida deve seguir o fluxo:

```text
Page -> Controller -> UseCase -> Repository -> Local fixture / Remote signature
```

Estados visuais nao devem nascer em DTOs. DTOs, quando existirem, devem ser
convertidos antes de chegar a `presentation`.

### Modelos visuais

Se for necessario criar modelos orientados a UI, eles devem ficar em
`presentation/state/` ou estruturas equivalentes da feature, sem carregar JSON,
HTTP ou regras de persistencia.

### Formatares e utilitarios

Formatacao compartilhada de numero, data e estoque deve ir para
`lib/shared/formatters/` quando houver reuso entre features.

Validadores de filtros globais podem morar em `lib/shared/validators/` se forem
reaproveitaveis. Nada disso deve nascer dentro de um widget isolado.

## Navegacao e protecao futura

### Rotas desta spec

Rotas minimas sugeridas:

- `/` para startup;
- `/app/dashboard`;
- `/app/products`;
- `/app/more`;
- `/app/context`.

### Protecao de rotas

As rotas operacionais devem conter comentarios claros de que serao protegidas
quando o login mobile existir.

Exemplo esperado:

```dart
// TODO(auth): proteger a shell operacional quando o fluxo mobile de login
// estiver disponivel. Ate la, esta rota usa bootstrap local controlado.
```

O comentario e obrigatorio nos pontos centrais da navegacao, mas a protecao
real fica fora desta spec.

## Estados de interface

### Startup

Deve considerar:

- `loading`;
- `ready`;
- `failure`.

Ela nao deve fingir validacao de token real.

### Dashboard

Deve considerar:

- `initial`;
- `loading`;
- `ready`;
- `refreshing`;
- `empty`;
- `restricted`;
- `offline`;
- `failure`.

### Catalogo

Deve considerar:

- `initial`;
- `loading`;
- `ready`;
- `refreshing`;
- `empty`;
- `restricted`;
- `offline`;
- `failure`.

`filtros sem resultado` pode ser modelado como variante de `empty` com copy
especifica.

### Contexto operacional

Deve considerar:

- `loading`;
- `ready`;
- `restricted`;
- `failure`.

## Regras de UX e negocio

- `403` por feature desativada deve virar estado de modulo indisponivel;
- `403` por permissao deve virar estado restrito;
- `401` nao deve virar login funcional nesta spec; deve gerar trilha clara para
  a futura spec de autenticacao;
- `422` deve orientar ajuste de filtro;
- `429` deve virar mensagem acionavel e nao erro generico;
- `price = null` deve exibir restricao valida;
- disponibilidade para venda e UX, nao autorizacao final;
- tenant e permissoes devem ser apresentados como contexto operacional, nao
  como detalhe tecnico escondido.

## Dependencias

Esta spec nao exige adicionar novas bibliotecas de UI alem das ja presentes para
fundacao e navegacao.

Nesta etapa, o trabalho operacional minimo e:

- sincronizar as dependencias atuais com `flutter pub get`;
- manter `flutter_riverpod` e `go_router` como base da implementacao.

Dependencias futuras de dados, serializacao, rede e persistencia devem entrar
na spec apropriada da camada correspondente ou na implementacao desta spec
somente se realmente forem usadas pelo codigo entregue.

## Fora de escopo

- login funcional;
- refresh token;
- logout real;
- chamadas autenticadas de producao;
- cliente Dio definitivo;
- banco Drift definitivo;
- sincronizacao incremental real;
- venda offline;
- estoque funcional;
- detalhe completo de produto;
- relatorios mobile;
- area admin;
- permissao manual inventada localmente;
- qualquer endpoint nao documentado como existente.

## Riscos

- acoplar paginas a fixtures;
- confundir restricao com erro;
- tornar `Mais` um deposito de placeholders sem uso;
- duplicar componentes entre dashboard e catalogo;
- criar shell com rotas que parecam protegidas, mas nao estejam;
- espalhar comentarios de auth sem um ponto central claro;
- antecipar DTOs e clientes remotos sem necessidade;
- usar mocks que contradigam o contrato documentado.

## Criterios de aceite

- existe uma spec formal para a interface operacional inicial;
- o escopo se limita a contratos existentes ou fixtures explicitas;
- login funcional permanece fora de escopo;
- shell, dashboard, catalogo, contexto e `Mais` possuem fronteiras claras;
- componentes compartilhados previstos estao listados e documentados;
- a documentacao dos componentes tem local definido;
- a futura protecao de rotas esta sinalizada por comentarios objetivos;
- `shared/widgets/` fica reservado a componentes realmente reutilizaveis;
- `presentation` nao acessa rede ou persistencia;
- estados de `restricted`, `offline`, `empty`, `refreshing` e `failure` foram
  previstos nas telas aplicaveis;
- `price = null` foi tratado como restricao valida;
- nenhuma rota, campo ou endpoint inexistente foi inventado;
- dependencias atuais foram sincronizadas com sucesso ou a limitacao foi
  registrada.
