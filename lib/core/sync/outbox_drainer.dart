typedef OutboxWriteGuard = Future<void> Function(
  Future<void> Function() write,
);

abstract interface class OutboxDrainer {
  Future<void> drain({required OutboxWriteGuard protect});
  void cancel();
}
