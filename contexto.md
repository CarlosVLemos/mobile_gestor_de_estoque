# Contexto do Projeto

Este arquivo serve como mapa rapido do repositorio. A ideia e facilitar a
movimentacao pelo projeto sem precisar reabrir a arvore inteira toda vez.

Use junto com `tree.txt`:

- `tree.txt` = indice bruto da estrutura de pastas e arquivos.
- `contexto.md` = explicacao do papel de cada area e do estado atual.

## Estado Atual

O projeto ja tem uma base Flutter funcional com navegacao, tema global e uma
interface operacional montada por feature.

Hoje o que ja esta mais materializado:

- app base em `lib/app`;
- componentes compartilhados em `lib/shared`;
- telas operacionais principais em `lib/features/dashboard`,
  `lib/features/catalog` e `lib/features/settings`;
- tema claro e escuro com Instrument Sans local;
- iconografia Lucide encapsulada por `AppIcons`;
- shell com navegacao inferior propria e suporte a Safe Area;
- testes de arquitetura, tema, widgets, paginas e goldens em `test/`;
- especificacoes e historico de implementacao em `docs/specs/`.

O que ainda esta em fase de fixture, planejamento ou estrutura:

- autenticacao real;
- integracoes remotas completas;
- banco Drift e persistencia offline definitiva;
- cliente Dio e sincronizacao incremental;
- armazenamento seguro e sessao remota;
- outbox para operacoes offline reais;
- fluxo operacional completo de vendas, estoque e sincronizacao;
- varias features com estrutura criada, mas ainda pouco preenchidas.

Resumo pratico:

- a fundacao arquitetural e visual ja existe;
- dashboard, catalogo, Mais e contexto operacional estao navegaveis;
- dashboard e catalogo ainda leem fixtures por repositorios;
- a Spec 005 esta implementada no working tree e validada tecnicamente;
- validacao manual e aprovacao visual do usuario continuam pendentes.

## Situacao Git Atual

Fotografia em 15 de junho de 2026:

- branch `main` sincronizada com `origin/main` no commit `9c956d5`;
- implementacao da Spec 005 ainda nao commitada;
- 47 entradas possuem mudancas staged;
- 17 entradas possuem mudancas unstaged, varias sobre arquivos ja staged
  (`MM` ou `AM`);
- nao existem arquivos untracked;
- alteracoes em `docs/specs/Img/` sao material do usuario e devem ser
  preservadas.

Antes do proximo commit, adicionar as correcoes unstaged para evitar registrar
uma versao anterior dos goldens, testes e ajustes de acessibilidade.

Validacao tecnica mais recente:

- `dart format`: 88 arquivos, nenhuma alteracao necessaria;
- `flutter analyze`: nenhum problema;
- `flutter test`: 64 testes aprovados;
- seis goldens em `390x844`, nos temas claro e escuro.

## Leitura Canonica

Pelo `AGENTS.md`, o ponto de entrada oficial e:

- `para mobile/00-contexto-operacional.md`

Leia esse arquivo antes de alterar qualquer coisa. Ele direciona quais outros
documentos consultar conforme o tipo de tarefa.

Documentos mais importantes em `para mobile/`:

- `00-contexto-operacional.md`: visao geral e porta de entrada.
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
- `docs/`: specs, imagens e material de apoio de implementacao.
- `para mobile/`: documentacao operacional canonica.
- `lib/`: codigo principal do app.
- `test/`: testes automatizados.
- `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/`: plataformas.
- `build/`: artefatos gerados.

## Onde Fica Cada Coisa em `lib/`

### `lib/app`

Nucleo de inicializacao do aplicativo.

Aqui ficam itens como:

- `arara_app.dart`: ponto de composicao principal do app;
- `router/`: rotas e navegacao;
- `theme/`: tema global, tokens e estilos base;
- `startup/`: bootstrap e estado inicial;
- `localization/`: recursos de localizacao.

Va para `lib/app` quando quiser mexer em:

- tema global;
- roteamento;
- inicializacao da aplicacao;
- comportamento geral compartilhado entre features.

### `lib/core`

Infraestrutura e contratos de apoio.

Pelo que esta estruturado hoje, essa area concentra utilitarios, configuracoes e
fundacoes que nao pertencem a uma feature especifica.

Exemplo observado:

- `config/fixture_access_profile.dart`

Va para `lib/core` quando quiser entender:

- configuracoes compartilhadas;
- base tecnica comum;
- fixtures ou apoio transversal.

### `lib/shared`

Componentes reutilizaveis da interface.

Aqui fica boa parte da base visual compartilhada, como widgets usados em mais de
uma tela. Pelos arquivos existentes, essa pasta ja concentra bastante da cara do
produto atual.

Exemplos de widgets presentes:

- `operational_top_bar.dart`
- `dashboard_hero.dart`
- `app_shell_scaffold.dart`
- `app_bottom_navigation.dart`
- `tenant_context_card.dart`
- `product_card.dart`
- `status_badge.dart`

Va para `lib/shared` quando quiser melhorar:

- header superior das telas;
- scaffold padrao;
- navegacao inferior;
- cartoes, badges e elementos visuais repetidos.

### `lib/features`

Organizacao principal por dominio funcional.

Cada feature tende a seguir a separacao por camadas, com pastas como
`presentation`, `application`, `domain` e `data` quando ja implementadas.

#### Features com aparencia de implementacao mais concreta

- `dashboard`
- `catalog`
- `settings`

Essas sao as melhores portas de entrada para melhorias visuais e ajustes de UX,
porque ja possuem telas operacionais que aparecem no app atual.

#### Features com cara de estrutura parcial ou base

- `auth`
- `clients`
- `inventory`
- `reports`
- `sales`

Essas pastas parecem importantes para a arquitetura futura, mas nao aparentam
ter o mesmo nivel de preenchimento das tres areas acima.

## Onde Melhorar a Interface Mais Rapido

Como voce pediu melhoria geral nas telas, principalmente na area superior, os
lugares mais provaveis para atuar primeiro sao:

- `lib/shared/widgets/operational_top_bar.dart`
- `lib/shared/widgets/dashboard_hero.dart`
- `lib/shared/widgets/app_shell_scaffold.dart`
- `lib/shared/widgets/app_bottom_navigation.dart`
- paginas em `lib/features/dashboard/presentation/pages/`
- paginas em `lib/features/catalog/presentation/pages/`
- paginas em `lib/features/settings/presentation/pages/`

Se a ideia for deixar a aplicacao mais bonita de forma ampla, a ordem mais
produtiva costuma ser:

1. validar manualmente a implementacao atual da Spec 005;
2. corrigir inconsistencias visuais encontradas nos tamanhos previstos;
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

Leitura pratica:

- `001`: explica a base arquitetural;
- `002`: explica a construcao do tema;
- `003`: explica a primeira interface operacional;
- `004`: registra a etapa anterior de revitalizacao estetica;
- `005`: define e implementa a identidade visual operacional atual.

Para entender a UI atual, comece pela Spec 005 e use as Specs 003/004 como
historico das decisoes substituidas ou evoluidas.

## `test/`

Os testes ajudam a localizar o que ja tem cobertura e quais partes do app sao
consideradas mais estaveis.

Pelo que foi encontrado:

- `test/app/`: teste do app principal;
- `test/architecture/`: validacoes de organizacao e contratos;
- `test/features/catalog/`: testes da tela de catalogo;
- `test/features/dashboard/`: testes da tela de dashboard;
- `test/features/settings/`: testes da area operacional de settings;
- `test/theme/`: testes do tema;
- `test/shared/widgets/`: comportamento e acessibilidade dos componentes;
- `test/goldens/`: referencias visuais de shell, dashboard e catalogo.

Os goldens carregam Instrument Sans e Lucide obrigatoriamente. Alteracoes de
layout devem executar os testes correspondentes e passar por inspecao visual,
nao apenas regenerar as imagens.

## Atalhos de Navegacao

Se voce quer ir direto ao ponto:

- entender o projeto antes de tudo: `para mobile/00-contexto-operacional.md`
- encontrar qualquer caminho rapidamente: `tree.txt`
- mexer no visual global: `lib/app/theme/`
- mexer no topo operacional: `lib/shared/widgets/operational_top_bar.dart`
- mexer no hero do dashboard: `lib/shared/widgets/dashboard_hero.dart`
- mexer na moldura geral das paginas: `lib/shared/widgets/app_shell_scaffold.dart`
- mexer na tela inicial: `lib/features/dashboard/`
- mexer em produtos/catalogo: `lib/features/catalog/`
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
2. `lib/shared/widgets/`
3. `lib/features/dashboard/`
4. `lib/features/catalog/`
5. `lib/features/settings/`

## Observacao Final

Este arquivo nao substitui a documentacao oficial do projeto. Ele funciona como
guia de orientacao rapida para reduzir atrito na navegacao entre pastas, specs e
features.
