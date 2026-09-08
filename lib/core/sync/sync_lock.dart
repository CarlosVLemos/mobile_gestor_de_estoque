/// Exclusão síncrona no isolate. Deve ser compartilhada pelas engines do contexto.
/// A engine combina este mutex com a lease persistida do adaptador de banco.
class SyncLock {
  bool _isHeld = false;

  bool tryAcquire() {
    if (_isHeld) return false;
    _isHeld = true;
    return true;
  }

  void release() {
    _isHeld = false;
  }
}
