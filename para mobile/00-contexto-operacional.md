# Contexto Operacional Mobile

## Para que serve

Esta é a porta de entrada canônica para o estado comprovado do Arara-Gastos Mobile. Documentação descreve intenção; código, contrato implementado, testes e evidências comprovam o estado real.

## Estado atual — 11 de setembro de 2026

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

A suíte Flutter completa e o `flutter analyze --no-pub` passaram sem falhas, erros ou lints. Os testes golden visuais de Shell, Dashboard e Catálogo também foram aprovados (6/6).

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

1. adicionar UX de offline/connectivity e hardening operacional;
2. configurar release, HTTPS/VPS e identidade do app;
3. executar smoke E2E em ambiente/dispositivo alvo.

## Como escolher o que ler

Use `.agents/task-routing.md`. Consulte `06-registro-decisoes.md` para decisões aceitas e `docs/specs/<spec>/contract.md` para contratos congelados.

Entrega CRITICAL exige contrato FROZEN, testes proporcionais ao risco e veredito de Mefisto antes do fechamento por Jarvis.
