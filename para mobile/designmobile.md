# Design Mobile Blueprint

## Objetivo

Este documento descreve o visual atual da aplicacao web do Arara-Gastos em nivel suficiente para reproduzir a experiencia em um aplicativo mobile nativo ou híbrido, sem precisar reinterpretar a identidade visual do produto.

Ele cobre:

- cores e tokens visuais;
- tipografia, espacamento e cantos;
- estrutura de navegacao;
- componentes recorrentes;
- principais telas atuais;
- comportamento responsivo observado hoje;
- recomendacoes para traducao fiel para mobile.

Baseado principalmente em:

- `resources/css/app.css`
- `resources/js/layouts/`
- `resources/js/components/App/`
- `resources/js/components/ui/`
- `resources/js/components/Dashboard/`
- `resources/js/pages/Dashboard.vue`
- `resources/js/pages/Sales/Index.vue`
- `resources/js/pages/Produtos/Index.vue`
- `resources/js/pages/auth/Login.vue`
- `resources/js/layouts/auth/AuthSimpleLayout.vue`

---

## 1. Identidade visual atual

### 1.1 Personalidade

A interface atual mistura:

- operacao empresarial;
- painel executivo;
- estoque e vendas;
- leitura rapida com alta densidade de informacao.

O tom visual e:

- profissional;
- frio e analitico;
- fortemente baseado em azul;
- com acentos de status bem claros;
- com contraste suficiente para uso operacional prolongado.

Nao e um produto playful. O sentimento predominante e "painel de controle confiavel".

### 1.2 Assinatura visual

Os traços mais marcantes hoje sao:

- fundo geral muito claro com manchas radiais suaves em azul e dourado;
- sidebar operacional escura, azul-marinho profunda;
- cards brancos ou quase brancos, com borda suave e sombra curta;
- header sticky translúcido com blur;
- titulos compactos, fortes, sem serifas;
- uso consistente de azul para CTA principal;
- blocos hero com gradiente escuro azul para areas de destaque;
- status comunicados por cor sem excesso de ilustração.

---

## 2. Sistema de cores

## 2.1 Tokens principais do tema claro

Origem: `resources/css/app.css`

- `--background: hsl(210 33% 98%)`
- `--foreground: hsl(215 34% 15%)`
- `--card: hsl(0 0% 100%)`
- `--card-foreground: hsl(215 34% 15%)`
- `--primary: hsl(213 77% 46%)`
- `--primary-foreground: hsl(0 0% 100%)`
- `--secondary: hsl(210 21% 94%)`
- `--secondary-foreground: hsl(215 25% 28%)`
- `--muted: hsl(210 18% 92%)`
- `--muted-foreground: hsl(215 13% 42%)`
- `--accent: hsl(212 41% 95%)`
- `--accent-foreground: hsl(213 77% 38%)`
- `--destructive: hsl(348 83% 55%)`
- `--destructive-foreground: hsl(0 0% 100%)`
- `--border: hsl(214 23% 88%)`
- `--input: hsl(214 23% 88%)`
- `--ring: hsl(213 77% 46%)`

Leitura pratica:

- fundo principal: cinza-azulado muito claro;
- texto primario: azul-grafite escuro;
- CTA: azul médio saturado;
- superficies: branco limpo;
- divisorias: cinza frio claro.

## 2.2 Tokens semanticos

- `--success: hsl(152 60% 42%)`
- `--warning: hsl(38 92% 50%)`
- `--destructive: hsl(348 83% 55%)`

Uso atual:

- sucesso: concluido, ativo, saudavel;
- warning: pendente, baixo estoque, atencao;
- destructive: cancelado, esgotado, erro.

## 2.3 Charts

- `chart-1`: azul principal;
- `chart-2`: verde petróleo;
- `chart-3`: azul escuro profundo;
- `chart-4`: amarelo ouro;
- `chart-5`: laranja suave.

No mobile, esses mesmos eixos devem ser mantidos para preservar reconhecimento entre dashboard web e app.

## 2.4 Sidebar operacional

Sidebar operacional forcada via classes inline:

- fundo: `#0b1a2b`
- texto: `#e7eef8`
- accent hover/ativo: `rgba(148,184,255,0.12)`
- borda: `rgba(148,163,184,0.18)`
- ring: `#4d8dff`

Tradução visual:

- navy quase preto;
- itens em texto claro;
- estados ativos com highlight azul translúcido.

## 2.5 Sidebar admin

Sidebar admin usa outra assinatura:

- fundo: `#0d1b2a`
- primary/ring: `#6d4dff`

Isso cria uma subidentidade visual para administracao global.

Conclusao importante:

- operacao do tenant = azul;
- administracao da plataforma = azul escuro com roxo.

Se o app mobile tiver area admin, essa diferenciacao deve continuar.

## 2.6 Tema escuro

Existe suporte real a dark mode.

Traços:

- fundo vira azul-preto;
- cards viram azul-grafite;
- primary clareia para manter contraste;
- sidebar fica ainda mais escura.

No clone mobile, dark mode nao deve ser "inversao automatica". Deve seguir os mesmos tokens.

---

## 3. Tipografia

## 3.1 Fonte

Fonte base:

- `Instrument Sans`

Fallback:

- `ui-sans-serif`
- `system-ui`
- sans-serif

## 3.2 Hierarquia observada

### Titulos principais

- peso: `semibold` ou `bold`
- tracking negativo leve: `tracking-[-0.03em]` a `tracking-tight`
- tamanhos comuns:
  - `text-xl`
  - `text-2xl`
  - `text-[1.65rem]`
  - `md:text-[2rem]` em blocos de destaque

### Microcopy/labels

- uppercase frequente;
- tracking alto;
- tamanhos entre `10px` e `12px`;
- muito usado em:
  - labels de cards;
  - secoes do dashboard;
  - metadata.

### Texto auxiliar

- `text-sm`
- `leading-6`
- cor `muted-foreground`

## 3.3 Tom textual

O produto fala em portugues clara e operacional:

- "Pedidos"
- "Movimentações"
- "Prontos para venda"
- "Reposição próxima"
- "Sem saldo"

Nao usa jargao startup exagerado. O texto tende a ser direto, util e de acao.

---

## 4. Forma, espacamento e sombra

## 4.1 Radius

Token base:

- `--radius: 0.55rem`

Mas a UI real usa varios cantos maiores em blocos-chave:

- cards comuns: `rounded-xl`
- hero/dashboard/login: `rounded-2xl` e `rounded-[28px]`
- chips e pills: `rounded-full`

Regra visual:

- componentes utilitarios: raio medio;
- superfícies de destaque: raio grande;
- controles de acao pequenos: raio suave.

## 4.2 Sombra

Padrao dominante:

- sombras leves, curtas e difusas;
- nada muito elevado;
- visual mais "painel premium" do que "cartao flutuante".

Exemplos:

- `shadow-sm`
- `shadow-xs`
- `shadow-[0_18px_55px_rgba(15,23,42,0.10)]`
- `shadow-[0_16px_40px_rgba(15,23,42,0.14)]`

## 4.3 Bordas

Muito presentes.

Padrao:

- `border-border/70`
- `border-border/60`
- `border-white/7`
- `border-white/10`

O sistema depende bastante de:

- superficie clara;
- borda sutil;
- sombra curta;

No app mobile, isso deve continuar. Nao trocar por cards sem borda.

## 4.4 Espacamento

Padrao recorrente:

- containers principais: `p-6`, `md:p-8`
- grids e blocos: `gap-4`, `gap-6`
- areas compactas: `p-3`, `p-4`
- controles inline: `gap-2`, `gap-3`

Regra:

- densidade media-alta;
- pouca gordura visual;
- informacao priorizada.

---

## 5. Fundos e atmosfera

## 5.1 Background global

O `body` usa:

- cor de fundo clara;
- radial gradient azul suave no canto superior esquerdo;
- radial gradient dourado muito discreto no canto inferior direito;
- `background-attachment: fixed`.

Isso cria ambientacao sem virar ilustracao.

Para mobile:

- manter fundo claro com leves gradientes;
- nao simplificar para branco puro;
- usar gradiente estatico, sem parallax obrigatório.

## 5.2 Blocos hero

O dashboard usa hero escuro com gradiente:

- `linear-gradient(135deg, rgba(11,26,43,0.98), rgba(20,50,86,0.92))`

Esse bloco define o "topo premium" do produto.

No clone mobile, o topo do dashboard deve manter:

- fundo navy gradiente;
- texto branco;
- meta/periodo embutidos;
- contraste alto.

## 5.3 Login

Auth usa:

- fundo claro;
- gradientes radiais azul e âmbar;
- cartao central com blur e borda;
- logomarca dentro de um badge arredondado com fundo azul bem claro.

---

## 6. Iconografia

Biblioteca atual:

- `lucide-vue-next`

Estilo:

- traço limpo;
- outline;
- espessura consistente;
- tamanhos pequenos, geralmente `16px` a `20px`.

Uso:

- navegacao;
- status;
- KPIs;
- acoes inline.

Para mobile:

- manter set equivalente de outline icons;
- nao substituir por icones preenchidos aleatoriamente;
- tamanhos base recomendados:
  - navegação/tab: 20-22
  - ação em lista: 16-18
  - destaque/KPI: 18-24

---

## 7. Estrutura de navegacao atual

## 7.1 Shell operacional

Composicao:

- sidebar lateral off-canvas no mobile;
- header sticky com trigger, breadcrumb e toggle de tema;
- conteudo principal rolavel.

Itens principais hoje:

- Dashboard
- Produtos
- Movimentações
- Pedidos
- Ranking
- Relatórios
- Usuários e Permissões
- Configurações

## 7.2 Shell admin

Itens:

- Painel Admin
- Empresas
- Features
- Configurações

## 7.3 Header

Padrao visual:

- sticky top;
- blur;
- fundo semitransparente;
- trigger arredondado da sidebar;
- busca rapida escondida em telas pequenas;
- botão circular de alternancia claro/escuro.

## 7.4 Implicacao para mobile

Para um app mobile fiel, a melhor traducao nao e manter a sidebar como estrutura primaria.

Recomendacao de clone:

- bottom tab bar para o nucleo operacional;
- drawer secundario para destinos menos frequentes;
- header superior com breadcrumb simplificado ou titulo de tela;
- acoes contextuais no topo da tela.

Tab bar sugerida:

- Painel
- Produtos
- Pedidos
- Estoque
- Mais

Dentro de `Mais`:

- Ranking
- Relatórios
- Usuários
- Configurações

Se houver perfil admin global:

- usar stack separado ou seletor de contexto;
- manter paleta admin com acento roxo.

---

## 8. Componentes-base

## 8.1 Buttons

Variantes atuais:

- `default`
- `destructive`
- `outline`
- `secondary`
- `ghost`
- `link`

Assinatura:

- altura base `h-9`
- texto `text-sm`
- peso `font-medium`
- radius `rounded-md`
- foco com ring visivel

Traducao mobile:

- botao principal azul preenchido;
- secundario com borda clara;
- ghost para acoes discretas;
- destructive vermelho forte.

## 8.2 Inputs

Caracteristicas:

- altura base `h-9`
- borda clara;
- fundo transparente ou levemente preenchido;
- texto base discreto;
- focus com ring azul visivel;
- placeholder em `muted-foreground`.

No mobile:

- aumentar altura util para toque;
- preservar raio medio e ring azul;
- manter placeholder curto e operacional.

## 8.3 Cards

Padrao:

- `bg-card`
- `rounded-xl`
- `border`
- `shadow-sm`
- `py-6`

Cards sao o tijolo principal do app.

## 8.4 Badges e status

`StatusBadge` usa:

- sucesso: fundo tonal verde, texto verde;
- warning: fundo tonal amarelo, texto amarelo;
- destructive: fundo tonal vermelho, texto vermelho;
- neutro: secondary.

Nao usa pills enormes. Os badges sao compactos e sem excesso de ornamentacao.

## 8.5 Breadcrumb

Usado como orientacao contextual na web.

No mobile:

- pode virar subtitulo pequeno ou linha secundaria;
- nao precisa ser sempre exibido;
- importante manter apenas em fluxos profundos.

## 8.6 PageHeader

Estrutura:

- titulo forte;
- descricao curta;
- acoes alinhadas a direita em desktop;
- acoes quebrando em wrap.

No mobile:

- empilhar titulo, descricao e acoes;
- primeira linha com titulo;
- segunda linha com descricao;
- terceira com CTAs horizontais rolaveis ou wrap.

---

## 9. Telas atuais mais importantes

## 9.1 Login

Caracteristicas:

- tela centrada;
- um cartao principal;
- logo pequena em emblema arredondado;
- titulo "Entrar na operação";
- descricao curta;
- form simples com email, senha, lembrar, CTA.

Blueprint mobile:

- tela full screen com cartao centralizado verticalmente;
- mesma hierarquia;
- CTA principal azul ocupando largura total;
- links secundarios discretos.

## 9.2 Dashboard

E a tela que melhor resume a linguagem visual do produto.

Elementos:

- hero dark premium no topo;
- seletor de periodo embutido;
- grid de KPIs;
- secoes separadas por blocos;
- varios cards com dados operacionais, comerciais e estoque;
- uso forte de graficos e alertas.

Tom:

- executivo, nao casual;
- mistura de monitoramento e decisao.

Blueprint mobile:

- topo hero preservado;
- KPIs em carousel ou grid 2x2;
- secoes em pilha vertical;
- graficos em cards full width;
- alertas em cards compactos;
- drawers de detalhe convertidos em bottom sheet ou tela dedicada.

## 9.3 Produtos

Tela com alta densidade operacional.

Elementos:

- PageHeader com CTAs;
- cards resumo;
- filtro por busca, categoria, estoque, preco, pontos;
- tabela principal com estoque, preco, pontuacao;
- dialogs para detalhes e configuracoes.

Risco para mobile:

- tabela larga;
- muitas colunas;
- muitas acoes inline.

Blueprint mobile:

- trocar tabela por lista de cards de produto;
- cabecalho do item:
  - foto
  - nome
  - codigo
  - badge de status
- corpo:
  - estoque
  - pontos
  - preco minimo
  - preco tabela
- acoes:
  - ver
  - editar
  - estoque
- filtros em bottom sheet.

## 9.4 Pedidos

A tela atual usa:

- busca por pedido, vendedor ou loja;
- filtros por status, plataforma, envio e vendedor;
- agrupamento por data;
- cards clicaveis por pedido;
- acoes de PDF e detalhe;
- CTA para novo pedido.

Blueprint mobile:

- manter agrupamento temporal;
- lista em cards;
- topo com busca e filtros em chips horizontais;
- filtros avancados em bottom sheet;
- swipe opcional para PDF ou detalhes;
- card do pedido mostrando:
  - numero
  - cliente/loja
  - vendedor
  - status
  - valor
  - data

## 9.5 Admin

Visualmente parecido com a operacao, mas com:

- sidebar propria;
- acento roxo;
- copy mais institucional;
- menos carga de graficos e mais tabelas gerenciais.

Blueprint mobile:

- mesma base de componentes;
- tema secundario roxo;
- stack de administracao separado.

---

## 10. Motion e interacao

## 10.1 Animacoes globais

Detectadas:

- `fade-in` com `translateY(8px)`
- hover shine opcional em cards

O sistema nao depende de motion intensa.

## 10.2 Interacoes recorrentes

- hover em cards;
- ring de foco claro;
- blur em header;
- offcanvas sidebar no mobile;
- dialogs e sheets para detalhes.

Para mobile:

- usar transicoes curtas;
- sheets com deslizamento vertical;
- evitar animacoes decorativas excessivas;
- priorizar velocidade e legibilidade.

---

## 11. Padrões de copy e microinteracao

## 11.1 Copy

Padrao textual atual:

- verbos claros;
- labels curtos;
- nomes funcionais;
- mensagens de erro objetivas.

Exemplos:

- "Busca rápido..."
- "Prontos para venda"
- "Falha ao gerar PDF"
- "Corrija as quantidades acima do estoque"

## 11.2 Microcopy mobile

Ao clonar para mobile:

- manter portugues operacional;
- evitar ingles interno;
- evitar titulos longos demais;
- priorizar instrucoes curtas.

---

## 12. Pontos atuais da aplicacao que importam para o clone mobile

Esta secao mistura observacao direta e inferencia a partir do codigo atual.

## 12.1 Pontos fortes atuais

- identidade coerente entre dashboard, produtos, pedidos e auth;
- bom sistema de tokens;
- status bem mapeados por cor;
- navegacao principal clara;
- cards e gradientes ja prontos para boa traducao mobile;
- dashboard tem assinatura premium bem definida.

## 12.2 Limitacoes atuais da versao web

- varias telas sao desktop-first;
- produtos e admin dependem bastante de tabelas largas;
- busca rapida do header some em telas pequenas;
- sidebar resolve navegacao, mas nao e a melhor estrutura primaria para app nativo;
- existem areas de alta densidade que pedem reorganizacao em cards mobile.

## 12.3 Divergencias internas que precisam ser respeitadas

- tenant operacional e azul;
- admin da plataforma tem acento roxo;
- dashboard e mais sofisticado visualmente do que listagens comuns;
- auth e mais minimalista e centrado.

O app mobile deve manter essas diferencas.

---

## 13. Blueprint de traducao para aplicativo mobile

## 13.1 Arquitetura visual sugerida

### App shell principal

- status bar adaptada ao tema;
- top app bar por tela;
- bottom tabs com 4 ou 5 destinos;
- drawer ou aba "Mais" para rotas secundarias;
- sheets para filtros e detalhes;
- full-screen modal para criacao/edicao complexa.

### Estrutura de navegacao sugerida

#### Stack autenticado operacional

- Painel
- Produtos
- Pedidos
- Estoque
- Mais

#### Stack autenticado admin

- Painel Admin
- Empresas
- Features
- Configurações

## 13.2 Mapeamento de telas web para telas mobile

### Dashboard web

Virar:

- home operacional do app;
- hero fixo no topo;
- KPI cards compactos;
- listas de alerta abaixo;
- charts em cards separados.

### Produtos web

Virar:

- catalog list screen;
- product detail screen;
- stock adjustment sheet;
- filter sheet;
- category access contextual.

### Pedidos web

Virar:

- order list;
- order detail;
- create/edit order wizard;
- pdf actions sheet.

### Configuracoes web

Virar:

- perfil;
- senha;
- empresa;

em lista simples com navegação interna.

## 13.3 Regras para nao descaracterizar o produto

- nao trocar azul principal por outra cor dominante;
- nao remover o fundo atmosférico claro;
- nao achatar os cards em listas planas demais;
- nao transformar tudo em neon/dark futurista;
- nao trocar os titulos compactos por tipografia genérica;
- nao remover os gradientes escuros das areas hero;
- nao misturar o tema admin com o tema operacional.

---

## 14. Especificacao resumida de design tokens para implementacao mobile

## 14.1 Tokens obrigatorios

- `background`
- `surface`
- `surface-muted`
- `surface-hero`
- `primary`
- `primary-foreground`
- `text-primary`
- `text-secondary`
- `border`
- `success`
- `warning`
- `danger`
- `sidebar-operational`
- `sidebar-admin`

## 14.2 Radius

- `radius-sm = 8`
- `radius-md = 10`
- `radius-lg = 12`
- `radius-xl = 16`
- `radius-hero = 24 a 28`

## 14.3 Shadows

- `shadow-card = leve`
- `shadow-hero = media e difusa`
- `shadow-floating = para sheets e modais`

## 14.4 Typography

- `display/title = Instrument Sans semibold`
- `section label = uppercase, 10-12`
- `body = 14-16`
- `caption = 12-13`

---

## 15. Checklist de clone fiel

- Implementar `Instrument Sans`.
- Replicar tokens de cor do `app.css`.
- Reproduzir gradiente de fundo global.
- Reproduzir hero escuro do dashboard.
- Separar tema operacional e tema admin.
- Manter sidebar web como drawer conceitual e nao como tab principal.
- Converter tabelas em cards/listas no mobile.
- Preservar badges de status semanticos.
- Usar icones outline equivalentes ao Lucide.
- Preservar dark mode com tokens dedicados.
- Preservar tom textual em portugues.
- Criar sheets para filtros e detalhes.
- Manter o dashboard como tela mais rica e premium do app.

---

## 16. Conclusao

O visual atual da aplicacao e suficientemente maduro para virar app mobile sem reinvencao de marca. O caminho correto nao e "redesenhar tudo", e sim:

- preservar a identidade azul executiva;
- converter densidade desktop em listas/cards mobile;
- manter os heroes, status e tokens;
- usar navegacao nativa mais adequada ao celular.

Se esse documento for seguido, o app mobile resultante deve parecer uma extensao natural da versao web atual, e nao um produto paralelo.
