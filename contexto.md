# Contexto do Projeto

Este arquivo serve como mapa rapido do repositorio. A ideia e facilitar a
movimentacao pelo projeto sem precisar reabrir a arvore inteira toda vez.

Use junto com `tree.txt`:

- `tree.txt` = indice bruto da estrutura de pastas e arquivos.
- `contexto.md` = explicacao do papel de cada area, do estado atual e dos
  pontos de atencao.

## Estado Atual

O projeto ja tem uma base Flutter funcional com shell operacional, tema global,
navegacao e organizacao inicial por feature e camada.

Hoje o que esta mais materializado no codigo:

- app base em `lib/app` com `MaterialApp.router`, `go_router` e bootstrap local;
- tema claro/escuro com Instrument Sans local, tokens e toggle de tema;
- shell operacional com quatro destinos principais:
  `Painel`, `Produtos`, `Vendas` e `Mais`;
- drawer lateral operacional compartilhado;
- dashboard refinado com indicadores, meta operacional, nivel de estoque,
  alertas e movimentos recentes;
- catalogo operacional ainda baseado em fixture, mas integrado a shell atual;
- area `Mais` e contexto operacional navegaveis;
- tela inicial de vendas ja criada com fluxo local em memoria para selecionar
  cliente, montar carrinho e criar rascunhos nao persistidos da sessao;
- testes de widget, arquitetura e goldens em `test/`.

O que ainda nao existe de verdade no app:

- autenticacao mobile por token;
- cliente Dio materializado;
- banco Drift materializado;
- armazenamento seguro para sessao;
- sincronizacao incremental real;
- outbox persistente real;
- integracao remota de vendas;
- isolamento definitivo de dados por usuario/tenant no banco local.

Resumo pratico:

- a fundacao arquitetural e visual existe;
- a shell atual ja expoe `Painel`, `Produtos`, `Vendas` e `Mais`;
- `dashboard`, `catalog` e `sales` ainda dependem de fixtures ou estado local
  em memoria;
- as specs `007`, `008`, `008b`, `009a`, `009b`, `009c` e `010` foram abertas
  como documentacao, nao como implementacao de infraestrutura;
- autenticacao, Dio, Drift, sync e outbox continuam apenas como arquitetura
  aceita, nao como codigo pronto.

## Situacao Git Atual

Fotografia em 18 de junho de 2026:

- branch `main`, alinhada a `origin/main`;
- o working tree tem alteracoes nao commitadas em codigo, testes, goldens e
  documentacao;
- existem novas pastas de spec em `docs/specs/006-*`, `007-*`, `008-*`,
  `008b-*`, `009a-*`, `009b-*`, `009c-*` e `010-*`;
- existem arquivos novos em `.agents/` com orientacao local do repositorio;
- a feature `sales` deixou de ser apenas estrutura vazia e agora possui
  entidades, repositorio fixture, controllers, pagina e testes;
- o contexto antigo de 15 de junho ficou defasado e nao deve mais ser usado
  para decidir staging ou fechamento de commit.

Leitura importante para o momento:

- ha mudancas misturadas de documentacao, shell/UI e vendas locais;
- antes de publicar, vale separar commits por responsabilidade;
- arquivos em `test/goldens/failures/` sao artefatos de falha e pedem revisao
  explicita antes de entrarem em commit.

## Leitura Canonica

Pelo `AGENTS.md`, o ponto de entrada oficial continua sendo:

- `para mobile/00-contexto-operacional.md`

Leia esse arquivo antes de alterar qualquer coisa. Ele direciona quais outros
documentos consultar conforme o tipo de tarefa.

Documentos mais importantes em `para mobile/`:

- `00-contexto-operacional.md`: visao geral canonica e porta de entrada.
- `02-definicoes-de-interface.md`: regras e padroes de interface.
- `04-regras-e-necessidades-mobile.md`: regras de negocio, permissoes e
  offline.
- `05-arquitetura-mobile.md`: organizacao por camadas e responsabilidades.
- `06-registro-decisoes.md`: decisoes aceitas que nao devem ser quebradas em
  silencio.
- `08-processo-de-trabalho.md`: processo de execucao de spec e handoff.
- `designmobile.md`: referencia visual para trabalho de interface mais amplo.

## Como Usar o `tree.txt`

Use `tree.txt` como indice estrutural quando quiser:

- localizar um arquivo pelo nome;
- ver se uma feature ja existe;
- entender rapidamente a hierarquia de uma pasta;
- navegar sem depender de busca textual no editor.

Sugestao de uso:

1. abra `contexto.md` para entender a area;
2. use `tree.txt` para achar o caminho exato;
3. abra o arquivo alvo ja com contexto do que ele faz.

## Mapa da Raiz

Arquivos e pastas mais importantes na raiz:

- `AGENTS.md`: instrucoes de trabalho do projeto.
- `README.md`: documentacao geral do repositorio.
- `pubspec.yaml`: dependencias, assets e configuracao Flutter.
- `analysis_options.yaml`: regras de analise estaticas.
- `tree.txt`: arvore do projeto.
- `contexto.md`: este guia de navegacao.
- `.agents/`: anotacoes locais de contexto e roteamento para agentes.
- `docs/`: specs, imagens e material de apoio de implementacao.
- `para mobile/`: documentacao operacional canonica.
- `lib/`: codigo principal do app.
- `test/`: testes automatizados.
- `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/`: plataformas.

## Onde Fica Cada Coisa em `lib/`

### `lib/app`

Nucleo de inicializacao do aplicativo.

Aqui ficam itens como:

- `arara_app.dart`: composicao principal do app;
- `router/`: rotas e navegacao;
- `shell/`: perfil operacional local usado pelo bootstrap atual;
- `theme/`: tema global, tokens, icones e controle local de tema;
- `startup/`: bootstrap e estado inicial;
- `localization/`: recursos de localizacao.

Va para `lib/app` quando quiser mexer em:

- tema global;
- roteamento;
- composicao da shell;
- inicializacao da aplicacao;
- comportamento geral compartilhado entre features.

### `lib/core`

Infraestrutura e contratos de apoio.

Hoje essa area ainda e enxuta e concentra utilitarios e configuracoes que nao
pertencem a uma feature especifica.

Exemplo observado:

- `config/fixture_access_profile.dart`

Va para `lib/core` quando quiser entender:

- configuracoes compartilhadas;
- base tecnica comum;
- fixtures e apoio transversal.

### `lib/shared`

Componentes reutilizaveis da interface.

Aqui fica boa parte da base visual compartilhada, incluindo shell, estados e
cartoes operacionais.

Exemplos de widgets presentes:

- `operational_top_bar.dart`
- `app_shell_scaffold.dart`
- `app_bottom_navigation.dart`
- `app_drawer.dart`
- `tenant_context_card.dart`
- `product_card.dart`
- `status_badge.dart`
- `offline_state_banner.dart`
- `restricted_info_card.dart`

Va para `lib/shared` quando quiser melhorar:

- shell e navegacao;
- header superior das telas;
- cartoes, badges e elementos visuais repetidos;
- estados vazios, offline, restritos e de falha.

### `lib/features`

Organizacao principal por dominio funcional.

Cada feature tende a seguir a separacao por camadas, com pastas como
`presentation`, `application`, `domain` e `data` quando ja implementadas.

#### Features com implementacao mais concreta hoje

- `dashboard`
- `catalog`
- `settings`
- `sales`

`sales` ainda nao representa venda offline real, mas ja deixou de ser apenas
estrutura vazia.

#### Features ainda em estrutura parcial ou base

- `auth`
- `clients`
- `inventory`
- `reports`

## Onde Melhorar a Interface Mais Rapido

Os lugares mais provaveis para atuar primeiro sao:

- `lib/shared/widgets/operational_top_bar.dart`
- `lib/shared/widgets/app_drawer.dart`
- `lib/shared/widgets/app_shell_scaffold.dart`
- `lib/shared/widgets/app_bottom_navigation.dart`
- paginas em `lib/features/dashboard/presentation/pages/`
- paginas em `lib/features/catalog/presentation/pages/`
- paginas em `lib/features/sales/presentation/pages/`
- paginas em `lib/features/settings/presentation/pages/`

Se a ideia for evoluir a aplicacao com mais consistencia, a ordem mais
produtiva costuma ser:

1. validar manualmente shell, dashboard, catalogo e vendas em larguras mobile;
2. revisar goldens e artefatos de falha antes de publicar;
3. refinar componentes compartilhados antes de ajustes isolados por tela;
4. manter tokens e aliases centralizados em `lib/app/theme/`.

## `docs/` e Specs

Em `docs/specs/` existe o historico de execucao por etapas. Hoje aparecem pelo
menos estas frentes:

- `001-fundacao-arquitetural`
- `002-tema-global`
- `003-interface-operacional-inicial`
- `004-revitalizacao-estetica`
- `005-identidade-visual-operacional`
- `006-refino-painel-e-shell`
- `007-core-rede-erros-resultado`
- `008-sessao-e-autenticacao`
- `008b-isolamento-contexto-local`
- `009a-drift-schema-inicial`
- `009b-sync-engine-base`
- `009c-sync-leitura-catalogo-painel`
- `010-outbox-vendas`

Leitura pratica:

- `001` a `005`: historico da base arquitetural e visual ja materializada;
- `006`: documenta refino de shell e painel, mas o working tree ja contem
  implementacao parcial relacionada;
- `007` a `010`: backlog/specs documentais para a proxima fase de
  infraestrutura.

## `test/`

Os testes ajudam a localizar o que ja tem cobertura e quais partes do app sao
consideradas mais estaveis.

Pelo que esta presente hoje:

- `test/app/`: teste do app principal;
- `test/architecture/`: validacoes de organizacao e contratos;
- `test/features/catalog/`: testes da tela de catalogo;
- `test/features/dashboard/`: testes da tela de dashboard;
- `test/features/sales/`: testes da tela de vendas;
- `test/features/settings/`: testes da area operacional de settings;
- `test/theme/`: testes do tema;
- `test/shared/widgets/`: comportamento e acessibilidade dos componentes;
- `test/goldens/`: referencias visuais de shell, dashboard e catalogo.

Os goldens carregam Instrument Sans e Lucide obrigatoriamente. Alteracoes de
layout devem executar os testes correspondentes e passar por inspecao visual,
nao apenas regenerar imagens.

## Atalhos de Navegacao

Se voce quer ir direto ao ponto:

- entender o projeto antes de tudo: `para mobile/00-contexto-operacional.md`
- encontrar qualquer caminho rapidamente: `tree.txt`
- mexer no visual global: `lib/app/theme/`
- mexer na shell: `lib/shared/widgets/app_shell_scaffold.dart`
- mexer no topo operacional: `lib/shared/widgets/operational_top_bar.dart`
- mexer na tela inicial: `lib/features/dashboard/`
- mexer em produtos/catalogo: `lib/features/catalog/`
- mexer na tela local de vendas: `lib/features/sales/`
- mexer em mais opcoes e contexto operacional: `lib/features/settings/`
- revisar o historico de implementacao: `docs/specs/`
- entender cobertura e impactos: `test/`

## Leitura Recomendada por Cenario

Se a tarefa for visual:

1. `para mobile/00-contexto-operacional.md`
2. `para mobile/02-definicoes-de-interface.md`
3. `para mobile/designmobile.md`
4. arquivos em `lib/shared/widgets/`
5. paginas da feature afetada

Se a tarefa for arquitetural:

1. `para mobile/00-contexto-operacional.md`
2. `para mobile/05-arquitetura-mobile.md`
3. `para mobile/06-registro-decisoes.md`
4. `lib/app/`, `lib/core/` e `lib/features/`

Se a tarefa for entender o estado atual da interface:

1. `docs/specs/005-identidade-visual-operacional/`
2. `docs/specs/006-refino-painel-e-shell/`
3. `lib/shared/widgets/`
4. `lib/features/dashboard/`
5. `lib/features/catalog/`
6. `lib/features/sales/`
7. `lib/features/settings/`

## Observacao Final

Este arquivo nao substitui a documentacao oficial do projeto. Ele funciona como
guia de orientacao rapida para reduzir atrito na navegacao entre pastas, specs
e features, mas as decisoes canonicas continuam em `para mobile/`.
