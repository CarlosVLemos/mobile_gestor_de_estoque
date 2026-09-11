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
009C Catálogo/dashboard local-first       🟨 revalidação do CR-009C-001
010  Outbox/vendas                        🟨 implementação E2E local / validação pendente
011  Draft histórico                      ⛔ superseded
012  Category UUID                        🟨 implementada / analyze pendente
013  Contexto real e observabilidade      🟨 implementada / analyze pendente
Release                                   ⏭ pendente
```

A suíte Flutter completa passou com 220 testes e zero falhas. O `flutter analyze --no-pub` ainda não foi executado porque a revisão automática de permissão recusou o comando.

## Verticais reais

```text
Catálogo/dashboard:
API -> SyncEngine -> Drift -> Repository -> Controller -> Page

Núcleo de vendas implementado:
RegisterSaleUseCase -> venda local + outbox atômicas
  -> SyncEngine -> OutboxProcessor -> sale-intents

Tela de vendas local em validação:
Drift clients/products -> SalesController -> RegisterSaleUseCase -> Drift/outbox
```

O núcleo e a tela estão conectados localmente; falta concluir os gates atuais.

## Contratos e bloqueios

- Category usa UUID no backend; Product e tombstones de Product usam inteiros. O mobile preserva todos como `String` interna, com validação específica por entidade.
- O backend `dev@f8ff65e` possui snapshot mobile de clientes e recovery seguro de `requires_confirmation`; ambos os blockers antigos estão resolvidos.
- O mobile local implementa clientes Drift/snapshot, UI persistente de vendas e aceite, mas os gates finais ainda não foram executados.
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

1. concluir `flutter analyze --no-pub` e fechar 009C/012/013;
2. validar a implementação local de clientes, vendas e demo e fechar 010/013D somente com gates verdes;
3. adicionar UX/connectivity mínima, hardening e observabilidade operacional;
4. configurar release, HTTPS/VPS, identidade do app e executar smoke E2E.

## Como escolher o que ler

Use `.agents/task-routing.md`. Consulte `06-registro-decisoes.md` para decisões aceitas e `docs/specs/<spec>/contract.md` para contratos congelados.

Entrega CRITICAL exige contrato FROZEN, testes proporcionais ao risco e veredito de Mefisto antes do fechamento por Jarvis.
