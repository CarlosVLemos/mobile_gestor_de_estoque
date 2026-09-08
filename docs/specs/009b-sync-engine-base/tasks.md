# Tasks: Spec 009B - Sync Engine Base (Motor de Sincronização)

- [ ] **Fase 1: Mutex e Controle de Lock**
  - [x] Criar `lib/core/sync/sync_lock.dart` implementando controle de trava simples em memória.
  - [x] Garantir liberação segura da trava mesmo em cenários de exceções não capturadas.

- [ ] **Fase 2: Contrato de Coleções de Sincronização**
  - [x] Criar `lib/core/sync/sync_collection.dart` contendo a classe abstrata `SyncCollection`.
  - [x] Definir o ciclo de vida de uma coleção: obter checkpoint, requisitar rede, salvar localmente, atualizar checkpoint.

- [ ] **Fase 3: Orquestração Central**
  - [x] Criar `lib/core/sync/sync_engine.dart` que coordena a execução de todas as coleções de sincronização registradas.
  - [x] Expor o progresso do sync reativamente com Riverpod (`syncStateProvider`).

- [ ] **Fase 4: Integração com Ciclo de Vida do Flutter e Cooldown**
  - [x] Criar `lib/core/sync/sync_lifecycle_observer.dart` estendendo `WidgetsBindingObserver`.
  - [x] Implementar limitador de taxa (cooldown de 5 minutos) associado ao gatilho de ciclo de vida.
  - [x] Vincular o ciclo de vida `resumed` para disparar uma execução leve do `SyncEngine` apenas se fora do cooldown.

- [ ] **Fase 5: Testes de Engine**
  - [x] Criar `test/core/sync/sync_engine_test.dart` mockando coleções e validando se o motor as executa em lote ordenado.
  - [ ] Testar se a trava (`SyncLock`) é liberada corretamente em cenários de exceção no meio do processamento da coleção (garantindo execução do bloco `finally`).
  - [ ] Testar o comportamento do cooldown do gatilho de ciclo de vida, disparando múltiplos eventos `resumed` e validando se apenas a primeira requisição chega ao servidor.
  - [ ] Testar interrupção de sync por falha física e garantia de que o checkpoint não avança.

## Controle da execução parcial

Itens marcados representam código escrito, não validação aprovada.

- [x] Implementar lock persistido com owner, TTL e proteção de escrita após expiração.
- [x] Implementar adaptadores transacionais Drift para dados/checkpoints.
- [x] Preparar composição condicional e registro/remoção do observer (009C).
- [ ] Integrar sessão autenticada e arquivo isolado (008/008B).
- [ ] Testar provider e cancelamento da assinatura reativa.
- [ ] Executar formatação, análise estática e testes com SDK disponível.

A 009C registra/remove o observer condicionalmente pelo bootstrap. Sem contexto
injetado, não há engine nem chamadas HTTP. A sessão real permanece pendente.

## Continuação — persistência e fechamento seguro

- [x] Adicionar `sync_locks` ao schema inicial ainda não publicado.
- [x] Exigir `SyncLeaseStore` na engine e proteger commits com a lease.
- [x] Aguardar conclusão/liberação em `dispose()`.
- [x] Escrever testes Drift de TTL, concorrência, reabertura e rollback.
- [x] Escrever teste de integração engine/Drift e de autoDispose do provider.
- [ ] Executar os novos testes e revisar geração do schema completo.

SQL isolado foi verificado com SQLite/Python; isso não aprova os testes Flutter.

- [x] Classificar falhas de sync sem expor exceções à UI e manter negação 401/403
  na engine até recomposição por contexto validado.
