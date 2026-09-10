# Contexto Operacional Mobile

## Para que serve

Esta é a porta de entrada canônica para o estado comprovado do Arara-Gastos Mobile. Documentação descreve intenção; código, contrato implementado, testes e evidências comprovam o estado real.

## Estado atual — 9 de setembro de 2026

```text
007  Core de rede                         ✅ entregue
008  Sessão/autenticação                  ✅ entregue
008B Isolamento user + tenant             ✅ entregue
009A Drift/schema e migrações             ✅ validada
009B Sync Engine Base                     ✅ validada
009C Catálogo/dashboard local-first       ✅ validada (CR-009C-001 aceito)
010  Outbox/vendas                        🟨 Fase A validada / E2E bloqueado
011  Draft histórico                      ⛔ superseded
012  Category UUID                        ✅ validada
013  Contexto real e observabilidade      ✅ validada
Release                                   ⏭ pendente
```

A suíte Flutter e a análise estática (`flutter analyze --no-pub`) passaram com zero erros.

## Verticais reais

```text
Catálogo/dashboard:
API -> SyncEngine -> Drift -> Repository -> Controller -> Page

Núcleo de vendas implementado:
RegisterSaleUseCase -> venda local + outbox atômicas
  -> SyncEngine -> OutboxProcessor -> sale-intents

Tela de vendas atual:
FixtureSalesDraftRepository -> controllers em memória -> Page
```

O núcleo de vendas está implementado e testado, mas a tela ainda não o chama.

## Contratos e bloqueios

- Category usa UUID no backend; Product e tombstones de Product usam inteiros. O mobile preserva todos como `String` interna, com validação específica por entidade.
- Não existe endpoint mobile auditado de clientes no backend. Não usar fixture como `client_id` remoto.
- O recovery de confirmação de `sale-intents` não é seguro porque replay/consulta não restituem o token necessário.
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
2. entregar no backend o contrato mobile de clientes e o recovery de confirmação;
3. sincronizar clientes e conectar a UI de vendas à Fase A da 010;
4. adicionar UX/connectivity mínima, hardening e observabilidade operacional;
5. configurar release, HTTPS/VPS, identidade do app e executar smoke E2E.

## Como escolher o que ler

Use `.agents/task-routing.md`. Consulte `06-registro-decisoes.md` para decisões aceitas e `docs/specs/<spec>/contract.md` para contratos congelados.

Entrega CRITICAL exige contrato FROZEN, testes proporcionais ao risco e veredito de Mefisto antes do fechamento por Jarvis.
