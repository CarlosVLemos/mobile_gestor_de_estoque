# Spec 009B — Revisão da implementação parcial

## Status em 8 de setembro de 2026

Execução autorizada pelo usuário nesta conversa, substituindo o gate de abertura.
Código preparado para validação posterior, sem aceite de conclusão.

## Implementado

- Mutex no isolate e contrato obrigatório de lock persistido na `SyncEngine`.
- `DriftSyncLeaseStore`: aquisição atômica por UPSERT, identidade aleatória por
  aquisição, TTL obrigatório configurável e liberação condicionada ao dono.
- Tabela `sync_locks` com nome, dono, aquisição e expiração em milissegundos UTC.
- Renovação antes de baixar cada página e validação/renovação dentro da transação
  de escrita. Posse expirada não pode ser renovada; a engine deve adquirir outra
  lease em uma nova execução. Download que exceder o TTL será descartado.
- Proteção antes e depois da escrita: expiração durante a transação reverte a
  página e seu checkpoint. Não há timer de renovação nem rede na transação.
- `DriftSyncCheckpointStore`: leitura por coleção e commit transacional de dados
  e checkpoint; upserts concretos continuam responsabilidade da coleção.
- Coleções e páginas sequenciais, interrupção em falha, proteção contra página
  intermediária sem avanço e cancelamento cooperativo.
- Liberação no `finally`; erro na liberação persistida não retém mutex local.
  O TTL permite recuperação posterior. `dispose()` aguarda execução e liberação.
- Estado reativo, cooldown de cinco minutos após término e observer de lifecycle.
  Chamada descartada por lock ocupado não inicia cooldown. Ação manual ignora-o.
- `syncStateProvider.autoDispose` e testes escritos para estado e descarte.

## Composição e limitações

- Lease, checkpoints e callbacks de escrita DEVEM compartilhar o mesmo
  `AppDatabase`. O contrato genérico não protege escritas em outro banco nem
  efeitos externos. As coleções da 009C são compostas com esse mesmo banco.
- A 009C registra composição/bootstrap/lifecycle condicionalmente. O contexto
  autenticado/isolado ainda precisa ser fornecido pela 008/008B.
- O TTL deve ser escolhido na composição considerando timeouts e tamanho das
  páginas. Saltos do relógio do dispositivo podem antecipar ou atrasar recuperação.
- Classificação de sync implementada: offline, unauthorized, forbidden, remote,
  invalidData e local; negação de acesso persiste na engine até recomposição
  por contexto validado. Logs estruturados continuam pendentes.
- A versão 1 do schema ainda não foi gerada, executada ou publicada nesta entrega;
  `sync_locks` integra esse schema inicial. Se houver banco de outra versão em uso,
  preparar migração aditiva e testes de preservação antes de conectar o app.

## Testes e evidências

Escritos, ainda não executados com Flutter:

- engine: ordem, concorrência, cooldown, falhas de aquisição/liberação, perda de
  posse durante download, cancelamento e descarte aguardando término;
- banco: disputa entre conexões, reabertura, recuperação por TTL, dono antigo,
  renovação, rollback por expiração e falhas de dados/checkpoint, idempotência;
- integração engine/Drift: mutexes distintos disputam a mesma lease e a página
  de executor cuja posse expirou não é gravada;
- provider: estado inicial/atualização e cancelamento de assinatura por autoDispose.

Executado neste ambiente:

- `git diff --check`, sem erros;
- instruções SQL extraídas do adaptador, executadas com SQLite via Python:
  aquisição exclusiva, recuperação no TTL, rejeição do dono antigo, liberação
  condicionada e rollback. Verifica SQL isolado, não bindings ou transações Drift.

Dart e Flutter ausentes: geração, formatação, análise e testes seguem pendentes.
Referência: [transações Drift](https://drift.simonbinder.eu/dart_api/transactions/).
