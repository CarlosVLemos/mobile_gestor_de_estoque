class SyncCheckpoint {
  const SyncCheckpoint({this.lastSyncedAt, this.cursor});

  final DateTime? lastSyncedAt;
  final String? cursor;

  bool get isEmpty => lastSyncedAt == null && cursor == null;
}

/// Uma página já mapeada pela camada de dados da feature.
abstract interface class SyncPage {
  bool get hasMore;

  /// Derivado do contrato remoto, nunca do relógio local da engine.
  SyncCheckpoint get checkpoint;
}

abstract interface class SyncCollection {
  String get name;

  Future<SyncCheckpoint> readCheckpoint();

  /// Checkpoint vazio inicia bootstrap; caso contrário retoma a coleção.
  Future<SyncPage> fetchPage(SyncCheckpoint checkpoint);

  /// Grava dados por upsert e checkpoint na MESMA transação local.
  /// Deve reverter ambos em qualquer falha. Categorias precedem produtos.
  /// Usa o mesmo banco da lease que protege esta chamada na engine.
  Future<void> commitPage(SyncPage page);
}
