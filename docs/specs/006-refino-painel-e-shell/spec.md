# Spec 006 - Refino do Painel e Integracao da Shell Operacional

## Status

Planejada em 18 de junho de 2026. Nao implementada.

Esta spec exige aprovacao explicita antes de qualquer alteracao em `lib/`,
rotas, widgets, fixtures, componentes compartilhados ou testes do aplicativo.

Esta etapa existe apenas para documentar a intencao da mudanca e abrir um
espaco de leitura e refinamento. Nao autoriza execucao.

## Classificacao

- interface;
- navegacao;
- shell operacional;
- dashboard;
- conta e contexto;
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

## Contexto

A Spec 005 consolidou a base visual do app mobile com:

- shell operacional;
- tema claro e escuro;
- top bars compactas;
- hero exclusivo do dashboard;
- revisao visual de catalogo, Mais e contexto operacional;
- iconografia encapsulada;
- navegacao inferior propria.

Apesar disso, o painel atual ainda conserva excesso de copy explicativa,
um hero percebido como generico e elementos da shell ainda sem comportamento
real, especialmente menu lateral e alternancia de tema no topo.

## Problema

A experiencia atual perde precisao editorial e densidade operacional pelos
seguintes motivos:

- o dashboard ainda abre com um banner hero textual considerado generico;
- secoes do painel usam subtitulos desnecessarios e autoexplicativos;
- a shell ainda possui trigger de menu sem comportamento real;
- o topo ainda nao oferece alternancia real entre tema claro e escuro;
- nao existe uma entrada principal para vendas na navegacao;
- o app ainda tolera microcopy generica em lugares que deveriam ser secos,
  objetivos e operacionais.

## Objetivo

Refinar a shell e o painel para aproximar o app de uma linguagem mais
operacional, silenciosa e confiavel, com foco em:

- remocao de texto generico e decorativo;
- ativacao funcional do menu lateral;
- ativacao funcional do toggle de tema no topo;
- inclusao de vendas como destino primario da shell;
- introducao de um painel mais util e menos explicativo;
- inclusao de card de ultima atualizacao;
- preparacao de area grafica inicial no painel com base apenas em contrato
  documentado e dados fixture aprovados.

Este documento nao descreve implementacao de codigo. Ele registra a intencao da
futura mudanca e o criterio de leitura para aprovar ou refinar a direcao.

## Principios editoriais obrigatorios

### 1. Zero slop textual

Nao criar texto generico, ornamental, autoexplicativo ou de enchimento em lugar
algum da aplicacao.

Isto inclui:

- frases tentando explicar o obvio;
- subtitulos decorativos sem informacao nova;
- textos que so repetem o titulo da secao com outras palavras;
- mensagens com tom promocional, vazio ou artificial.

### 2. Titulo curto, contexto so quando necessario

- secoes usam titulo curto;
- subtitulo so existe quando acrescenta contexto operacional real;
- placeholder nao pode inventar narrativa;
- telas em preparacao nao podem usar copy inflada.

### 3. Dashboard como leitura operacional

- o painel deve privilegiar dados, agrupamento e ritmo;
- o topo do dashboard nao deve desperdiçar altura com texto generico;
- cards e secoes devem ser diretos;
- informacao util deve aparecer antes de qualquer explicacao.

### 4. Shell com comportamento real

- trigger de menu precisa funcionar;
- toggle de tema precisa funcionar;
- navegacao deve refletir os modulos principais;
- placeholders so podem existir quando o modulo ainda nao possui contrato ou
  fluxo funcional implementavel.

## Decisoes aplicaveis

| Decisao | Aplicacao nesta spec |
| --- | --- |
| MOB-002 | Mudancas permanecem organizadas por feature e camada |
| MOB-004 | Estado e injecao continuam em Riverpod |
| MOB-007 | Navegacao continua sob `go_router` |
| MOB-014 | Identidade azul operacional continua reconhecivel |
| MOB-015 | Permissoes orientam a UX sem substituir autorizacao |
| MOB-016 | Contrato planejado nao pode ser tratado como implementado |
| UI-001 | Navegacao primaria continua inferior |
| UI-003 | Dashboard permanece como tela mais rica visualmente |
| UI-005 | Dados permanecem visiveis durante refresh |
| UI-006 | `price = null` continua estado restrito valido |

## Escopo funcional

Esta spec cobre:

- shell operacional autenticada atual;
- `OperationalTopBar`;
- drawer lateral operacional;
- preferencia local de tema;
- dashboard;
- entrada principal de vendas;
- conta no drawer;
- edicao local de nome;
- documentacao editorial contra copy generica.

Estados preservados:

- `loading`;
- `ready`;
- `refreshing`;
- `empty`;
- `offline`;
- `restricted`;
- `failure`.

## Mudancas pretendidas em alto nivel

### Shell superior

Adicionar ao topo:

- botao de menu funcional;
- acao de busca preservada;
- botao de alternancia clara/escura ao lado da busca.

O toggle deve controlar um estado explicito de tema no app. Nesta spec, o app
deixa de depender exclusivamente de `ThemeMode.system` durante a sessao.

### Drawer lateral

O botao de menu da `OperationalTopBar` deve abrir um drawer lateral vindo da
esquerda, ocupando aproximadamente metade da largura da tela.

Conteudo minimo:

- conta do usuario;
- tenant atual;
- acao `Ver conta`;
- acao `Alterar nome`.

Regras:

- drawer e secundario, nao substitui a navegacao principal;
- visual segue shell operacional, nao tema admin;
- nao usar texto explicativo inflado;
- nao inventar acoes remotas.

### Conta e alteracao de nome

Nesta spec, `Alterar nome` tera escopo estritamente local e visual.

Permitido:

- abrir fluxo simples de edicao;
- atualizar fixture ou estado local visivel no app;
- refletir a mudanca em drawer e tela de contexto.

Nao permitido:

- inventar endpoint;
- criar persistencia remota;
- simular sucesso de backend;
- sugerir que o nome foi salvo em servidor quando isso nao existe.

### Navegacao principal

Adicionar `Vendas` como destino principal da barra inferior.

A shell passa a ter quatro destinos:

- Painel;
- Produtos;
- Vendas;
- Mais.

`Vendas` deve usar o icone semantico ja definido em `AppIcons`.

### Tela de vendas (Módulo de Venda Offline em Memória)

Nesta spec, o módulo de vendas deixa de ser apenas um placeholder e passa a conter uma interface funcional local baseada em fixtures, preparando a experiência visual completa antes da persistência física.

Ela deve conter:
- **Seleção de Cliente:** Interface que permite abrir um modal de seleção simples para associar a venda a um cliente, consumindo uma fixture local de clientes (`buildClientsFixture()`).
- **Carrinho de Compras (Carrinho Operacional):**
  - Botão "Adicionar Produto" que exibe os produtos disponíveis na fixture do catálogo.
  - Ajuste de quantidade por produto (`+` e `-`), iniciando em 1 unidade.
  - Exibição de preços unitários, subtotais por item e o valor total da venda calculados em tempo real (sujeito à permissão `view_financial_metrics`, ocultando valores e exibindo "Financeiro restrito" se ausente).
  - Remoção de itens individualmente.
- **Registro Offline Local:**
  - Botão "Registrar Venda".
  - Ao ser acionado, cria uma intenção de venda contendo um `client_request_id` (UUID local), dados do cliente e itens selecionados, inserindo-a em uma lista em memória controlada por Riverpod (`pendingSalesProvider`).
  - Apresenta um estado visual de sucesso informando que a venda foi armazenada localmente e será integrada à fila de sincronização assim que as dependências físicas forem implementadas.

### Dashboard

Remover completamente o hero atual do painel, incluindo o banner textual
associado a Arara-Gastos e a mensagem generica de resumo da operacao.

Tambem remover subtitulos desnecessarios nas secoes do painel.

Remover explicitamente os textos:

- `KPIs resumidos`
- `Leitura compacta para operacao em campo`
- `Alertas de estoque`
- `Ruptura e baixo saldo visiveis sem abrir o web dashboard`
- `Ultimos eventos resumidos no app. O dashboard web continua disponivel para leitura completa`

O painel passa a operar com secoes de titulo curto, sem descricao ornamental.

### Card de ultima atualizacao

Adicionar um card proprio para ultima atualizacao do painel.

Conteudo minimo:

- rotulo curto;
- `updatedAtLabel` em destaque;
- status complementar util quando houver, como contexto financeiro restrito ou
  liberado, desde que isso continue operacional e curto.

Este card substitui o papel informativo antes embutido no hero.

### Inclusao futura de graficos permitidos pelo contrato

Os primeiros graficos da tela devem ser escolhidos apenas entre blocos ja
documentados no contrato de `GET /api/mobile/dashboard`.

Graficos iniciais permitidos nesta spec:

- `operational_goal_chart`;
- `stock_level_chart`.

Motivo:

- sao operacionais;
- dialogam com painel resumido;
- aparecem no contrato atual;
- permitem valor visual sem inventar modulo novo.

Fora de escopo nesta spec:

- `abc_curve`;
- `risk_turnover_scatter`;
- `impact_products`;
- `recommended_actions`;
- qualquer grafico cuja semantica visual ainda exija nova decisao.

Enquanto o app continuar em fixture, os dados graficos devem nascer de fixture
explicita e deterministica.

## Diretrizes de copy obrigatorias

A partir desta spec, a aplicacao passa a seguir as seguintes regras editoriais:

- nao usar copy generica;
- nao usar frases para explicar o obvio;
- nao usar texto de enchimento para parecer UX polida;
- nao usar tom de assistente artificial;
- nao criar secao com titulo e subtitulo redundantes;
- placeholders devem ser curtos e honestos;
- mensagens devem ser operacionais, nao promocionais.

Exemplos proibidos:

- `Leitura compacta para operacao em campo`
- `Ultimos eventos resumidos no app`
- `Resumo inteligente da sua operacao`
- `Tudo que voce precisa em um so lugar`

## Fora de escopo e Dependências Futuras

- autenticacao mobile real;
-  persistencia remota de perfil;
- contrato de edicao de conta;
- outbox física e persistente;
- sync incremental real;
- relatorios mobile;
- area admin;
- qualquer endpoint planejado e ainda nao implementado.

### Dependências Técnicas Futuras Adicionadas ao Roadmap (Não Integradas)
- **Persistência Local Física:** O armazenamento local persistente das configurações de tema, nome do usuário editado e da fila de intenções de vendas offline criada nesta spec dependerá da futura implementação de um banco de dados físico (Drift/SQLite) ou preferências de chave-valor (`shared_preferences`). Na Spec 006, estas ações operarão estritamente em memória durante a sessão.
- **Sincronização e Reconciliação com Servidor:** Drenagem real da outbox de vendas offline para o endpoint remoto `POST /api/mobile/sale-intents` e o tratamento de propostas ajustadas de estoque.

## Riscos e mitigacoes

| Risco | Impacto | Mitigacao |
| --- | --- | --- |
| Nova regra editorial ser aplicada de forma inconsistente | Alto | Registrar exemplos proibidos e revisar telas afetadas |
| Vendas parecer definitivo sem persistir no banco | Alto | Expor banners claros de estado ("Registrado offline") e documentar a fila em memória pendingSalesProvider |
| Drawer competir com bottom navigation | Medio | Drawer so para conta e atalhos secundarios |
| Tema local conflitar com system theme | Medio | Tornar precedencia do modo manual explicita nesta spec |
| Graficos virarem decoracao vazia | Alto | Limitar a dois blocos do contrato ja documentado |
| Edicao local de nome parecer persistencia real | Alto | Explicitar escopo local e nao remoto |
| Drawer falhar ao abrir devido a Scaffolds aninhados | Alto | Criar um widget AppDrawer comum e declará-lo no slot drawer de cada Scaffold de subpágina ativo, em vez da shell externa |

## Criterios de aceite da spec documental

- [ ] O status da spec deixa claro que ela esta planejada e nao implementada.
- [ ] O documento registra que esta etapa e apenas de criacao documental.
- [ ] O objetivo descreve intencao futura sem descrever implementacao de codigo.
- [ ] As mudancas pretendidas em alto nivel cobrem tema, drawer, vendas,
      dashboard, ultima atualizacao e graficos permitidos.
- [ ] A regra anti-copy-generica esta registrada de forma explicita.
- [ ] O documento nao trata endpoint planejado como implementado.
- [ ] O documento nao transforma a spec em autorizacao de execucao.
- [ ] Fora de escopo e riscos estao claros o suficiente para leitura critica.

## Gate de implementacao

Esta spec pode ser revisada e aprovada como documento sem autorizar sua
execucao.

A implementacao somente pode comecar depois de uma solicitacao explicita do
usuario para executar a Spec 006. Ate esse momento:

- nao alterar `lib/`;
- nao alterar rotas da aplicacao;
- nao alterar `pubspec.yaml` ou `pubspec.lock`;
- nao adicionar assets;
- nao atualizar testes do aplicativo;
- nao marcar tarefas de implementacao como concluidas.
