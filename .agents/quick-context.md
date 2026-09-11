# Contexto Rápido

## Estado local em validação — 11 de setembro de 2026

- Specs 007, 008, 008B, 009A e 009B entregues; 009A/009B revalidadas no gate de estabilização.
- 009C entrega catálogo/dashboard local-first real. Foi reaberta somente pelo `CR-009C-001`; a correção de Category UUID da Spec 012 está implementada e aguarda `flutter analyze --no-pub` para fechamento.
- Banco Drift evoluiu localmente para schema v5, com clientes e estado durável de snapshot; paths v1/v2/v3/v4 → v5 aguardam execução dos gates.
- Sync de foreground possui startup autenticado, refresh manual e `resumed` com cooldown. Connectivity/background ainda não estão ligados.
- O núcleo da 010 possui venda local atômica, outbox, idempotência, retry, claim, replay estrito e lifecycle; seus testes estão verdes.
- Settings usa a `UserSession` real e o estado de sync observa o engine contextual pela Spec 013. Falta análise estática para fechar a Spec.
- Manifest Android principal declara `INTERNET`.
- Suíte completa: 220 testes aprovados, zero falhas.
- Spec 013D está implementada localmente e em validação: demo usa `demo-user/demo-tenant`, DB próprio, seed Drift e gateway sem HTTP/token.

## Bloqueios atuais

- `BLOCKER-010-CLIENTS`: RESOLVED no backend `dev@f8ff65e`; mobile local implementa snapshot/reconciliação.
- `BLOCKER-010-CONFIRMATION-RECOVERY`: RESOLVED no mesmo backend; replay idêntico rotaciona o token.
- UI de vendas local usa clientes/produtos Drift, venda/outbox persistente e aceite por revisão; não há fallback fixture em `normal`.
- Timezone IANA depende de `APP_TIMEZONE` com as dependências atuais; ausência/invalidez falha fechado.
- Specs 009C/012/013 aguardam o gate `flutter analyze --no-pub`.
- Runtime demo sem API continua bloqueado até a execução integral da Spec 013D.

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

1. executar testes focados, suíte completa e `flutter analyze --no-pub` da entrega local;
2. corrigir qualquer regressão e emitir veredito final da Spec 010/013D;
3. UX de offline/connectivity e hardening;
4. configuração de release e smoke E2E.

Leia `AGENTS.md`, este arquivo, `.agents/task-routing.md` e somente a documentação indicada para a tarefa.
