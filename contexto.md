# Contexto do Projeto

Fotografia curta do Arara-Gastos Mobile em 9 de setembro de 2026. Em conflito, prevalecem as fontes canônicas definidas em `AGENTS.md`, as decisões aceitas em `para mobile/06-registro-decisoes.md` e os contratos FROZEN.

## Estado comprovado

| Spec | Estado |
| --- | --- |
| 007 | entregue |
| 008 | entregue |
| 008B | entregue |
| 009A | `done`, schema/migrações validados |
| 009B | `done`, engine/lifecycle/gatilhos de foreground validados |
| 009C | reaberta somente pelo `CR-009C-001`; analyze pendente |
| 010 | Fase A validada; E2E bloqueado |
| 011 | `superseded` por 009/010 e estado real |
| 012 | Category UUID implementada; analyze pendente |
| 013 | contexto real/sync observável implementados; analyze pendente |

O banco está em schema v4. As migrações v1/v2/v3 → v4 preservam a outbox. A correção de Category UUID não mudou Drift e não exigiu codegen.

O gate final mais recente executou 220 testes com zero falhas. O perfil do `SyncEngine` passou com 12 testes, incluindo startup, cooldown de resumed e bypass manual. O `flutter analyze --no-pub` permanece pendente.

## Fluxos atuais

```text
Catálogo/dashboard real:
API -> SyncEngine -> Drift -> Repository -> Controller -> Page

Vendas — núcleo real:
RegisterSaleUseCase -> Drift/local sale + outbox -> OutboxProcessor -> API

Vendas — UI atual:
fixture de draft -> estado em memória -> Page
```

Settings deriva identidade, tenant, features e permissões da `UserSession`. O engine exposto ao estado de UI é a mesma instância registrada no lifecycle contextual. O Android principal declara permissão `INTERNET`.

## Bloqueios

1. **Clientes:** o backend auditado não possui endpoint mobile para listar/sincronizar clientes. A UI não pode produzir um `client_id` remoto válido usando fixtures.
2. **Confirmação:** replay/consulta de `sale-intents` não devolvem o token necessário para recovery seguro de propostas.
3. **UI de vendas:** só deve ser ligada ao pipeline persistente quando o contrato de clientes existir.
4. **QA estático:** 009C/012/013 aguardam `flutter analyze --no-pub`.

## Dívida não bloqueante

- gatilho de connectivity e execução background;
- apresentação de estado de sync/outbox e polish de dashboard;
- remoção futura de repositories fixture de catálogo/dashboard usados apenas em testes;
- configuração de release, applicationId, signing, ambiente HTTPS/VPS e smoke E2E;
- avisos Drift do harness que abre múltiplas conexões deliberadamente em testes.

## Próximo caminho crítico

1. fechar o gate estático e aceitar o CR da 009C;
2. especificar/implementar clientes no backend;
3. corrigir recovery de confirmação;
4. conectar a UI de vendas ao core já validado;
5. validar offline/connectivity e preparar release.

Nenhuma implementação futura deve recriar 009A, 009B, 009C ou a Fase A da 010. Leia `.agents/quick-context.md` e `.agents/task-routing.md` antes de trabalhar.
