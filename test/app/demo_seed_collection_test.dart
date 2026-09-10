import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/demo/demo_seed_collection.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';

void main() {
  late AppDatabase database;
  late DemoSeedCollection collection;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    collection = DemoSeedCollection(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  test('seeds categories, products and dashboard snapshot idempotently', () async {
    final initialCheckpoint = await collection.readCheckpoint();
    expect(initialCheckpoint.checkpoint, isNull);

    final page = await collection.fetchPage(initialCheckpoint);
    expect(page.hasMore, isTrue);
    expect(page.checkpoint.checkpoint, equals('seeded'));

    await collection.commitPage(page);

    final seededCheckpoint = await collection.readCheckpoint();
    expect(seededCheckpoint.checkpoint, equals('seeded'));

    final categories = await database.select(database.categoriesTable).get();
    expect(categories, hasLength(3));
    expect(categories.any((c) => c.id == '550e8400-e29b-41d4-a716-446655440000'), isTrue);

    final products = await database.select(database.productsTable).get();
    expect(products, hasLength(4));
    expect(products.any((p) => p.id == '101' && p.sku == 'BEB-001'), isTrue);

    final dashboardRows = await database.select(database.dashboardSnapshotsTable).get();
    expect(dashboardRows, hasLength(1));

    // Test idempotency on subsequent fetch/commit
    final secondPage = await collection.fetchPage(seededCheckpoint);
    expect(secondPage.hasMore, isFalse);
    await collection.commitPage(secondPage);

    final categoriesAfter = await database.select(database.categoriesTable).get();
    expect(categoriesAfter, hasLength(3));
  });
}
