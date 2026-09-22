# Review — Spec 014

Status: `DONE — Gate consolidado 5–8: PASS; Fase 9: PASS WITH RESTRICTION`
Validation: `PASS WITH RESTRICTION`

## Fase 9 — Review final

Estado autoritativo: Gate consolidado 5–8 `PASS`; Fase 9 `PASS WITH RESTRICTION`.

O harness de golden foi ampliado para exatamente 18 superfícies em 390×844,
cobrindo Shell, Auth, Dashboard, Catálogo, Vendas nova/histórico, Mais e
Conta/Empresa nos dois temas. A composição usa fixtures e overrides determinísticos;
nenhuma UI de produção, contrato, rota, domínio, dados, Drift, sync ou outbox
foi modificada nesta fase.

Os 18 PNGs foram gerados/comparados e aprovados em revisão humana. O contraste
do hero dark e a captura do CTA de Nova venda foram corrigidos. Golden suite,
analyze e suíte completa passaram. Mefisto emite `passed_with_restrictions`;
Jarvis fecha a Spec com TalkBack/ordem de foco manual como residual explícito.

## Registro histórico de estabilização — não autoritativo

Estabilização atual: Sales interage por Keys explícitas dos segmentos, enquanto
o design system valida Semantics por `isSemantics`. O fluxo compacto substituiu
`scrollUntilVisible` e cálculo de viewport por `ensureVisible` seguido de
`hitTestable`. Naquela tentativa, o Gate consolidado 5–8 ainda estava
`FAIL / pending revalidation`.

## Implementation handoff

Emitido por Jarvis para Van Gogh em 2026-09-18.

- objective: revitalizar apresentação sem alterar contratos funcionais;
- mode: `CRITICAL`, `SINGLE_WRITER`, contrato `FROZEN` v1;
- order: design system -> Shell/TopBar/Mais -> Auth -> Dashboard -> Catálogo -> Vendas/Histórico -> Conta -> estados -> goldens/QA;
- navigation: remover Drawer; Conta/Sair em Mais; preservar confirmação de logout; remover edição local de nome e buscas falsas;
- theme: seletor `Sistema | Claro | Escuro` em Mais, sem persistência nova;
- sales: segmentado na mesma rota, draft preservado, `createdAt` permitido, estoque não inventado no picker;
- proposal: fallback “Revisão necessária”, sem parsing/JSON/erro bruto; `DEBT-014-01` aceita;
- boundaries: router funcional, domain/application/data/DB/sync/API permanecem inalterados;
- validation: preparar testes junto das fases; não executar comandos sem autorização explícita.

## QA verdict

Gate 1.5: `passed`.

Resultado para a condição de continuidade: `PASS`. A Fase 2 está autorizada
e foi implementada em execução separada. O novo QA permanece `NOT_RUN`.

Valores futuros permitidos:

```text
passed
failed
blocked
passed_with_restrictions
```

## Phase 1 implementation review

Handoff Van Gogh em 2026-09-18:

- produção alterada somente em `lib/app/theme/**` e
  `lib/shared/widgets/**`, dentro dos paths congelados;
- estados empty/failure/restricted/offline/info consolidados em
  `AppStatePanel`, com wrappers anteriores preservados;
- métricas consolidadas em `AppMetricCard`, com `KpiCard` preservado como
  fachada compatível e novas ênfases secondary/compact;
- busca, segmentação e indicador compacto de sincronização preparados como
  componentes compartilhados sem alterar qualquer tela consumidora;
- aliases novos permanecem encapsulados por `AppIcons`/Lucide;
- movimento usa exclusivamente `AppDurations` e `AppCurves`; touch target do
  controle segmentado e do indicador interativo respeita 48 px;
- teste focado de componentes foi criado e seus 8 cenários passaram no Gate 1.5;
- `AppPageHeader`, hero compartilhado, skeletons e recomposição de
  `ProductCard` foram deliberadamente adiados para evitar abstração prematura;
- nenhuma mudança ocorreu em router, feature presentation,
  domain/application/data, banco, sync ou API.

Revisão baseada na inspeção estática do diff, no teste focado aprovado e no
analyze sem issues. Formatação, build, suíte completa, goldens e inspeção
manual em dispositivo não foram executados.

## Gate 1.5 — Mefisto

A revisão estática não encontrou quebra da API de `KpiCard`, mudança nos
construtores dos wrappers, import de camada proibida, dependência circular ou
motion fora dos tokens. Os cenários focados de light/dark, semântica, touch
targets e reflow receberam evidência de widget test; validação manual e das
futuras telas consumidoras permanece para gates posteriores.

O ambiente foi comprovado com Git 2.52.0 e Flutter 3.44.1 reais no mesmo
processo. Cinco processos Dart residuais da tentativa anterior foram
encerrados, sem recriar shim. O teste focado então revelou um import ausente em
`AppMetricCard`; após a correção mínima, os 8 testes passaram. O analyze
concluiu com `No issues found!`.

Handoff Mefisto -> Van Gogh: `AUTHORIZED` para a Fase 2 em execução separada.

## Phase 2 implementation review

Handoff Van Gogh em 2026-09-18:

- shell e barra inferior simplificados sem alterar os quatro destinos, o
  `StatefulShellRoute`, o banner demo ou a seleção ativa;
- Drawer removido de Painel, Produtos e Vendas; Conta e Sair consolidados em
  Mais;
- logout continua usando `SessionActions`, incluindo cancelamento e confirmação
  quando existem operações pendentes, sem expor o termo interno `outbox`;
- edição local de nome deixou de ser exposta; o provider legado interno não
  foi removido para evitar ampliar esta fase para composition/session;
- TopBar não oferece mais busca global falsa, menu ou toggle de tema; a API de
  ações contextuais reais foi preservada;
- `Mais` oferece `Sistema | Claro | Escuro` pelo controller existente, sem nova
  persistência, e omite Estoque, Relatórios e linguagem de backlog;
- arquivos do Drawer, tile de módulo e teste obsoleto foram removidos; helper
  de decoração sem consumidor também foi eliminado;
- router funcional, Auth e camadas protegidas permanecem inalterados;
- testes focados foram preparados, sem execução, analyze, format, build ou
  goldens nesta fase.

Handoff Van Gogh -> Mefisto: `READY FOR AUTHORIZED REVIEW`. A Fase 3 não foi
iniciada.

## Gate 2 stabilization review

O Gate 2 executado externamente encontrou um warning real de código e três
fragilidades/expectativas obsoletas nos testes. O import morto do Dashboard foi
removido. Não foi encontrada regressão funcional no Shell, TopBar, Mais,
Dashboard ou Vendas.

- Settings (`C`): `ensureVisible` recebia finder vazio porque o item final do
  `ListView` ainda não estava materializado; o teste passou a rolar até `Sair`.
- Dashboard (`B`): `Atualização` era um rótulo histórico e não é mais
  renderizado. O fixture preserva `syncedAt` e a UI atual o apresenta por
  `KpiCard -> AppMetricCard` em dois metadados semânticos: `Sincronizado em,
  12/06/2026` e `Sincronizado às, 09:40`.
- Dashboard/restrição (`B`): há um único `DashboardKpi` financeiro restrito no
  fixture (`Receita prevista`, sem valor). A expectativa anterior de dois
  textos `Financeiro restrito` refletia composição visual antiga, não os dados.
- Sales/ícone (`C`): `find.byIcon` confundia ícones legítimos que compartilham
  o mesmo `IconData`; a ausência do Drawer agora é verificada no `Scaffold`.
- Sales/viewport (`C`): o `ListView` não é o tipo aceito por
  `scrollUntilVisible`. O cenário 320x700 agora encontra o `Scrollable`
  descendente de `SalesPage`, rola até `Adicionar produto`, confirma o centro
  na viewport e, após o toque, confirma o `TextField` do picker; não comprime
  a UI de produção.
- Drift: warnings preexistentes e não causais, mantidos fora do escopo.

Nenhuma validação foi executada nesta estabilização. Gate 2 permanece
`FAIL / pending revalidation`, e Auth continua não autorizada.

## Phase 3 implementation review

Status: `IMPLEMENTADA`.
Validation: `NOT_RUN`.
Gate 3: `FAIL / pending revalidation`.

- Startup foi refinada exclusivamente em presentation, mantendo a chamada a
  `restore()` e o retry existente;
- `AuthShell` concentra atmosfera, SafeArea, largura máxima, scroll com inset
  de teclado, marca e superfície sem assumir regra de autenticação;
- Login preserva `accessCode`, `password` e `deviceName`, reduzindo apenas o
  peso visual do dispositivo; Change Password preserva seus três argumentos e
  o logout do fluxo obrigatório;
- os controles de mostrar/ocultar senha são locais, acessíveis por tooltip e
  usam aliases de `AppIcons`; erros usam a mensagem segura do estado no
  `AppStatePanel`;
- testes de widget foram preparados e permanecem sem execução. Dashboard não
  foi iniciado.
- Estabilização: os erros conhecidos de compilação foram corrigidos sem mudar
  comportamento funcional; a aprovação depende da reexecução humana do Gate 3.
- A revalidação humana confirmou que os slices de app e analyze passam. Os
  resíduos de Auth foram limitados a isolamento do double, interação fora da
  viewport e reflow do CTA em texto ampliado; as correções permanecem sem nova
  execução nesta retomada.
- A estabilização seguinte corrigiu apenas o fechamento sintático do
  `Flexible` no CTA ocupado de Change Password, mantendo a contração do texto
  em scaler alto e sem alterar fluxo funcional.
- A evidência seguinte revelou somente uma vírgula excedente no mesmo trecho;
  removida sem alteração funcional. Gate 3 segue pendente de revalidação.

## Phase 4 implementation review

Estado: `IMPLEMENTADA`.
Gate 4: `NOT_RUN / pending validation`.
Validation: `NOT_RUN`.

- Dashboard foi alterado somente em presentation: hero operacional, hierarquia
  de métricas e metadata de sincronização;
- a restrição financeira continua usando o valor nulo/restrito real, sem
  substituir por valor financeiro inventado;
- gráficos preservam séries e cálculos existentes; estados local-first e ações
  de retry foram mantidos;
- testes focados foram atualizados, sem execução, analyze, format, build ou
  goldens. Catálogo não foi iniciado.

## Phase 5 implementation review

Estado: `IMPLEMENTADA`.
Gate 5: `NOT_RUN / pending validation`.
Validation: `NOT_RUN`.

- Gate 4 registrado como `PASS` e Fase 4 validada por evidência humana;
- Catálogo preserva busca real, controller, estados e conteúdo local;
- preço permitido deixou de usar badge; `price == null` permanece restrito e
  nenhum estoque foi inferido além do dado formal já exibido pelo Catálogo;
- testes foram atualizados sem execução. Vendas não foi iniciada.

## Audit review

## Batch Fases 5–8 implementation review

Validação consolidada: `NOT_RUN`.

- execução sequencial autorizada pelo responsável humano; Fase 9 permanece
  bloqueada até o gate consolidado;
- presentation de Vendas e Conta/Empresa foi humanizada sem mudança funcional;
- testes serão reexecutados no gate consolidado. Nenhum comando foi executado.

- [x] oito rotas atuais confirmadas;
- [x] shell de quatro destinos confirmada;
- [x] Drawer redundante e ações falsas confirmados;
- [x] base de tema/tokens/light/dark confirmada;
- [x] ausência de hero no Dashboard e sync em dois cards confirmadas;
- [x] Catálogo funcional e uso indevido de badge para preço confirmados;
- [x] fluxo persistente de Vendas confirmado;
- [x] `outbox`, `proposalJson` e `lastError` visíveis confirmados;
- [x] linguagem de backlog em Mais confirmada;
- [x] dados reais de Conta e linguagem técnica residual confirmados;
- [x] seis goldens canônicos inspecionados;
- [x] gaps de QA registrados;
- [x] decisões humanas aprovadas em 2026-09-18;
- [x] contrato FROZEN v1;
- [x] handoff Jarvis -> Van Gogh emitido;
- [x] implementação da Fase 1 revisada estaticamente;
- [x] Gate 1.5 aprovado;
- [ ] implementação da Fase 2 revisada por Mefisto;
- [ ] implementação das Fases 3–9 revisada;
- [ ] QA executado e verdict emitido.

## Retomada das Fases 6–8 — revisão de implementação

A execução anterior foi corretamente reclassificada como `PARCIAL`: a remoção
de linguagem técnica era válida, mas não substituía uma superfície de venda
orientada ao fluxo operacional.

A retomada introduz a separação estrutural Nova venda/Histórico na SalesPage,
com o controle segmentado compartilhado e sem nova rota. O draft não muda de
owner e permanece no controller durante a alternância. O Histórico apresenta
cliente, data/hora de `createdAt`, quantidade, valor autorizado e badge de
status, preservando Pendente diferente de Confirmada e a apresentação segura
de Revisão necessária.

Conta/Empresa agora hierarquiza conta conectada, empresa atual e acesso
disponível com dados existentes. A revisão transversal adicionou tooltips às
ações iconográficas de Vendas e ao retorno de Conta; os testes preparam 320 px
com scaler 2.0 para ambas as superfícies. Nenhum contrato ou comportamento de
negócio foi alterado.

Registro histórico: Validation `NOT_RUN`; Gate consolidado 5–8 `FAIL / pending
revalidation`; Fase 9 ainda não autorizada. Estado superado pelo `PASS` final.

### Estabilização de Sales — Gate consolidado 5–8

O `AppSegmentedControl` já materializa Nova venda e Histórico com rótulos
semânticos; o `Text` interno não é o contrato correto para interação de teste.
Sales não sofreu alteração de produção. O teste compacto agora só toca
Selecionar cliente depois de rolar o scroll principal da página e confirmar a
visibilidade; também confirma que o picker abriu. Naquela tentativa, o gate
seguia `FAIL / pending revalidation`; o resultado foi superado pelo `PASS` final.

## Residual risks

1. `DEBT-014-01`: detalhes da proposta exigem modelo estruturado futuro; risco aceito, sem parsing visual;
2. remoção do Drawer deve preservar logout e confirmação de pendências em Mais;
3. estoque no picker exigiria ampliar `SaleProductOption` e permanece fora da 014;
4. resolvido: o golden do Dashboard foi regenerado e aprovado com o foreground `onSurfaceHero`;
5. goldens podem gerar custo alto se pickers/estados transitórios forem incluídos sem estabilidade;
6. TalkBack e ordem de foco aguardam validação manual em aparelho/emulador.

## Jarvis closure

`done`

Próximo gate:

```text
nenhum bloqueante — Spec 014 encerrada após veredito Mefisto `passed_with_restrictions`;
TalkBack/ordem de foco permanece como check manual residual
```
