import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/demo/demo_seed_collection.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/sync/sync_collection.dart';

void main() {
  test(
    'seed demo v5 é idempotente e persiste IDs contract-realistic',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final collection = DemoSeedCollection(database: database);

      await collection.commitPage(
        await collection.fetchPage(const SyncCheckpoint()),
      );
      await collection.commitPage(
        await collection.fetchPage(await collection.readCheckpoint()),
      );

      expect(
        (await database.select(database.productsTable).get()).map((e) => e.id),
        containsAll(['101', '102']),
      );
      expect(
        (await database.select(database.clientsTable).get()).map((e) => e.id),
        containsAll(['201', '202']),
      );
      expect(
        await database.select(database.categoriesTable).get(),
        hasLength(1),
      );
      expect(await database.select(database.clientsTable).get(), hasLength(2));
      expect((await collection.readCheckpoint()).checkpoint, 'seeded');
    },
  );
}
