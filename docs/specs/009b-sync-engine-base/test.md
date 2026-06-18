# Spec 009B - Referência de Validação Futura

## Objetivo

Registrar como a futura implementação da Spec 009B (Sync Engine Base) deverá ser validada.

## O que verificar depois

A futura implementação deverá comprovar que:
- O `SyncEngine` impede execuções concorrentes (apenas um lote por vez);
- Falhas em requisições de API liberam a trava de sync imediatamente;
- O gatilho de retomada de foco (`resumed`) não dispara requisições se a última tiver ocorrido há menos de 5 minutos (cooldown);
- A falha de uma coleção no meio do lote impede que seu cursor avance no banco Drift local.

## Cenários de Teste a Cobrir

### 1. Prevenção de Concorrência (Locks)
* **Verificar:**
  - Mockar uma coleção de sincronização lenta (que demora 5 segundos).
  - Chamar `SyncEngine.sync()`.
  - No segundo 1, chamar `SyncEngine.sync()` novamente.
  - Validar que a segunda chamada é imediatamente ignorada e retorna um status indicando concorrência (sem re-executar requisições).
  - Validar que a trava é desfeita após a conclusão da primeira chamada de 5 segundos.

### 2. Liberação em Caso de Exceção (Finally)
* **Verificar:**
  - Mockar uma coleção que lança uma exceção no meio de sua chamada remota.
  - Executar `SyncEngine.sync()`.
  - Confirmar que a exceção é propagada ou tratada pela engine, e que o semáforo de trava é liberado.
  - Chamar `SyncEngine.sync()` novamente para verificar que a engine não ficou travada em estado permanente de sincronização.

### 3. Cooldown do LifeCycle Observer
* **Verificar:**
  - Registrar o `SyncLifecycleObserver`.
  - Simular alteração do ciclo de vida para `resumed`. A sincronização inicial deve rodar.
  - Esperar 10 segundos. Simular nova transição para `resumed`. A sincronização **NÃO** deve rodar.
  - Simular nova transição para `resumed` após 6 minutos da primeira. A sincronização deve rodar com sucesso.

### 4. Integridade do Checkpoint em Falhas
* **Verificar:**
  - Executar uma sincronização de catálogo. A primeira página funciona e é gravada.
  - A segunda página falha por perda de conexão.
  - Validar que a engine para e o checkpoint gravado no banco de dados Drift local corresponde apenas ao cursor da primeira página (ou seja, não avança para o cursor da página que falhou).

## Checklist de Validação

- [ ] `SyncLock` implementado e cobrindo semáforo em memória.
- [ ] Liberação de lock envolta em bloco `finally`.
- [ ] Classe `SyncCollection` expõe ciclo de vida abstrato.
- [ ] `SyncEngine` gerencia o estado `syncStateProvider`.
- [ ] `SyncLifecycleObserver` escuta eventos do Flutter.
- [ ] Cooldown de 5 minutos implementado para gatilho automático.
- [ ] Testes unitários do Lock passando com sucesso.
- [ ] Testes do Cooldown validando descarte de requisições repetidas.
