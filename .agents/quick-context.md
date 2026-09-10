# Contexto Rápido

## Estado comprovado em 9 de setembro de 2026

- Specs 007, 008, 008B, 009A e 009B entregues; 009A/009B revalidadas no gate de estabilização.
- 009C entrega catálogo/dashboard local-first real. Foi reaberta somente pelo `CR-009C-001`; a correção de Category UUID da Spec 012 está implementada e aguarda `flutter analyze --no-pub` para fechamento.
- Banco Drift está em schema v4, com migrações v1/v2/v3 → v4 e sem mudança de schema nesta estabilização.
- Sync de foreground possui startup autenticado, refresh manual e `resumed` com cooldown. Connectivity/background ainda não estão ligados.
- O núcleo da 010 possui venda local atômica, outbox, idempotência, retry, claim, replay estrito e lifecycle; seus testes estão verdes.
- Settings usa a `UserSession` real e o estado de sync observa o engine contextual pela Spec 013. Falta análise estática para fechar a Spec.
- Manifest Android principal declara `INTERNET`.
- Suíte completa: 220 testes aprovados, zero falhas.
- Spec 013D está `PAUSED`: o modo demonstração sem API foi especificado, mas não foi implementado nem incluído no commit de estabilização.

## Bloqueios atuais

- `BLOCKER-010-CLIENTS`: backend sem endpoint mobile auditado para listar/sincronizar clientes; não inventar `client_id`.
- `BLOCKER-010-CONFIRMATION-RECOVERY`: protocolo de replay/consulta não permite recuperar com segurança o token de confirmação.
- UI de vendas ainda usa draft fixture e pendências em memória; conectar ao core somente após o contrato de clientes.
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

1. concluir análise estática e fechar 009C/012/013;
2. handoff backend para clientes e recuperação de confirmação;
3. sincronizar clientes e conectar a UI de vendas ao núcleo persistente;
4. UX de offline/connectivity e hardening;
5. configuração de release e smoke E2E.

Leia `AGENTS.md`, este arquivo, `.agents/task-routing.md` e somente a documentação indicada para a tarefa.
