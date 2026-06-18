# Spec 009B: Sync Engine Base (Motor de Sincronização)

## Problema
Sincronizar múltiplos conjuntos de dados locais com APIs remotas introduz problemas de concorrência (duas sincronizações ocorrendo ao mesmo tempo), controle de estado de progresso global e redundância de código. Para resolver isso, precisamos de um motor de sincronização genérico (`SyncEngine`) que abstraia o controle de concorrência, checkpoints de tempo e fluxos de carga (bootstrap vs delta sync).

## Objetivo
Implementar o motor de sincronização base (`SyncEngine`), fornecendo mecanismos de trava de segurança (`SyncLock`), persistência de checkpoints, tratamento idempotente de payloads e gatilhos automatizados acionados pelo ciclo de vida do aplicativo (app lifecycle).

## Fora de Escopo
* Mapeamento de escrita local (Outbox).
* Implementação dos parses específicos das chamadas de API (como produtos ou dashboards).

## Regras de Negócio e Diretrizes Técnicas
1. **Controle de Concorrência (Sync Lock):**
   * O `SyncEngine` deve obter uma trava lógica antes de iniciar. Se uma sincronização já estiver ativa, novas tentativas devem ser descartadas silenciosamente para evitar concorrência e economia de dados.
   * A trava deve ser liberada com segurança dentro de blocos `finally`, garantindo que erros na requisição HTTP não deixem o aplicativo permanentemente bloqueado ("travado em sync").
2. **Bootstrap vs Delta Sync:**
   * **Bootstrap (Carga Inicial):** Ocorre se o checkpoint de sincronização da coleção estiver vazio. Baixa a base inteira paginada.
   * **Delta Sync (Carga Incremental):** Se houver checkpoint, envia o parâmetro `updated_since` com a data do último checkpoint. Atualiza localmente apenas o delta retornado.
3. **Mapeamento Idempotente:**
   * Toda inserção local durante a sincronização deve utilizar estratégias de "upsert" (inserir ou atualizar em caso de conflito de chave primária).
4. **Acionador por Evento de Sistema (Foreground Trigger):**
   * O motor de sincronização deve registrar um observador do Flutter (`WidgetsBindingObserver`) para disparar uma verificação leve de sincronização (Delta Sync) sempre que o aplicativo retornar do background para o primeiro plano (`AppLifecycleState.resumed`).

## Estrutura de Arquivos Proposta
```text
lib/core/sync/
  sync_engine.dart            # Orquestrador de coleções
  sync_lock.dart              # Mutex simples para evitar execuções simultâneas
  sync_collection.dart        # Interface abstrata para coleções de sincronização
```

## Critérios de Aceite
* O `SyncEngine` gerencia o estado global de sincronização e o expõe de forma reativa (Riverpod `syncStateProvider`).
* Tentativas de rodar a sincronização enquanto outra está ativa são ignoradas (comprovado em logs e testes).
* Falhas de rede ou interrupções abruptas abortam a sincronização e liberam o lock de concorrência.
* O motor de sincronização é disparado automaticamente quando o ciclo de vida do app muda para `resumed`.
* A suíte de testes unitários valida o comportamento do `SyncLock` e a execução em ordem das coleções registradas.
