# Tasks: Spec 009B - Sync Engine Base (Motor de Sincronização)

- [ ] **Fase 1: Mutex e Controle de Lock**
  - [ ] Criar `lib/core/sync/sync_lock.dart` implementando controle de trava simples em memória.
  - [ ] Garantir liberação segura da trava mesmo em cenários de exceções não capturadas.

- [ ] **Fase 2: Contrato de Coleções de Sincronização**
  - [ ] Criar `lib/core/sync/sync_collection.dart` contendo a classe abstrata `SyncCollection`.
  - [ ] Definir o ciclo de vida de uma coleção: obter checkpoint, requisitar rede, salvar localmente, atualizar checkpoint.

- [ ] **Fase 3: Orquestração Central**
  - [ ] Criar `lib/core/sync/sync_engine.dart` que coordena a execução de todas as coleções de sincronização registradas.
  - [ ] Expor o progresso do sync reativamente com Riverpod (`syncStateProvider`).

- [ ] **Fase 4: Integração com Ciclo de Vida do Flutter e Cooldown**
  - [ ] Criar `lib/core/sync/sync_lifecycle_observer.dart` estendendo `WidgetsBindingObserver`.
  - [ ] Implementar limitador de taxa (cooldown de 5 minutos) associado ao gatilho de ciclo de vida.
  - [ ] Vincular o ciclo de vida `resumed` para disparar uma execução leve do `SyncEngine` apenas se fora do cooldown.

- [ ] **Fase 5: Testes de Engine**
  - [ ] Criar `test/core/sync/sync_engine_test.dart` mockando coleções e validando se o motor as executa em lote ordenado.
  - [ ] Testar se a trava (`SyncLock`) é liberada corretamente em cenários de exceção no meio do processamento da coleção (garantindo execução do bloco `finally`).
  - [ ] Testar o comportamento do cooldown do gatilho de ciclo de vida, disparando múltiplos eventos `resumed` e validando se apenas a primeira requisição chega ao servidor.
  - [ ] Testar interrupção de sync por falha física e garantia de que o checkpoint não avança.
