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
   * O `SyncEngine` deve obter uma trava lógica (Mutex em memória e lock persistido) antes de iniciar. Se uma sincronização já estiver ativa, novas tentativas devem ser descartadas silenciosamente para evitar concorrência e economizar dados do usuário.
   * A trava deve ser liberada com segurança dentro de blocos `finally` das rotinas de sincronização, garantindo que erros na requisição HTTP (como timeouts ou indisponibilidade) não deixem o aplicativo permanentemente bloqueado ("travado em sync").
2. **Limitador de Gatilhos (Sync Throttling):**
   * O observador do Flutter (`WidgetsBindingObserver`) que dispara sincronizações quando o app muda para `AppLifecycleState.resumed` deve possuir uma política de limitação de taxa (throttling).
   * A sincronização automática por retomada de foco só ocorrerá se o intervalo desde a última sincronização bem-sucedida ou com falha for superior a **5 minutos** (cooldown). Ações manuais de puxar para atualizar (pull-to-refresh) ignoram esta restrição de tempo.
3. **Bootstrap vs Delta Sync:**
   * **Bootstrap (Carga Inicial):** Ocorre se o checkpoint de sincronização da coleção estiver vazio. Baixa a base inteira de forma paginada.
   * **Delta Sync (Carga Incremental):** Se houver checkpoint, envia o parâmetro `updated_since` com a data/hora ou cursor do último sync. Atualiza localmente apenas o delta retornado.
4. **Persistência de Checkpoint por Etapa:**
   * O cursor/checkpoint da coleção só será atualizado e persistido no banco Drift local *após* a persistência bem-sucedida da página correspondente no SQLite. Se houver falha de rede ou de banco no meio do lote, o sync é interrompido e o checkpoint permanece no último ponto seguro conhecido.
5. **Mapeamento Idempotente:**
   * Toda inserção local durante a sincronização deve utilizar estratégias de "upsert" (inserir ou atualizar em caso de conflito de chave primária).

## Estrutura de Arquivos Proposta
```text
lib/core/sync/
  sync_engine.dart            # Orquestrador de coleções
  sync_lock.dart              # Mutex simples para evitar execuções simultâneas
  sync_collection.dart        # Interface abstrata para coleções de sincronização
  sync_lifecycle_observer.dart # Escuta o ciclo de vida e dispara o sync com cooldown
```

## Critérios de Aceite
* O `SyncEngine` gerencia o estado global de sincronização e o expõe de forma reativa (Riverpod `syncStateProvider`).
* Tentativas de rodar a sincronização enquanto outra está ativa são ignoradas (comprovado em logs e testes).
* O gatilho de ciclo de vida (`resumed`) respeita o cooldown de 5 minutos, evitando requisições duplicadas imediatas.
* Falhas de rede ou interrupções abruptas abortam a sincronização, liberam o lock de concorrência e preservam o último checkpoint seguro.
* A suíte de testes unitários valida o comportamento do `SyncLock` (incluindo liberação no `finally`), a execução em ordem das coleções registradas, e o limitador de gatilhos (throttling).

