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

- [ ] **Fase 4: Integração com Ciclo de Vida do Flutter**
  - [ ] Criar `lib/core/sync/sync_lifecycle_observer.dart` estendendo `WidgetsBindingObserver`.
  - [ ] Vincular o ciclo de vida `resumed` para disparar uma execução leve do `SyncEngine`.

- [ ] **Fase 5: Testes de Engine**
  - [ ] Criar `test/core/sync/sync_engine_test.dart` mockando coleções e validando se o motor as executa em lote ordenado.
  - [ ] Testar cenários de timeout ou travamento simulado e validar a recuperação de estado da engine.
