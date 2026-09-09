import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/database/drift_sync_checkpoint_store.dart';
import 'package:gestor_de_estoque/core/sync/sync_collection.dart';

void main() {
  late AppDatabase database;
  late DriftSyncCheckpointStore store;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    store = DriftSyncCheckpointStore(database);
  });

  tearDown(() => database.close());

  test('does not promote an opaque checkpoint when local persistence fails', () async {
    await expectLater(
      store.commitPage(
        collection: 'products',
        checkpoint: const SyncCheckpoint(mode: 'delta', cursor: 'opaque-next'),
        writeData: () async => throw StateError('local write failed'),
      ),
      throwsStateError,
    );
    expect((await store.read('products')).cursor, isNull);
  });

  test('promotes checkpoint only after local write completes', () async {
    var written = false;
    await store.commitPage(
      collection: 'products',
      checkpoint: const SyncCheckpoint(
        mode: 'delta',
        cursor: 'opaque-next',
        isBootstrapped: true,
        totalReceived: 20,
      ),
      writeData: () async => written = true,
    );
    expect(written, isTrue);
    expect((await store.read('products')).cursor, 'opaque-next');
  });
}
