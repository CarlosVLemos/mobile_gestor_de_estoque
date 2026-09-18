# Review — Spec 014

Status: `IN_PROGRESS — GATE 2 FAIL, REVALIDATION PENDING`

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
- Dashboard (`B`): a informação continua presente como `Atualização`; apenas
  a expectativa de uppercase pertencia à apresentação anterior.
- Sales/ícone (`C`): `find.byIcon` confundia ícones legítimos que compartilham
  o mesmo `IconData`; a ausência do Drawer agora é verificada no `Scaffold`.
- Sales/viewport (`C`): os testes agora trazem `Adicionar produto` à viewport
  antes do toque, sem comprimir a UI de produção.
- Drift: warnings preexistentes e não causais, mantidos fora do escopo.

Nenhuma validação foi executada nesta estabilização. Gate 2 permanece
`FAIL / pending revalidation`, e Auth continua não autorizada.

## Audit review

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

## Residual risks

1. `DEBT-014-01`: detalhes da proposta exigem modelo estruturado futuro; risco aceito, sem parsing visual;
2. remoção do Drawer deve preservar logout e confirmação de pendências em Mais;
3. estoque no picker exigiria ampliar `SaleProductOption` e permanece fora da 014;
4. o golden armazenado do Dashboard pode estar defasado da fonte e precisa de gate autorizado;
5. goldens podem gerar custo alto se pickers/estados transitórios forem incluídos sem estabilidade;
6. escopo transversal exige revisões por fase para manter o diff auditável.

## Jarvis closure

`in_progress`

Próximo gate:

```text
autorização explícita
-> Mefisto: review e testes focados da Fase 2
-> handoff para Van Gogh: Fase 3 — Auth
```
