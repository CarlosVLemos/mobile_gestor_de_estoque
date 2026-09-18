# Tasks — Spec 014

Status: `IN_PROGRESS — GATE 2 FAIL, CORRECTIONS PREPARED`
Execution mode: `SINGLE_WRITER`
Validation mode: `FULL` no fechamento, sempre sujeito à autorização explícita

## Ownership

| Fase | Task | Owner | Paths | Depends on |
| --- | --- | --- | --- | --- |
| 0 | auditoria, escopo, contrato e decisões | Jarvis + Van Gogh | docs da 014; leitura de produção/testes | — |
| 0 | matriz de risco e QA | Mefisto | `test/**` e docs da 014, leitura | auditoria |
| 1 | sistema visual compartilhado | Van Gogh | `lib/app/theme/**`, `lib/shared/widgets/**` | contrato FROZEN |
| 2 | Shell, TopBar e Mais | Van Gogh | shared e settings presentation | fase 1 |
| 3 | Startup/Login/Change Password | Van Gogh | startup e auth presentation | fase 2 |
| 4 | Dashboard | Van Gogh | dashboard presentation | fases 1–2 |
| 5 | Catálogo | Van Gogh | catalog presentation | fases 1–2 |
| 6 | Vendas, pickers e histórico | Van Gogh | sales presentation | fases 1–2 + decisão de proposta |
| 7 | Conta/Empresa | Van Gogh | settings presentation | fases 1–2 |
| 8 | estados, responsividade e acessibilidade | Van Gogh | paths de presentation/shared autorizados | fases 3–7 |
| 9 | testes e goldens | Van Gogh prepara; Mefisto revisa/valida | paths de testes autorizados | fases 1–8 |
| 10 | review, veredito e fechamento | Mefisto -> Jarvis | docs da 014 | QA autorizado e concluído |

## Fase 0 — Auditoria e contrato

- [x] Ler bootstrap, arquitetura, interface, decisões, design blueprint e templates.
- [x] Confirmar as oito rotas no router atual.
- [x] Auditar Startup, Auth, Dashboard, Catálogo, Vendas, Mais e Conta.
- [x] Auditar shell, Drawer, top bar e componentes compartilhados.
- [x] Auditar tema, tokens, motion e ícones.
- [x] Inspecionar os seis goldens canônicos; ignorar `failures/**`.
- [x] Confirmar problemas observados com evidência no código.
- [x] Registrar gaps e contradições em `spec.md`.
- [x] Criar contrato Version 1 como `DRAFT`.
- [x] Obter decisões e aprovação humana em 2026-09-18.
- [x] Alterar explicitamente o contrato para `FROZEN`, Version 1.
- [x] Emitir handoff Jarvis -> Van Gogh.

## Fase 1 — Design system compartilhado

- [x] Revisar tokens e manter identidade aceita.
- [x] Consolidar métrica, busca, segmentação, estado e sync metadata somente onde houver reuso real ou consumidor já contratado.
- [x] Preservar Lucide por `AppIcons`.
- [x] Preservar touch targets e motion moderado pelos tokens existentes.
- [x] Não criar abstrações sem dois consumidores reais ou justificativa forte.

Entregue nesta fase:

- `AppStatePanel` como base semântica para empty/failure/restricted/offline/info,
  mantendo os wrappers públicos existentes;
- `AppMetricCard` com hierarquia primary/secondary/compact, mantendo `KpiCard`
  como fachada compatível;
- `AppSearchField`, `AppSegmentedControl` e `AppSyncIndicator` preparados para
  os consumidores já contratados nas fases de Catálogo/Vendas/Dashboard;
- sem criar `AppPageHeader`, `AppHeroCard`, skeleton ou nova composição de
  `ProductCard` antes de seus consumidores serem implementados;
- testes focados preparados em
  `test/shared/widgets/design_system_components_test.dart`; 8 testes aprovados
  no Gate 1.5.

## Gate 1.5 — Mefisto

- [x] Revisar estaticamente o diff da Fase 1 contra o contrato FROZEN.
- [x] Confirmar API pública de `KpiCard` e wrappers anteriores preservados.
- [x] Confirmar ausência de imports de domain/application/data/core nos novos widgets.
- [x] Confirmar uso de `AppDurations`, `AppCurves`, tokens light/dark e touch target de 48 px.
- [x] Obter PASS no teste focado da Fase 1 — 8 testes aprovados.
- [x] Executar `flutter analyze --no-pub` — nenhum issue encontrado.
- [x] Autorizar handoff Mefisto -> Van Gogh para a Fase 2 em execução separada.

Resultado do gate: `PASS`. O bloqueio de ambiente foi resolvido sem shim por
execução no ambiente em que Git e Flutter reais são visíveis. A Fase 2 foi
implementada em execução separada e aguarda revisão/QA explicitamente
autorizados.

## Fase 2 — Shell / TopBar / Mais

- [x] Preservar quatro destinos e rotas atuais.
- [x] Remover Drawer das páginas principais.
- [x] Migrar Conta e Sair para Mais, preservando confirmação de logout com pendências.
- [x] Remover “Alterar nome” da UI.
- [x] Remover buscas falsas.
- [x] Remover toggle de tema das top bars.
- [x] Implementar seletor `Sistema | Claro | Escuro` em Mais, sem persistência nova.
- [x] Ocultar módulos inexistentes e toda linguagem de backlog.
- [x] Garantir ações contextuais reais e sem redundância.
- [x] Preservar banner demo e seleção da rota ativa.
- [x] Corrigir apenas comentários obsoletos do router, sem mudança funcional.

Entregue nesta fase:

- shell sem vidro/blur, com quatro destinos e seleção ativa preservados;
- Drawer removido e arquivos sem consumidores eliminados;
- TopBar reduzida a título, subtítulo e ações contextuais reais;
- `Mais` com identidade real disponível, Conta/Empresa, seletor de tema e
  logout seguro com confirmação de operações pendentes;
- buscas globais falsas, edição local de nome, módulos inexistentes e
  linguagem de backlog removidos da UI;
- testes focados preparados, sem execução nesta fase.

### Estabilização do Gate 2

- [x] Classificar a falha responsiva de Mais como teste frágil (`C`).
- [x] Fazer o teste rolar até a ação real `Sair` antes da asserção.
- [x] Classificar a expectativa `ATUALIZAÇÃO` como teste obsoleto (`B`).
- [x] Alinhar o teste do Dashboard à copy semântica `Atualização`.
- [x] Remover o import de `AppIcons` não utilizado no Dashboard.
- [x] Classificar o finder global de ícone em Vendas como frágil (`C`).
- [x] Provar estruturalmente que `Scaffold.drawer` é nulo.
- [x] Levar `Adicionar produto` à viewport antes dos taps dos testes.
- [ ] Reexecutar o Gate 2 completo com autorização humana.

## Fase 3 — Auth

- [ ] Revitalizar Startup sem mudar restauração/retry.
- [ ] Criar composição visual coerente entre Login e Change Password.
- [ ] Adicionar show/hide de senha com semântica adequada.
- [ ] Configurar foco, teclado e autofill aplicáveis.
- [ ] Preservar campos, validações, loading, erro, logout e fluxo obrigatório.

## Fase 4 — Dashboard

- [ ] Criar hero navy usando somente dados existentes.
- [ ] Reorganizar KPIs e seções na hierarquia contratada.
- [ ] Converter última sincronização em metadata.
- [ ] Preservar restrição financeira e estados local-first.
- [ ] Não inventar tendências, metas, valores ou comparações.

## Fase 5 — Catálogo

- [ ] Refinar busca/filtros/chips sem mudar comportamento.
- [ ] Recompor `ProductCard` para separar estado de informação.
- [ ] Preservar `price = null`, estoque, venda disponível e permissões.
- [ ] Preservar conteúdo local em offline/refresh/failure.

## Fase 6 — Vendas

- [ ] Recompor o fluxo de criação pela sequência do vendedor.
- [ ] Distinguir Nova venda e Histórico dentro da rota atual.
- [ ] Usar controle segmentado e preservar draft durante a alternância.
- [ ] Exibir `createdAt` já disponível no histórico.
- [ ] Refinar pickers de cliente/produto.
- [ ] Remover linguagem `outbox`.
- [ ] Mapear status para copy operacional sem alterar enum/semântica.
- [ ] Substituir JSON/erro cru por “Revisão necessária” e explicação genérica aprovada.
- [ ] Preservar aceite com revisão vigente e sem autoaceite.
- [ ] Preservar o use case, persistência, outbox e confirmação remota.

## Fase 7 — Conta / Empresa

- [ ] Refinar Conta/Empresa sobre a estrutura consolidada em Mais.
- [ ] Traduzir tenant/features/servidor para linguagem de produto.
- [ ] Preservar dados reais e regras de permissão.

## Fase 8 — Estados e acessibilidade

- [ ] Avaliar skeletons em Dashboard, Catálogo, Histórico e Conta.
- [ ] Cobrir todos os estados aplicáveis sem esconder cache válido.
- [ ] Revisar 320x700 e text scaler 2.0.
- [ ] Revisar light/dark, contraste e semântica além da cor.
- [ ] Revisar foco, teclado, scroll, tooltips e touch targets.
- [ ] Aplicar motion apenas a transições funcionais.

## Fase 9 — Goldens / QA

- [ ] Atualizar testes que cristalizam sync como dois KPIs.
- [ ] Atualizar testes que exigem `Fora do escopo` e `tenant` na UI.
- [ ] Adicionar testes Auth, navegação, Histórico e proposta/aceite.
- [ ] Adicionar asserts negativos para linguagem técnica proibida.
- [ ] Manter os seis goldens existentes até aprovação visual da implementação.
- [ ] Consolidar exatamente 18 goldens: nove superfícies em claro/escuro.
- [ ] Cobrir Startup, pickers e estados especiais com widget tests, não goldens.
- [ ] Não executar nem atualizar goldens sem autorização explícita.
- [ ] Executar os gates de `test.md` somente quando autorizados.

## Fase 10 — Review e fechamento

- [ ] Van Gogh entrega handoff curto com paths, decisões e riscos.
- [ ] Mefisto compara diff contra o contrato FROZEN.
- [ ] Mefisto registra resultados reais em `validation-result.md`.
- [ ] Mefisto emite `passed`, `failed`, `blocked` ou `passed_with_restrictions`.
- [ ] Jarvis registra riscos residuais e fecha somente após o veredito.

## Parallel now

Fase 2 implementada em `SINGLE_WRITER`. Nenhuma outra fase de implementação
deve avançar sobre os mesmos paths antes do handoff/review desta fase.

## Blocked by handoff

- Fase 2 aguarda revisão e validação autorizada por Mefisto;
- detalhes estruturados da proposta permanecem dívida funcional aceita, não
  bloqueio da 014;
- atualização efetiva dos goldens permanece bloqueada até aprovação humana do
  visual implementado;
- validações futuras fora do Gate 1.5 continuam dependentes de autorização
  explícita separada.

## Critical path

```text
contrato FROZEN v1
-> design system compartilhado
-> Shell / TopBar / Mais
-> Auth
-> Dashboard
-> Catálogo
-> Vendas / Histórico
-> Conta / Empresa
-> estados / acessibilidade
-> testes/goldens preparados
-> autorização explícita de QA
-> Mefisto: focados -> arquitetura -> goldens -> analyze -> suíte final
-> veredito
-> fechamento por Jarvis
```

## Handoffs

- Jarvis -> Van Gogh: `ISSUED` em 2026-09-18; contrato FROZEN v1, paths e decisões aprovadas.
- Van Gogh — Fase 1: `COMPLETE` em 2026-09-18; validação focada aprovada no Gate 1.5.
- Mefisto — Gate 1.5: `PASSED` em 2026-09-18; teste focado e analyze aprovados.
- Mefisto -> Van Gogh — Fase 2: `AUTHORIZED` para execução separada.
- Van Gogh — Fase 2: `IMPLEMENTED, QA NOT_RUN` em 2026-09-18; handoff para
  Mefisto preparado sem avançar para Auth.
- Jarvis -> Maquiavel: não aplicável; usar somente se surgir dependência remota real.
- Van Gogh -> Mefisto: diff, testes alterados, decisões, gaps e riscos; sem declarar QA aprovada.
- Mefisto -> Jarvis: resultados, origem da evidência, veredito e riscos residuais.
