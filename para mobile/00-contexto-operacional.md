# Contexto Operacional Mobile

## Para que serve

Esta é a porta de entrada canônica para o estado comprovado do Arara-Gastos Mobile. Documentação descreve intenção; código, contrato implementado, testes e evidências comprovam o estado real.

## Estado histórico — checkpoint de setembro de 2026

```text
007  Core de rede                         ✅ entregue
008  Sessão/autenticação                  ✅ entregue
008B Isolamento user + tenant             ✅ entregue
009A Drift/schema e migrações             ✅ validada
009B Sync Engine Base                     ✅ validada
009C Catálogo/dashboard local-first       ✅ validada
010  Outbox/vendas                        ✅ validada
011  Draft histórico                      ⛔ superseded
012  Category UUID                        ✅ validada
013  Contexto real e observabilidade      ✅ validada
013D Runtime demo sem API                 ✅ validada
Release                                   ⏭ pendente
```

Nesse checkpoint, a suíte Flutter completa e o `flutter analyze --no-pub` passaram; os goldens de Shell, Dashboard e Catálogo foram aprovados (6/6). Esses resultados são históricos e não atestam o SHA atual.

## Atualização documental — 25 de novembro de 2026

- Spec 014 concluída com restrições: gate final `passed_with_restrictions`; 18 goldens, suíte e analyze constam como aprovados na [evidência histórica](../docs/specs/014-revitalizacao-visual-ux-operacional/validation-result.md). TalkBack e ordem de foco seguem `NOT_RUN` ([#18](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/18)).
- A proposta de ajuste ainda não é explicada de forma estruturada antes do aceite (DEBT-014-01, [#2](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues/2)); não confundir aceite disponível com revisão detalhada implementada.
- As Specs [015–023](../docs/specs/roadmap-refinamento-015-023.md) estão em planejamento; contratos DRAFT não comprovam implementação ou CI. As [issues abertas](https://github.com/CarlosVLemos/mobile_gestor_de_estoque/issues) registram pendências e riscos de auditoria, alguns ainda não reproduzidos.
- Esta atualização é documental: não houve nova execução de testes, análise, build ou QA de dispositivo.

## Verticais reais

```text
Catálogo/dashboard:
API -> SyncEngine -> Drift -> Repository -> Controller -> Page

Vendas local-first validadas:
RegisterSaleUseCase -> venda local + outbox atômicas
  -> SyncEngine -> OutboxProcessor -> sale-intents

Tela de vendas persistente:
Drift clients/products -> SalesController -> RegisterSaleUseCase -> Drift/outbox

Runtime demo validado:
sessão demo -> banco isolado -> seed Drift -> gateway sem HTTP
```

O núcleo, a tela persistente e o runtime demo estão conectados e validados. Operações pendentes continuam explicitamente distintas de confirmação remota.

## Contratos e bloqueios

- Category usa UUID no backend; Product e tombstones de Product usam inteiros. O mobile preserva todos como `String` interna, com validação específica por entidade.
- O backend `dev@f8ff65e` possui snapshot mobile de clientes e recovery seguro de `requires_confirmation`; ambos os blockers antigos estão resolvidos.
- O mobile implementa clientes Drift/snapshot, UI persistente de vendas, aceite e recovery; os gates finais foram aprovados.
- Settings usa dados da `UserSession` real; não há fallback fixture.
- `syncStateProvider` observa a mesma instância contextual usada pelo lifecycle.
- Startup autenticado, refresh manual e `resumed` com cooldown estão ligados. Connectivity/background continuam pendentes.

## Decisões fixas

- Flutter, Riverpod, `go_router`, Dio e Drift.
- Arquitetura local-first e banco físico por `userId + tenantId`.
- `Page -> Controller -> UseCase -> Repository -> DAO/API`.
- presentation não acessa Dio/Drift; application não conhece transporte/persistência; domain não conhece Flutter.
- servidor soberano para autorização, estoque, preço e confirmação.
- operação local pendente nunca é apresentada como confirmada.
- falha de migração não autoriza apagar banco/outbox.
- `price = null` pode representar restrição válida.
- contrato planejado nunca é tratado como implementado.

## Próximo caminho crítico

1. Refinar e aprovar a [Spec 015](../docs/specs/015-engenharia-qualidade-ci-cd/spec.md) para estabelecer gates verificáveis; CI ainda não é um gate comprovado.
2. Trabalhar confiabilidade offline, segurança e acessibilidade nas Specs 016, 020 e 017; registro, busca e gestão seguem dependências dos respectivos contratos.
3. Preparar homologação e executar smoke E2E apenas após atender aos gates aplicáveis da Spec 021. Consulte o [roadmap](../docs/specs/roadmap-refinamento-015-023.md) para dependências e issues; TalkBack e proposta detalhada seguem pendentes.

## Como escolher o que ler

Use `.agents/task-routing.md`. Consulte `06-registro-decisoes.md` para decisões aceitas e `docs/specs/<spec>/contract.md` para contratos congelados.

Entrega CRITICAL exige contrato FROZEN, testes proporcionais ao risco e veredito de Mefisto antes do fechamento por Jarvis.
