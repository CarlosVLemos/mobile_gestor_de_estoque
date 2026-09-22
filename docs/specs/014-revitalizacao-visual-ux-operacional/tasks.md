# Tasks — Spec 014

Status: `DONE — Gate consolidado 5–8: PASS; Fase 9: PASS`
Execution mode: `SINGLE_WRITER`

## Fechamento autoritativo — Fase 9

Estado autoritativo: Gate consolidado 5–8 `PASS`. Fase 9 `PASS`.

- O harness em `test/goldens/visual_goldens_test.dart` declara exatamente 18
  superfícies em 390×844: Shell, Login, Troca de senha, Dashboard, Catálogo,
  Nova venda, Histórico, Mais e Conta/Empresa, cada uma em claro e escuro.
- As superfícies usam fixtures e overrides estáveis. Startup, pickers e
  estados transitórios permanecem fora de golden.
- Os 18 baselines foram gerados, comparados e aprovados em revisão humana.
- O hero do Dashboard usa `onSurfaceHero` e Nova venda evidencia cliente,
  produtos, resumo e CTA no golden.
- Golden suite, análise estática e suíte completa: `PASS`.

As entradas anteriores de `FAIL / pending revalidation` registram tentativas
históricas das Fases 5–8 e são preservadas como histórico, não como estado atual.
Validation mode: `FULL` no fechamento, sempre sujeito à autorização explícita

## Registro histórico de estabilização — não autoritativo

Na estabilização anterior, segmentos de Sales passaram a usar Keys de presentation no elemento
interativo (`sales-segment-new` e `sales-segment-history`); Semantics é
validada isoladamente no design system. O fluxo compacto usa `ensureVisible` e
`hitTestable`, sem resolver Scrollable ou coordenadas manualmente. Gate
consolidado 5–8 estava `FAIL / pending revalidation` naquela tentativa.

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

Gate 2: `FAIL / pending revalidation`. Nenhuma validação foi executada nesta
retomada.
Validation: `NOT_RUN`.

- [x] Classificar a falha responsiva de Mais como teste frágil (`C`).
- [x] Fazer o teste rolar até a ação real `Sair` antes da asserção.
- [x] Classificar a expectativa `Atualização` como teste obsoleto (`B`): a UI
  atual apresenta a sincronização em dois cards, não sob esse rótulo histórico.
- [x] Alinhar o teste do Dashboard aos metadados semânticos do fixture:
  `Sincronizado em, 12/06/2026` e `Sincronizado às, 09:40`.
- [x] Corrigir a restrição financeira para uma ocorrência: o fixture possui um
  único KPI financeiro restrito.
- [x] Remover o import de `AppIcons` não utilizado no Dashboard.
- [x] Classificar o finder global de ícone em Vendas como frágil (`C`).
- [x] Provar estruturalmente que `Scaffold.drawer` é nulo.
- [x] Rolar explicitamente o `ListView` compacto até `Adicionar produto`,
  usando o `Scrollable` descendente de `SalesPage`; confirmar visibilidade,
  tocar e confirmar que o picker abriu.
- [ ] Reexecutar o Gate 2 completo com autorização humana.

## Fase 3 — Auth

- [x] Revitalizar Startup sem mudar restauração/retry.
- [x] Criar composição visual coerente entre Login e Change Password.
- [x] Adicionar show/hide de senha com semântica adequada.
- [x] Configurar foco, teclado e autofill aplicáveis.
- [x] Preservar campos, validações, loading, erro, logout e fluxo obrigatório.

Estado: `IMPLEMENTADA`.
Validation: `NOT_RUN`.
Gate 3: `FAIL / pending revalidation`.

Estabilização do Gate 3: removido `const` inválido de `Semantics`, substituído
o hint inexistente de senha atual por `AutofillHints.password` e estabilizados
os testes de visibilidade com Keys de presentation e `EditableText`.

Revalidação humana encontrou taps fora da viewport, reutilização indevida do
double entre estados e overflow dos CTAs em scaler alto. A correção preparada
recria o `ProviderScope` por cenário, torna os taps visíveis e permite que o
texto ocupado do CTA se contraia sem overflow.

Estabilização sintática: fechado corretamente o `Text`, o `Flexible` e o `Row`
do CTA ocupado de Change Password. Gate 3 permanece pendente de revalidação.
Uma vírgula de fechamento excedente foi removida após a evidência do analyzer.

## Fase 4 — Dashboard

- [x] Criar hero navy usando somente dados existentes.
- [x] Reorganizar KPIs e seções na hierarquia contratada.
- [x] Converter última sincronização em metadata.
- [x] Preservar restrição financeira e estados local-first.
- [x] Não inventar tendências, metas, valores ou comparações.

Estado: `IMPLEMENTADA`.
Gate 4: `NOT_RUN / pending validation`.
Validation: `NOT_RUN`.

Evidência humana posterior: Fase 4 `VALIDADA`; Gate 4: `PASS`.

## Fase 5 — Catálogo

- [x] Refinar busca/filtros/chips sem mudar comportamento.
- [x] Recompor `ProductCard` para separar estado de informação.
- [x] Preservar `price = null`, estoque, venda disponível e permissões.
- [x] Preservar conteúdo local em offline/refresh/failure.

Estado: `IMPLEMENTADA`.
Gate 5: `NOT_RUN / pending validation`.
Validation: `NOT_RUN`.

Cadência humana aprovada: Fases 5–8 seguem sequencialmente sem gates
individuais; a validação ocorrerá no gate consolidado após a Fase 8.

## Fases 6–8 — batch de revitalização

- [x] Humanizar resumo/histórico de Vendas e ocultar JSON/erros técnicos.
- [x] Humanizar Conta/Empresa e remover módulos sem utilidade operacional.
- [x] Preservar estados semânticos compartilhados nas superfícies alteradas.

Estado da primeira execução: `PARCIAL`.
Validação consolidada 5–8: `NOT_RUN`.

Motivo do estado parcial: a primeira execução privilegiou microcopy, remoção
de jargão e ocultação segura de dados técnicos, mas não completou as superfícies
operacionais de Vendas, Conta/Empresa e acessibilidade.

## Fase 6 — Vendas

- [x] Recompor o fluxo de criação pela sequência do vendedor.
- [x] Distinguir Nova venda e Histórico dentro da rota atual.
- [x] Usar controle segmentado e preservar draft durante a alternância.
- [x] Exibir `createdAt` já disponível no histórico.
- [x] Refinar pickers de cliente/produto.
- [x] Remover linguagem `outbox`.
- [x] Mapear status para copy operacional sem alterar enum/semântica.
- [x] Substituir JSON/erro cru por “Revisão necessária” e explicação genérica aprovada.
- [x] Preservar aceite com revisão vigente e sem autoaceite.
- [x] Preservar o use case, persistência, outbox e confirmação remota.

## Fase 7 — Conta / Empresa

- [x] Refinar Conta/Empresa sobre a estrutura consolidada em Mais.
- [x] Traduzir tenant/features/servidor para linguagem de produto.
- [x] Preservar dados reais e regras de permissão.

## Fase 8 — Estados e acessibilidade

- [x] Avaliar skeletons em Dashboard, Catálogo, Histórico e Conta; não foi criada abstração nova sem reuso comprovado.
- [x] Cobrir todos os estados aplicáveis sem esconder cache válido.
- [x] Revisar 320x700 e text scaler 2.0.
- [x] Revisar light/dark, contraste e semântica além da cor.
- [x] Revisar foco, teclado, scroll, tooltips e touch targets.
- [x] Aplicar motion apenas a transições funcionais.

## Fase 9 — Goldens / QA

- [x] Consolidar o harness determinístico de 18 goldens em 390×844: nove superfícies em claro/escuro.
- [x] Cobrir Shell, Login, Troca de senha, Dashboard, Catálogo, Nova venda, Histórico, Mais e Conta/Empresa.
- [x] Usar fixtures e overrides locais; pickers, Startup e estados transitórios seguem como widget/manual checks, não goldens.
- [x] Gerar os 18 baselines e revisar visualmente todas as superfícies.
- [x] Corrigir o contraste do hero do Dashboard e capturar o CTA de Nova venda.
- [x] Executar golden suite, análise estática e suíte completa com resultado `PASS`.

## Fase 10 — Review e fechamento

- [x] Van Gogh entrega handoff curto com paths, decisões e riscos.
- [x] Mefisto compara diff contra o contrato FROZEN.
- [x] Mefisto registra resultados reais em `validation-result.md`.
- [x] Mefisto emite `passed`.
- [x] Jarvis registra riscos residuais e fecha a Spec após o veredito.

## Histórico — Parallel now

Fase 2 implementada em `SINGLE_WRITER`. Nenhuma outra fase de implementação
deve avançar sobre os mesmos paths antes do handoff/review desta fase.

## Histórico — Blocked by handoff

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

## Retomada das Fases 6–8 — 2026-09-22

A primeira execução do batch foi registrada como `PARCIAL`: predominavam
microcopy e remoção de jargão, sem completar os objetivos de UX operacional.
Nesta retomada, Vendas passou a usar `AppSegmentedControl` para separar Nova
venda e Histórico na mesma rota, preservando o draft no controller existente.
Histórico passa a apresentar `createdAt`; Conta/Empresa foi reorganizada em
identidade, empresa atual e acesso; e tooltips foram adicionados às ações por
ícone de Vendas e Conta. Testes focados foram atualizados, mas não executados.

Estado histórico após aquela implementação: Fases 6–8 `IMPLEMENTADAS / pending validation`.
Naquele momento, o Gate consolidado 5–8 estava `FAIL / pending revalidation`
e a Fase 9 não estava autorizada. Estado superado pelo `PASS` final.

### Estabilização do Gate consolidado 5–8

Resultado humano: `FAIL / pending revalidation`, limitado a dois cenários de
Sales. A opção Histórico estava renderizada pelo controle segmentado, mas os
testes dependiam de seu `Text` interno; foram migrados para o rótulo semântico
do segmento. O cenário 320x700 agora rola o `Scrollable` descendente único de
`SalesPage` até Selecionar cliente, confirma que o alvo está na viewport, toca
e verifica a abertura do picker antes de continuar.

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
