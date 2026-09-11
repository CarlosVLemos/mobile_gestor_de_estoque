# Contexto Rápido

## Estado local validado — 11 de setembro de 2026

- Specs 007, 008, 008B, 009A, 009B, 009C, 010, 012, 013 e 013D entregues e totalmente validadas (`DONE`).
- 009C e Spec 012 (Category UUID) concluídas e validadas com sucesso.
- Banco Drift evoluiu localmente para schema v5 (clientes, snapshots, migrações v1->v5), com testes totalmente validados.
- Sync de foreground possui startup autenticado, refresh manual e `resumed` com cooldown.
- Núcleo da 010 (venda local atômica, outbox, idempotência, retry, claim, replay estrito, lifecycle e controller) 100% testado e aprovado.
- Settings usa a `UserSession` real e observabilidade contextual (Spec 013) validadas.
- Spec 013D (runtime demo sem API: `demo-user/demo-tenant`, DB isolado, seed Drift, gateway sem HTTP) totalmente validada.
- Suíte completa de testes e `flutter analyze --no-pub`: 100% verde com zero falhas e zero erros estáticos.
- Testes golden visuais (Shell, Dashboard, Catálogo): atualizados e aprovados (6/6).

## Bloqueios atuais

- Nenhum bloqueio ativo. Todos os blockers das Specs 010, 012, 013 e 013D foram resolvidos e validados.
- UI de vendas local usa clientes/produtos Drift, venda/outbox persistente e aceite por revisão; sem fallback de fixture em `normal`.
- Timezone IANA depende de `APP_TIMEZONE` com as dependências atuais; ausência/invalidez falha fechado.

## Contrato de IDs do catálogo

```text
Product.id inteiro              -> String numérica mobile
Product tombstone.id inteiro    -> String numérica mobile
Category.id UUID                -> String UUID mobile
Category null                   -> null
```

Não relaxar genericamente IDs para qualquer String e não criar migração Drift para essa correção.

## Arquitetura obrigatória

`Page -> Controller -> UseCase -> Repository -> DAO/API`

O servidor permanece soberano para autorização, estoque e confirmação. Estado local pendente nunca equivale a confirmação remota. Dados de user/tenant diferentes não compartilham contexto local.

## Próximo caminho crítico

1. UX de offline/connectivity e hardening;
2. configuração de release e smoke E2E.

Leia `AGENTS.md`, este arquivo, `.agents/task-routing.md` e somente a documentação indicada para a tarefa.
