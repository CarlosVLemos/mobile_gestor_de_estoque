/// In-isolate exclusion. A context composition owns and shares one instance.
class SyncLock {
  bool _isHeld = false;

  bool tryAcquire() {
    if (_isHeld) return false;
    _isHeld = true;
    return true;
  }

  void release() => _isHeld = false;
}
