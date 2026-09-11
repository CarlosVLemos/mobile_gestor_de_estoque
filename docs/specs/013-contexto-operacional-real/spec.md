# Spec 013 — Contexto operacional real e observabilidade do sync

Status: `done`
Mode: `CRITICAL`
Execution mode: `SINGLE_WRITER`
Data: 2026-09-09
Autorização: missão de estabilização e fechamento

## Problema

Settings ainda obtém tenant, identidade e permissões de fixture embora `UserSession` já contenha o perfil real. Em paralelo, `syncStateProvider` observa um `syncEngineProvider` permanentemente nulo, enquanto a aplicação usa `contextSyncEngineProvider`. O composition root também é classificado incorretamente como código comum de `app`, gerando duas violações de boundary.

## Escopo

- adaptar a sessão autenticada para `OperationalContext`, sem nova chamada HTTP;
- remover a fixture de Settings da composição de produção;
- expor o engine contextual ao `syncStateProvider` no escopo autenticado;
- tornar explícito o diretório de composição que pode ligar implementações concretas;
- remover `.gitkeep` residual do catálogo remoto;
- adicionar testes focados da composição/repositório e manter teardown seguro.

## Fora de escopo

- clientes e integração da UI de vendas;
- novo SyncEngine, novo lifecycle ou conectividade/background;
- alteração de autenticação, banco, schema ou backend;
- refatoração geral de providers.

## Critérios de aceite

- Settings apresenta somente os campos da `UserSession` corrente.
- Ausência de sessão resulta em indisponibilidade, nunca fixture.
- `syncStateProvider` observa o mesmo `SyncEngine` contextual.
- logout/troca de contexto invalida Settings e estado de sync.
- o teste de boundaries não libera datasources para arquivos comuns de `app`.
- os testes arquiteturais ficam verdes.

Contrato: [`contract.md`](contract.md).
