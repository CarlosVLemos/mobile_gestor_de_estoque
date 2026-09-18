# Test Plan — Spec 014

Status: `GATE 2 FAIL — CORRECTIONS PREPARED, REVALIDATION PENDING`
Execução nesta missão: nenhuma; correções estáticas preparadas a partir da evidência humana

## Objetivo

Provar que a revitalização melhora hierarquia, linguagem, navegação,
responsividade e acessibilidade sem mudar autenticação, contratos, dados,
outbox, confirmação remota ou boundaries arquiteturais.

## Test matrix

| ID | Scenario | Level | Expected | Evidence |
| --- | --- | --- | --- | --- |
| QA-014-01 | Startup/Login/Change Password: loading, erro/retry, show-hide, fluxo obrigatório e logout | widget/router | contratos de Auth preservados; sem política inventada | `NOT_RUN` |
| QA-014-02 | Shell e navegação entre Painel/Produtos/Vendas/Mais | widget/router | rotas/seleção preservadas; Drawer ausente; Conta/Sair em Mais; logout pendente preservado | `NOT_RUN` |
| QA-014-03 | Dashboard em todos os estados | widget | hero/hierarquia corretos; sync como metadata; cache preservado | `NOT_RUN` |
| QA-014-04 | Catálogo: busca, filtros, categorias, preço, estoque e estados | widget/controller | comportamento preservado; `price = null` restrito; badge somente para estado | `NOT_RUN` |
| QA-014-05 | `Nova venda | Histórico` e criação: cliente -> produtos -> quantidades -> resumo -> registro | widget/application | draft sobrevive à troca; IDs/use case preservados; pendente != confirmado; sem `outbox` | `NOT_RUN` |
| QA-014-06 | Histórico de vendas | widget/application | separado visualmente; cliente/data/itens/total permitido/estado/ação compreensíveis | `NOT_RUN` |
| QA-014-07 | Proposal/acceptance | widget/application | “Revisão necessária”; aceite usa revisão vigente; JSON/`proposalJson`/`lastError`/erro técnico ausentes | `NOT_RUN` |
| QA-014-08 | Mais e Conta | widget | Conta/Sair e seletor de tema presentes; módulos inexistentes, backlog e termos técnicos ausentes | `NOT_RUN` |
| QA-014-09 | superfícies críticas em 320x700 e text scaler 2.0 | widget responsivo | sem overflow; scroll, foco, teclado, segmentação e pickers utilizáveis | `NOT_RUN` |
| QA-014-10 | seletor Sistema/Claro/Escuro e temas | widget/theme | três `ThemeMode` representados sem persistência nova; contraste válido | `NOT_RUN` |
| QA-014-11 | loading/ready/empty/restricted/offline/refreshing/failure e motion | widget | transições moderadas; refresh/falha/offline não apagam dados locais | `NOT_RUN` |
| QA-014-12 | baseline e expansão visual | golden | exatamente 18 referências: nove superfícies em claro/escuro | `NOT_RUN` |
| QA-014-13 | boundaries, estrutura e ícones | architecture | nenhuma alteração incidental fora dos paths; Lucide encapsulado | `NOT_RUN` |
| QA-014-14 | análise estática | static | zero erros/lints introduzidos | `NOT_RUN` |
| QA-014-15 | regressão completa | full suite | suíte completa aprovada somente no fechamento | `NOT_RUN` |
| QA-014-16 | TalkBack/semântica, foco, teclado, touch target e contraste | manual accessibility | controles compreensíveis e operáveis em dispositivo/emulador autorizado | `NOT_RUN` |

## Baseline confirmado

Goldens canônicos atuais, todos 390x844:

```text
test/goldens/goldens/shell_claro.png
test/goldens/goldens/shell_escuro.png
test/goldens/goldens/dashboard_claro.png
test/goldens/goldens/dashboard_escuro.png
test/goldens/goldens/catalogo_claro.png
test/goldens/goldens/catalogo_escuro.png
```

`test/goldens/failures/**` nunca é baseline desejado.

## Golden target aprovado

Exatamente nove superfícies em claro/escuro, totalizando 18 referências:

```text
Shell
Login
Change Password
Dashboard
Catálogo
Vendas — Nova venda
Vendas — Histórico
Mais
Conta/Empresa
```

Startup, pickers, offline, error, empty e componentes isolados permanecem em
widget tests focados.

## Mudanças esperadas na cobertura

- criar widget tests próprios para Startup/Login/Change Password;
- provar navegação real entre os quatro destinos e ausência de redundância;
- substituir asserts que exigem `SINCRONIZADO EM/ÀS` como dois KPI cards;
- adicionar Catálogo de página completa em 320 px, scaler alto e dark;
- cobrir histórico, labels humanos e proposal/acceptance;
- adicionar asserts negativos para `outbox`, JSON cru e erro técnico;
- provar `createdAt` no histórico e ausência de estoque inventado no picker;
- provar draft preservado ao alternar `Nova venda | Histórico`;
- provar `Sistema | Claro | Escuro` sem persistência nova;
- substituir asserts que exigem `Fora do escopo`, `tenant` e backlog;
- ampliar paridade light/dark e semântica/foco/teclado.

## Static checks

Executado e aprovado no Gate 1.5:

```bash
flutter analyze --no-pub
```

## Focused tests

### Gate 2 observado e correções preparadas

- `test/shared/widgets`: `+25`, aprovado; sem alteração corretiva.
- `test/features/settings`: falha no alvo ainda não materializado do `ListView`;
  o teste agora usa `scrollUntilVisible` até `Sair`.
- `test/features/dashboard`: expectativa visual antiga `ATUALIZAÇÃO`; o teste
  agora verifica `Atualização`, mantendo a informação funcional.
- `test/features/sales`: finder global por `IconData` substituído por inspeção
  de `Scaffold.drawer`; taps em `Adicionar produto` agora respeitam a viewport.
- `test/features/catalog`: `+27`, aprovado; sem alteração corretiva.
- analyze: import não utilizado removido de `dashboard_page.dart`.
- warnings Drift sobre `AppDatabase`/`QueryExecutor`: preexistentes e não
  bloqueantes; nenhuma camada protegida foi alterada.

Reexecutar exatamente, sem ampliar o gate:

```bash
flutter test --no-pub test/shared/widgets
flutter test --no-pub test/features/settings
flutter test --no-pub test/features/dashboard
flutter test --no-pub test/features/catalog
flutter test --no-pub test/features/sales
flutter analyze --no-pub
```

Comando focado preparado para a Fase 2, não executado por ausência de
autorização no contexto atual:

```bash
flutter test --no-pub test/shared/widgets/operational_widgets_test.dart test/features/settings/more_page_test.dart test/app/app_controllers_test.dart test/features/dashboard/dashboard_page_test.dart test/features/catalog/catalog_page_test.dart test/features/sales/sales_page_test.dart
```

Cobertura preparada: quatro destinos, estado ativo e toque da navegação;
ausência de Drawer/busca global/toggle nas top bars; identidade e capacidades
reais em Mais; rota existente de Conta/Empresa; três `ThemeMode`; logout
simples, cancelamento e confirmação com pendências; ausência de `outbox` na
copy; reflow de Mais em 320x700 com text scaler 2.0.

Executar somente após autorização explícita, na ordem proporcional à fase:

```bash
flutter test --no-pub test/shared/widgets/design_system_components_test.dart test/shared/widgets/operational_widgets_test.dart test/shared/widgets/animated_state_switcher_test.dart
flutter test --no-pub test/app/arara_app_test.dart test/features/auth
flutter test --no-pub test/shared test/features/dashboard test/features/catalog
flutter test --no-pub test/features/sales
flutter test --no-pub test/features/settings test/theme
flutter test --no-pub test/architecture
```

Demais comandos da lista: `NOT_RUN`. O teste isolado da Fase 1 está registrado
abaixo como `PASS`.

### Evidência do Gate 1.5 — 2026-09-18

Comando autorizado:

```bash
flutter test --no-pub test/shared/widgets/design_system_components_test.dart
```

Resultado anterior: `BLOCKED`, posteriormente resolvido na retomada do gate.

1. a primeira tentativa encerrou antes da compilação com
   `Error: Unable to find git in your PATH.`;
2. Git existia e respondia por caminho absoluto, mas o `where.exe` usado por
   `flutter.bat` não o encontrou no perfil do usuário;
3. um shim temporário no workspace permitiu iniciar o launcher, mas o processo
   não emitiu saída nem resultado após aproximadamente dois minutos;
4. o processo foi interrompido conforme o orçamento de terminal e o shim foi
   removido;
5. `flutter analyze --no-pub` permaneceu `NOT_RUN`, pois a condição anterior do
   gate não foi satisfeita.

Não houve execução de suíte completa, build, format ou goldens.

### Retomada do Gate 1.5 — 2026-09-18

Ambiente comprovado no mesmo processo:

```text
Git: C:\Users\carlos.silva\AppData\Local\Programs\Git\cmd\git.exe
Git version: 2.52.0.windows.1
Flutter: C:\Users\carlos.silva\src\flutter\bin\flutter.bat
Flutter version: 3.44.1 stable
Dart: 3.12.1
```

Cinco processos Dart residuais da tentativa anterior foram identificados por
PID/start time/path e encerrados. Nenhum shim foi recriado.

O primeiro teste válido encontrou um import ausente em `AppMetricCard`. Após a
correção mínima, a repetição autorizada concluiu:

```text
flutter test --no-pub test/shared/widgets/design_system_components_test.dart
00:01 +8: All tests passed!
```

Análise estática:

```text
flutter analyze --no-pub
No issues found! (ran in 19.1s)
```

Resultado do Gate 1.5: `PASS`.

## Golden checks

Comparação sem atualizar baseline:

```bash
flutter test --no-pub test/goldens/visual_goldens_test.dart
```

Somente depois da aprovação humana explícita do novo visual:

```bash
flutter test --no-pub --update-goldens test/goldens/visual_goldens_test.dart
flutter test --no-pub test/goldens/visual_goldens_test.dart
```

A atualização deve ser seguida por inspeção humana das imagens. Todos:
`NOT_RUN`.

## Integration/manual checks

- navegar por todas as rotas atuais com sessão autenticada;
- confirmar fluxo obrigatório de troca de senha e logout;
- usar Nova venda e Histórico com dados persistidos;
- validar venda pendente, confirmada, retry, falha permanente, revisão e cancelada;
- validar fallback de proposta sem JSON cru;
- testar teclado em Auth e pickers;
- testar TalkBack/ordem de foco/touch targets;
- revisar contraste e densidade em light/dark;
- confirmar banner demo e ausência dele em normal.

Status: `NOT_RUN`.

## Full-suite gate

Somente no fechamento/merge e após autorização explícita:

```bash
flutter test --no-pub
```

Status: `NOT_RUN`.

## Gate de aprovação

Mefisto só pode emitir `passed` quando:

- AC-014-01 a AC-014-28 possuem evidência;
- diff respeita o contrato FROZEN e paths;
- testes focados e arquitetura passam;
- goldens foram aprovados visualmente antes da atualização;
- análise estática passa;
- suíte completa passa no fechamento autorizado;
- riscos de proposta estruturada e acessibilidade manual estão resolvidos ou
  registrados com restrição explícita.
