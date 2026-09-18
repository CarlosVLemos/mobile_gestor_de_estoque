# Contract — Spec 014

Status: `FROZEN`
Version: 1
Mode: `CRITICAL`
Execution mode: `SINGLE_WRITER`
Human approval / freeze date: 2026-09-18 — decisões explícitas do gate humano

> Contrato congelado após aprovação humana. Mudança de escopo, paths,
> navegação funcional, contrato ou invariantes exige Change Request explícito.

## Objetivo

Contratar a revitalização visual e de UX das superfícies existentes sem mudar
comportamentos funcionais, contratos remotos, persistência, domínio ou
arquitetura local-first.

## Remote contract

Nenhuma alteração de endpoint, payload, ID, paginação, checkpoint, erro,
permissão, feature, tenant scope, autenticação, token, idempotência ou retry é
autorizada por esta Spec.

- routes: inalteradas;
- request: inalterado;
- response: inalterado;
- IDs/types: inalterados;
- pagination/checkpoint: inalterados;
- errors: códigos e semântica inalterados; somente apresentação humana pode ser refinada;
- permissions/features: inalteradas e ainda soberanas remotamente;
- tenant scope: inalterado;
- idempotency/retry: inalterados.

Qualquer necessidade remota interrompe a parte afetada, registra gap e aciona
Maquiavel. Depois do freeze, mudança indispensável exige Change Request.

## Local contract

- entities/schema: nenhuma entidade, tabela, coluna ou enum persistido pode mudar;
- source of truth: UI continua lendo estado de aplicação/local; servidor continua soberano para autorização, estoque, preço e confirmação;
- persistence/isolation: banco físico por `userId + tenantId` permanece inalterado;
- migrations: nenhuma migration, `schemaVersion` ou codegen Drift;
- sync/outbox: engine, lifecycle, checkpoints, locks, payloads, status e protocolo de aceite permanecem inalterados;
- auth/session: `UserSession`, secure storage, redirects e troca obrigatória de senha permanecem inalterados;
- demo: sessão/banco/gateway demo continuam isolados e o banner permanece explícito.

## Contratos funcionais preservados

1. `Page -> Controller -> UseCase -> Repository -> DAO/API` continua obrigatório.
2. Presentation não acessa Dio/Drift e não interpreta transporte remoto.
3. Application não conhece widgets, Dio, Drift ou JSON.
4. Domain não conhece Flutter, persistência ou transporte.
5. rotas atuais e redirects de auth são preservados;
6. busca e filtro reais do Catálogo são preservados;
7. clientes/produtos reais, carrinho e `RegisterSaleUseCase` são preservados;
8. venda local/outbox permanece atômica e pendente não equivale a confirmada;
9. aceite continua usando a revisão vigente e nunca é automático;
10. `price = null` continua sendo restrição válida, não erro;
11. dados locais não desaparecem durante refresh/falha remota aplicável;
12. permissões orientam UX, mas não substituem autorização remota;
13. runtime demo não vira fallback para falha normal.

## Navigation contract

Rotas preservadas:

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

Navegação primária:

```text
Painel | Produtos | Vendas | Mais
```

Decisão congelada:

- remover Drawer das quatro páginas principais;
- realocar Conta e Sair para Mais, preservando a confirmação de logout com
  outbox pendente;
- remover “Alterar nome” da UI;
- mover Aparência para Mais com seletor `Sistema | Claro | Escuro`, usando
  `ThemeMode` em memória e sem nova persistência;
- usar controle segmentado `Nova venda | Histórico` em `/app/sales`;
- preservar o draft ao alternar segmentos enquanto o controller existir;
- não mudar redirects, guards ou semântica de sessão.

O router funcional não está autorizado na Version 1. A única alteração aceita
em `app_router.dart` é corrigir comentários obsoletos, sem mudar imports,
rotas, branches, redirects, guards ou comportamento. Qualquer necessidade
funcional exige Change Request.

## Visual contract

- `Instrument Sans` permanece a fonte do produto;
- azul/navy permanece dominante;
- hero navy continua assinatura do Dashboard e de superfícies de destaque;
- background atmosférico, bordas sutis, sombras curtas e cards permanecem;
- densidade é moderada/alta e orientada à leitura operacional;
- iconografia de produto usa `AppIcons`/Lucide;
- badges comunicam estado; números, preço, quantidade e metadata usam texto;
- light e dark mode recebem tratamento intencional, não inversão automática;
- motion é curto, funcional e baseado nos tokens existentes;
- buscas globais falsas são removidas, sem feature substituta;
- não usar estética playful, neon, genérica ou ornamentação sem função.

## UI states

Quando aplicáveis, as superfícies devem representar:

```text
loading
ready
empty
restricted
offline
refreshing
failure
```

Regras:

- loading inicial pode usar skeleton quando estável; ação pontual pode usar spinner;
- refreshing não apaga conteúdo local válido;
- offline/failure não apaga conteúdo local válido;
- restricted diferencia permissão/feature de erro técnico;
- `price = null` usa linguagem de restrição, não falha;
- pendente, sincronizando, confirmado, retry, atenção, revisão e cancelado mantêm distinção sem expor enum interno;
- proposta sem modelo estruturado usa “Revisão necessária”, informa que o
  servidor retornou um ajuste e mantém a ação existente, sem JSON cru;
- erro técnico nunca é mostrado diretamente ao usuário.

## Content contract

Termos internos proibidos na experiência final:

```text
outbox
proposalJson
lastError
JSON cru
stack trace
fora do escopo
aguardando endpoints
tenant
features
servidor soberano
```

Os três últimos podem existir em código/documentação; na UI devem ser
traduzidos para linguagem de conta, empresa, acesso e disponibilidade.

Módulos inexistentes, incluindo Estoque e Relatórios atuais, ficam ocultos.
Estado indisponível só pode aparecer para capacidade real bloqueada por
feature, permissão ou configuração.

## Accepted known risk / functional debt

`DEBT-014-01`: o mobile sabe que uma venda exige aceite e consegue executar a
ação com a revisão vigente, mas não possui modelo estruturado suficiente para
explicar os ajustes. A 014 não interpreta `proposalJson`. A UI usa fallback
seguro e a explicação detalhada fica para Spec/Change Request funcional futura.
Este risco foi aceito no freeze e não bloqueia a implementação visual.

## Accessibility and responsive contract

- largura mínima de referência: 320 px;
- text scaler de referência: 2.0;
- touch target mínimo: 48 px;
- nenhum overflow em superfícies críticas;
- controles possuem rótulo/tooltip/semântica adequada;
- cor não é o único sinal de estado;
- ordem de foco e navegação por teclado permanecem lógicas;
- teclado não bloqueia CTA/campos em Auth e pickers;
- conteúdo rolável continua alcançável com text scaling alto;
- temas claro/escuro mantêm contraste e hierarquia.

## Allowed paths

### Produção

- `lib/app/theme/**`
- `lib/app/startup/**`
- `lib/app/localization/app_strings.dart`
- `lib/app/router/app_router.dart` somente para comentários obsoletos, sem mudança funcional
- `lib/shared/widgets/**`
- `lib/features/auth/presentation/**`
- `lib/features/dashboard/presentation/**`
- `lib/features/catalog/presentation/**`
- `lib/features/sales/presentation/**`
- `lib/features/settings/presentation/**`

### Testes

- `test/app/arara_app_test.dart`
- `test/goldens/**`
- `test/features/auth/**`
- `test/features/dashboard/**`
- `test/features/catalog/**`
- `test/features/sales/**`
- `test/features/settings/**`
- `test/shared/**`
- `test/theme/**`
- `test/architecture/**` somente para ajustar/provar regras afetadas, sem relaxar boundaries

### Documentação

- `docs/specs/014-revitalizacao-visual-ux-operacional/**`

## Disallowed paths without contract revision / Change Request

- `lib/app/router/**`, exceto comentários obsoletos em `app_router.dart`;
- `lib/features/**/domain/**`;
- `lib/features/**/application/**`;
- `lib/features/**/data/**`;
- `lib/core/database/**`;
- `lib/core/sync/**`;
- `lib/core/network/**`;
- schema, migrations e arquivos gerados;
- backend e configuração de release.

## Acceptance invariants

1. nenhum dado de negócio é inventado para completar layout;
2. nenhum comportamento autenticado ou redirect muda;
3. nenhum contrato remoto/local muda;
4. nenhuma pendência é apresentada como confirmação;
5. restrições financeiras e permissões permanecem corretas;
6. dados locais permanecem visíveis quando aplicável;
7. affordances visíveis executam uma ação real;
8. navegação principal não possui redundância injustificada;
9. UI não expõe linguagem técnica proibida;
10. Dashboard preserva hero navy e trata sync como metadata;
11. Vendas preserva o fluxo funcional e separa criação de histórico visualmente;
12. proposal/acceptance não expõe JSON nem inventa detalhes ausentes;
13. picker de produto não inventa estoque ausente de `SaleProductOption`;
14. draft de venda sobrevive à alternância visual entre os segmentos enquanto o controller existir;
15. `createdAt` existente pode ser exibido pelo histórico sem atravessar presentation;
16. light/dark, 320 px, text scaler 2.0 e touch targets são validados;
17. exatamente 18 goldens cobrem as nove superfícies aprovadas em claro/escuro;
18. Startup, pickers e estados especiais ficam em widget tests focados;
19. boundaries passam sem exceção ou relaxamento incidental;
20. Mefisto emite veredito antes do fechamento de Jarvis.

## Freeze checklist

- [x] decisões humanas da Spec aprovadas;
- [x] direção de shell/Drawer aprovada;
- [x] fallback de proposta e risco conhecido aprovados;
- [x] paths finais aprovados;
- [x] escopo de exatamente 18 goldens aprovado;
- [x] status alterado explicitamente para `FROZEN` em 2026-09-18.
