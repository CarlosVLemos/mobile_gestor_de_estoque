# Spec 014 — Revitalização Visual e UX Operacional

Status: `in_progress — PHASE 1 COMPLETE`
Mode: `CRITICAL`
Execution mode: `SINGLE_WRITER`
Data: 2026-09-18
Owner: Jarvis / Van Gogh / Mefisto
Contrato: [`contract.md`](contract.md) — `FROZEN`, Version 1

## Objetivo

Transformar a aplicação funcional existente em uma experiência mobile coesa,
madura, profissional e adequada ao uso frequente por vendedores e operadores,
sem alterar os contratos funcionais, remotos ou locais já validados.

A entrega deve preservar a identidade Arara-Gastos: `Instrument Sans`, azul e
navy predominantes, atmosfera fria e analítica, superfícies bem delimitadas,
hero navy, cards compactos, densidade moderada/alta, estados semânticos,
iconografia Lucide e temas claro/escuro.

Esta Spec autoriza recomposição de layout e hierarquia visual dentro do
contrato congelado. Ela não reduz a revitalização a cores, padding, radius ou
sombras.

## Problema

O aplicativo já fecha verticais reais de autenticação, contexto, catálogo,
dashboard, clientes, vendas persistentes, outbox, proposta/aceite/recovery e
runtime demo, mas a apresentação ainda expõe decisões provisórias e linguagem
interna:

- Bottom Navigation, Drawer e `Mais` coexistem com responsabilidades
  sobrepostas;
- Dashboard, Catálogo, Vendas e Mais oferecem uma busca global que apenas
  informa que a funcionalidade não existe;
- o toggle de tema ocupa todas as top bars em vez de pertencer ao centro
  secundário do aplicativo;
- Dashboard não materializa o hero navy definido como assinatura visual e
  trata data e hora de sincronização como dois KPI cards;
- preço e quantidade podem assumir visual de badge, confundindo informação
  com estado;
- Vendas mistura criação e histórico numa única sequência longa e apresenta
  `outbox`, JSON de proposta e erro técnico ao vendedor;
- Mais expõe backlog e indisponibilidades de desenvolvimento;
- Conta ainda usa termos técnicos evitáveis;
- telas importantes dependem de spinners isolados e não possuem cobertura
  visual equivalente à maturidade funcional atual.

## Baseline auditado

Auditoria estática realizada em 2026-09-18 na branch `dev`. Nenhum teste,
análise estática, formatação, build ou execução do aplicativo foi realizado.

### Rotas e contratos funcionais

As oito rotas solicitadas existem em `app_routes.dart` e são compostas por
`GoRouter`/`StatefulShellRoute.indexedStack`:

```text
/
/login
/change-password
/app/dashboard
/app/products
/app/sales
/app/more
/app/context
```

A shell autenticada já possui os quatro destinos desejados:

```text
Painel | Produtos | Vendas | Mais
```

Os redirects por estado de autenticação e troca obrigatória de senha já estão
implementados. A Spec preserva todas essas rotas e redirects.

### Tema e componentes existentes

O código já possui uma base visual que deve ser evoluída, não recriada:

- temas Material 3 claro e escuro;
- `Instrument Sans` configurada como família tipográfica;
- tokens de cor, tipografia, espaçamento, tamanhos, radius, sombras e motion;
- gradientes atmosférico, hero e auth;
- Lucide encapsulado em `AppIcons`;
- touch target mínimo de 48 px;
- `AnimatedStateSwitcher` com motion moderado;
- componentes compartilhados para shell, top bar, navegação, cards, estados,
  permissões, contexto e banner demo.

### Evidências por superfície

| Superfície | Estado real confirmado | Problema de UX / oportunidade |
| --- | --- | --- |
| Startup | restauração de sessão, falha e retry preservados; background atmosférico e progresso linear | marca e composição ainda mínimas; não compartilha linguagem visual com Auth |
| Login | formulário funcional com código, senha e nome do dispositivo; loading e erro | sem superfície auth, show/hide de senha, autofill e hierarquia refinada |
| Change Password | fluxo obrigatório, três campos, loading e logout | repete estrutura simples do Login; não há shell auth compartilhado |
| Shell | bottom navigation com quatro destinos e reflow para texto grande | cada página principal anexa um Drawer próprio; ele repete navegação, mas ainda concentra Conta, logout com confirmação de pendências e edição local de nome |
| Top bar | componente compartilhado suporta ações contextuais | busca falsa e toggle de tema aparecem nas quatro telas principais |
| Dashboard | KPIs, meta, estoque, alertas, movimentos e estados local-first | hero navy ausente; sync renderizado em dois cards `Sincronizado em/às`, não como metadata |
| Catálogo | busca real, categorias, filtros, `price = null`, estoque, restrição, offline e cache local | preço aparece como `StatusBadge`; hierarquia do card mistura estado e informação |
| Vendas | clientes/produtos persistidos, pickers pesquisáveis, carrinho, registro por use case e histórico persistido; `createdAt` já existe no resumo persistido | criação e histórico não se distinguem como modos; a data não é exibida e copy/estados são orientados à implementação |
| Proposta/aceite | aceite usa `localSaleId` e `proposalRevision` reais | domínio expõe `proposalJson` e `lastError` como strings; UI imprime ambos sem tradução segura |
| Mais | acesso a contexto e leitura resumida de feature/permissão | mostra `fora do escopo`, `aguardando endpoints` e busca falsa; não concentra Aparência, Sync e Sair |
| Conta | usa `UserSession`/`OperationalContext` reais e `TenantContextCard` | ainda menciona `tenant`, backend, servidor soberano e futuras intenções |
| Estados | cards compartilhados para empty/failure/restricted/offline; dados são preservados em refresh/falha quando modelados | loading inicial ainda usa spinner isolado em Dashboard, Catálogo, Histórico e Conta |
| Demo | banner global inequívoco já existe | deve continuar visível e sem interferir na shell revitalizada |

### Baseline visual e testes

Existem seis goldens canônicos, todos em 390x844:

- Shell claro/escuro;
- Dashboard claro/escuro;
- Catálogo claro/escuro.

Eles documentam o baseline armazenado, não o visual desejado. Há indício
estático de defasagem: o PNG claro do Dashboard mostra um único KPI de
atualização, enquanto a fonte atual constrói dois cards adicionais para data e
hora. O gate posterior deve confirmar essa divergência sem presumir falha antes
de executar o teste autorizado. Artefatos sob `failures/`, caso existam durante
QA, não são referência de produto.

Há boa cobertura prévia de estados do Dashboard/Catálogo, responsividade de
componentes e fluxos funcionais de vendas. Permanecem gaps em widgets de Auth,
navegação ponta a ponta da shell, histórico/proposta de vendas, paridade
light/dark fora dos seis goldens, semântica, foco e teclado.

## Escopo

### 1. Sistema visual compartilhado

- consolidar os tokens atuais sem trocar a identidade aceita;
- manter superfícies com borda, sombra curta e atmosfera controlada;
- formalizar hierarquia de página, hero, métricas, busca, segmentação, estados
  e indicador de sincronização somente onde houver reuso real;
- aplicar motion curto a mudanças de estado, seleção e carrinho;
- preservar Lucide e evitar ícones Material dispersos quando houver equivalente.

Componentes candidatos, condicionados a duplicação comprovada:

```text
AppPageHeader
AppHeroCard
AppMetricCard
AppSearchField
AppSegmentedControl
AppStatePanel
AppSyncIndicator
AppUserHeader
```

Não existe obrigação de criar todos eles.

### 2. Shell e navegação

- manter `Painel | Produtos | Vendas | Mais` como navegação principal;
- remover o Drawer das quatro páginas operacionais principais;
- migrar Conta e Sair para `Mais`, preservando integralmente a confirmação de
  logout quando houver outbox pendente;
- remover “Alterar nome” da UI enquanto não existir perfil persistente real;
- preservar as rotas, redirects autenticados, stacks e seleção da aba atual;
- remover as buscas globais falsas, sem substituí-las por nova feature;
- usar top bars com ações contextuais reais;
- concentrar Aparência em `Mais` com seletor `Sistema | Claro | Escuro`, usando
  `ThemeMode` em memória e sem adicionar persistência;
- preservar o banner demo global.

### 3. Startup e Auth

- reforçar marca, composição, loading, erro, retry e microcopy de Startup;
- criar coerência entre Login e Change Password por composição compartilhada
  somente se isso reduzir duplicação;
- adicionar superfície auth, background atmosférico e hierarquia clara;
- permitir mostrar/ocultar senhas;
- manter feedback de erro, loading do CTA, foco, teclado e autofill adequados;
- reduzir o peso visual de “Nome deste dispositivo” sem removê-lo;
- preservar integralmente autenticação, campos, validações, fluxo obrigatório e
  logout; não inventar política de senha.

### 4. Dashboard

- reintroduzir o hero navy como assinatura visual usando apenas dados já
  disponíveis;
- organizar `Hero -> KPIs -> meta -> estoque -> alertas -> movimentos`;
- apresentar a última sincronização como metadata operacional compacta;
- manter métricas financeiras restritas e demais permissões;
- não fabricar tendências, comparações, percentuais, metas ou valores.

### 5. Catálogo

- preservar busca, categorias, filtros e estados local-first;
- refinar `CatalogFilterBar` e `ProductCard` para leitura frequente;
- reservar badge para estado semântico;
- apresentar preço, quantidade e SKU como informação;
- preservar `price = null`, estoque, disponibilidade e permissões;
- manter dados locais visíveis durante refresh, offline e falha recuperável.

### 6. Vendas

- priorizar a sequência vendedor -> cliente -> produtos -> quantidades ->
  resumo -> registrar venda;
- distinguir `Nova venda` e `Histórico` com controle segmentado dentro de
  `/app/sales`, sem nova rota;
- preservar cliente, itens, quantidades e demais draft state ao alternar os
  segmentos enquanto o controller existir;
- refinar pickers pesquisáveis sem generalização prematura;
- usar somente nome/código/cidade no cliente e nome/SKU/preço no produto; o
  estoque não existe em `SaleProductOption` e não pode ser inventado nesta Spec;
- preservar carrinho, `RegisterSaleUseCase`, venda local, outbox, sync,
  proposal, acceptance, recovery e histórico persistido;
- manter pendente diferente de confirmado;
- remover `outbox` da linguagem apresentada ao usuário;
- mapear estados internos para linguagem operacional sem alterar sua semântica;
- nunca apresentar `proposalJson`, `lastError`, stack trace ou mensagem técnica
  bruta.

O domínio atual não expõe uma proposta estruturada pronta para consumo humano;
ele disponibiliza JSON serializado. A solução contratada é apresentar
“Revisão necessária”, explicar que o servidor retornou um ajuste e manter a
ação de aceite já existente, sem interpretar ou exibir o JSON. A ausência de
detalhes estruturados é risco conhecido aceito e dívida funcional para uma
Spec/Change Request posterior; não bloqueia a 014.

### 7. Mais e Conta

- transformar `Mais` no centro secundário para Conta/Empresa, Aparência,
  Sincronização, Sobre e Sair, mostrando somente capacidades reais;
- ocultar Estoque, Relatórios e outros módulos inexistentes; indisponibilidade
  só aparece quando uma capacidade real estiver bloqueada por
  feature/permissão/configuração;
- remover a edição local de nome;
- preservar dados reais de usuário, empresa, features e permissões;
- apresentar “Conta e empresa”, “Empresa atual” e “Seu acesso” em vez de
  termos técnicos evitáveis;
- não sugerir que ocultar uma ação substitui autorização remota.

### 8. Loading, estados, responsividade e acessibilidade

- avaliar skeletons estáveis em Dashboard, Catálogo, Histórico e Conta;
- manter spinner para ações pontuais;
- cobrir `loading`, `ready`, `empty`, `restricted`, `offline`, `refreshing` e
  `failure` quando aplicáveis;
- preservar conteúdo local durante refresh/falha remota;
- validar tema claro/escuro, largura de 320 px e text scaler 2.0;
- preservar contraste, semântica além de cor, touch targets de 48 px, ordem de
  foco, teclado, scroll e ausência de overflow.

### 9. Goldens

- manter e atualizar os seis goldens existentes somente após aprovação humana
  explícita do novo visual;
- manter/criar exatamente 18 referências aprovadas: Shell, Login, Change
  Password, Dashboard, Catálogo, Vendas — Nova venda, Vendas — Histórico, Mais
  e Conta/Empresa, cada uma em claro e escuro;
- cobrir Startup, pickers, offline, error, empty e componentes isolados com
  widget tests focados, não goldens;
- não criar golden para cada widget trivial.

## Fora de escopo

- endpoint, payload, ID, paginação, permissão ou tenant scope novo/alterado;
- mudanças no backend;
- connectivity real, health check ou background sync;
- novo SyncEngine, nova outbox ou alteração de idempotência/retry;
- mudança de isolamento user/tenant;
- schema, migration, `schemaVersion` ou codegen Drift;
- nova autenticação, refresh token ou política de token/senha;
- relatórios, estoque dedicado ou outros módulos novos;
- release, signing, VPS, HTTPS ou `applicationId` final;
- mudança funcional em `domain`, `application`, `data`, `core/database` ou
  `core/sync`;
- parsing de JSON remoto dentro de widget/presentation;
- dados, tendências ou ações não suportados pelos contratos atuais.

Uma necessidade em qualquer item acima deve ser registrada como gap. Depois do
freeze, se ela for indispensável ao aceite, exige Change Request antes de
qualquer alteração.

## Paths previstos

Os paths autorizáveis estão formalizados em [`contract.md`](contract.md). O
baseline congelado restringe produção a tema, startup, widgets compartilhados
e `presentation` das cinco features em escopo. O router funcional não participa
do redesign; `app_router.dart` pode receber somente correção dos comentários
obsoletos que ainda descrevem a autenticação como inexistente.

## Riscos

- regressão funcional disfarçada de recomposição visual;
- remover Drawer sem realocar logout/conta/aparência com segurança;
- expor venda pendente como confirmada por linguagem ou cor;
- esconder restrição financeira ou confundir `price = null` com erro;
- interpretar JSON remoto na UI e acoplar apresentação ao transporte;
- atualizar goldens antes da aprovação do novo visual;
- criar abstrações compartilhadas sem reuso comprovado;
- excesso de densidade em 320 px ou overflow com text scaling alto;
- dark mode tecnicamente compilável, mas com contraste ou hierarquia inválidos;
- testes antigos continuarem congelando copy e hierarquia que esta Spec remove;
- escopo transversal produzir diff grande e difícil de revisar.

## Critérios de aceite

- [ ] AC-014-01: Startup, Auth, Dashboard, Catálogo, Vendas, Mais e Conta compartilham identidade visual coerente e reconhecível como Arara-Gastos.
- [ ] AC-014-02: a shell mantém `Painel | Produtos | Vendas | Mais`, remove o Drawer das páginas principais e preserva Conta/logout em Mais.
- [ ] AC-014-03: buscas globais falsas são removidas e nenhuma ação primária visível é inoperante.
- [ ] AC-014-04: Login e Change Password usam linguagem visual coerente e preservam integralmente seus fluxos atuais.
- [ ] AC-014-05: Dashboard apresenta hero e hierarquia operacional clara sem fabricar dados.
- [ ] AC-014-06: sincronização é metadata operacional e não ocupa KPIs equivalentes a métricas de negócio.
- [ ] AC-014-07: Catálogo preserva busca, filtros, categorias e todos os estados existentes.
- [ ] AC-014-08: em Produto, badge representa estado; preço, quantidade e SKU são informação.
- [ ] AC-014-09: Vendas otimiza a sequência cliente -> produtos -> quantidades -> resumo -> registro.
- [ ] AC-014-10: `Nova venda | Histórico` usa controle segmentado na mesma rota e não perde o draft ao alternar enquanto o controller existir.
- [ ] AC-014-11: UI final não apresenta `outbox`, `proposalJson`, JSON cru, `lastError`, stack trace ou erro técnico bruto; revisão usa fallback seguro.
- [ ] AC-014-12: `price = null`, permissões, features e restrições financeiras continuam semanticamente corretos.
- [ ] AC-014-13: venda local pendente nunca é apresentada como confirmação remota.
- [ ] AC-014-14: dados locais válidos permanecem visíveis durante refresh, offline e falha remota quando aplicável.
- [ ] AC-014-15: Mais não apresenta linguagem de backlog/desenvolvimento nem módulos inexistentes.
- [ ] AC-014-16: Conta apresenta dados reais de usuário e empresa em linguagem orientada ao usuário.
- [ ] AC-014-17: seletor `Sistema | Claro | Escuro` em Mais representa os três `ThemeMode`, sem nova persistência, e ambos os temas preservam hierarquia e contraste.
- [ ] AC-014-18: 320x700 com text scaler 2.0 não causa overflow nas superfícies críticas.
- [ ] AC-014-19: touch targets, foco, teclado, scroll e semântica não regrediram.
- [ ] AC-014-20: estados loading/ready/empty/restricted/offline/refreshing/failure permanecem explícitos quando aplicáveis.
- [ ] AC-014-21: nenhum contrato de `domain`, `application`, `data`, banco, sync ou API é alterado incidentalmente.
- [ ] AC-014-22: boundaries arquiteturais e encapsulamento de ícones continuam válidos.
- [ ] AC-014-23: os seis goldens existentes só são atualizados após aprovação humana explícita do novo visual.
- [ ] AC-014-24: novos goldens cobrem apenas superfícies estáveis e relevantes, com paridade claro/escuro definida no gate humano.
- [ ] AC-014-25: o banner de modo demo continua inequívoco e o runtime normal não recebe linguagem de demonstração.
- [ ] AC-014-26: Mefisto registra resultados reais e emite veredito antes do fechamento por Jarvis.
- [ ] AC-014-27: Histórico usa `createdAt` já existente sem alterar domain/application/data.
- [ ] AC-014-28: router, rotas e redirects permanecem funcionalmente idênticos; apenas comentários obsoletos podem ser corrigidos.

## Decisões humanas aprovadas

Em 2026-09-18, o gate humano aprovou:

1. remover Drawer e migrar Conta/Sair para Mais, preservando logout seguro;
2. remover “Alterar nome” da UI;
3. usar seletor `Sistema | Claro | Escuro` sem nova persistência;
4. usar `Nova venda | Histórico` segmentado na rota atual, preservando draft;
5. não interpretar `proposalJson`; usar fallback seguro e registrar dívida;
6. ocultar módulos inexistentes;
7. manter exatamente 18 goldens nas nove superfícies aprovadas;
8. remover buscas falsas sem criar substituta;
9. usar `createdAt` no histórico, não inventar estoque no picker e manter o
   router funcional fora do redesign.

Maquiavel não é necessário nesta versão porque nenhuma mudança remota é
autorizada. Ele entra somente se a auditoria posterior revelar dependência real
de endpoint/payload/ID/permissão/tenant scope.

## Gate de abertura

- [x] baseline documental e de código auditado;
- [x] modo `CRITICAL` e execução `SINGLE_WRITER` registrados;
- [x] contrato Version 1 criado como `DRAFT`;
- [x] tasks, matriz de testes, validation-result e review iniciais criados;
- [x] nenhuma UI implementada;
- [x] nenhuma validação executada;
- [x] decisões humanas acima aprovadas em 2026-09-18;
- [x] contrato alterado explicitamente de `DRAFT` para `FROZEN`, Version 1;
- [x] handoff de implementação emitido para Van Gogh.

Implementação iniciada por Van Gogh em `SINGLE_WRITER`. A Fase 1 — Design
System foi concluída por inspeção estática; a próxima fase contratada é
Shell / TopBar / Mais, conforme a ordem registrada em `tasks.md`.
