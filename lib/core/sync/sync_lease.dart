/// Lock entre executores do mesmo contexto local.
abstract interface class SyncLeaseStore {
  Future<SyncLease?> tryAcquire();
}

abstract interface class SyncLease {
  /// Valida/renova a posse e executa a escrita na mesma transação.
  /// O callback só pode escrever no banco associado à lease, sem acessar rede.
  Future<void> protect(Future<void> Function() write);

  /// Remove somente a aquisição representada por esta lease.
  Future<void> release();
}

class SyncLeaseLost implements Exception {
  const SyncLeaseLost();
}
