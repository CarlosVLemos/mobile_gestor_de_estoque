import 'dart:io';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart' show SqliteException, sqlite3;

void main() {
  late AppDatabase database;
  final remoteUpdatedAt = DateTime.utc(2026, 9, 8, 12);

  ProductsTableCompanion product({
    String id = 'product-1',
    String? categoryId,
    String? brand,
    double? price,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) => ProductsTableCompanion.insert(
    id: id,
    name: 'Produto',
    sku: 'SKU-$id',
    brand: Value(brand),
    price: Value(price),
    stockQuantity: 0,
    stockStatus: 'out',
    isAvailableForSale: false,
    categoryId: Value(categoryId),
    remoteUpdatedAt: Value(updatedAt),
    deletedAt: Value(deletedAt),
  );

  Future<void> insertCategory() async {
    await database.into(database.categoriesTable).insert(
      CategoriesTableCompanion.insert(id: 'category-1', name: 'Peças'),
    );
  }

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('banco novo cria o schema v2 completo', () async {
    final rows = await database.customSelect(
      "SELECT name FROM sqlite_master WHERE type = 'table'",
    ).get();

    expect(database.schemaVersion, 2);
    expect(
      rows.map((row) => row.read<String>('name')),
      containsAll(<String>[
        'sync_outbox',
        'categories',
        'products',
        'dashboard_snapshots',
        'sync_collections',
      ]),
    );
  });

  test('produto preserva nulos e tombstone sai da consulta operacional', () async {
    await database.into(database.productsTable).insert(
      product(updatedAt: remoteUpdatedAt),
    );

    var stored = await database.select(database.productsTable).getSingle();
    expect(stored.brand, isNull);
    expect(stored.price, isNull);
    expect(stored.categoryId, isNull);
    expect(stored.imageUrl, isNull);
    expect(stored.remoteUpdatedAt?.toUtc(), remoteUpdatedAt);
    expect(await database.activeProducts().get(), hasLength(1));

    final deletedAt = DateTime.utc(2026, 9, 8, 13);
    await (database.update(database.productsTable)
          ..where((row) => row.id.equals('product-1')))
        .write(ProductsTableCompanion(deletedAt: Value(deletedAt)));

    stored = await database.select(database.productsTable).getSingle();
    expect(stored.deletedAt?.toUtc(), deletedAt);
    expect(await database.activeProducts().get(), isEmpty);
  });

  test('foreign key exige categoria e usa ON DELETE SET NULL', () async {
    await expectLater(
      database.into(database.productsTable).insert(
        product(categoryId: 'category-1'),
      ),
      throwsA(isA<SqliteException>()),
    );

    await insertCategory();
    await database.into(database.productsTable).insert(
      product(categoryId: 'category-1'),
    );
    await database.delete(database.categoriesTable).go();

    expect(
      (await database.select(database.productsTable).getSingle()).categoryId,
      isNull,
    );
  });

  test('snapshot composto pode ser observado por scope key', () async {
    const scopeKey = 'group_by=day&goal_month=2026-09&page=1';
    final nextRevision = database
        .watchDashboardSnapshot(scopeKey)
        .firstWhere((snapshot) => snapshot?.revision == 'revision-1');

    await database.into(database.dashboardSnapshotsTable).insert(
      DashboardSnapshotsTableCompanion.insert(
        scopeKey: scopeKey,
        period: '2026-09',
        groupBy: 'day',
        page: 1,
        revision: 'revision-1',
        generatedAt: remoteUpdatedAt,
        referenceDate: '2026-09-08',
        webDashboardUrl: 'https://example.test/dashboard',
        canViewFinancial: false,
        payloadJson: '{"version":1}',
      ),
    );

    final snapshot = await nextRevision;
    expect(snapshot?.scopeKey, scopeKey);
    expect(snapshot?.canViewFinancial, isFalse);
    expect(snapshot?.payloadJson, '{"version":1}');
  });

  test('sync_collections preserva cursor opaco e janela alvo', () async {
    await database.into(database.syncCollectionsTable).insert(
      SyncCollectionsTableCompanion.insert(
        collection: 'products',
        mode: 'delta',
        cursor: const Value('opaque.cursor.payload'),
        checkpoint: const Value('2026-09-08T10:00:00Z'),
        targetCheckpoint: const Value('2026-09-08T12:00:00Z'),
        revision: const Value('products-r1'),
        lastSuccessAt: Value(remoteUpdatedAt),
        isBootstrapped: true,
        totalReceived: 42,
        lastError: const Value(null),
      ),
    );

    final stored = await database.readSyncCollection('products');
    expect(stored?.cursor, 'opaque.cursor.payload');
    expect(stored?.checkpoint, '2026-09-08T10:00:00Z');
    expect(stored?.targetCheckpoint, '2026-09-08T12:00:00Z');
    expect(stored?.isBootstrapped, isTrue);
    expect(stored?.totalReceived, 42);
  });

  test('migração v1 para v2 preserva linha pendente da sync_outbox', () async {
    final directory = await Directory.systemTemp.createTemp('arara-v1-to-v2-');
    final file = File('${directory.path}${Platform.pathSeparator}context.db');
    final legacy = sqlite3.open(file.path);
    legacy
      ..execute('CREATE TABLE sync_outbox (id TEXT NOT NULL PRIMARY KEY, status TEXT NOT NULL)')
      ..execute("INSERT INTO sync_outbox (id, status) VALUES ('sale-pending', 'pending')")
      ..execute('PRAGMA user_version = 1')
      ..dispose();

    final upgraded = AppDatabase(NativeDatabase(file));
    try {
      final pending = await upgraded
          .select(upgraded.syncOutbox)
          .getSingle();
      final version = await upgraded.customSelect('PRAGMA user_version').getSingle();
      final tables = await upgraded.customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'table'",
      ).get();

      expect(pending.id, 'sale-pending');
      expect(pending.status, 'pending');
      expect(version.read<int>('user_version'), 2);
      expect(
        tables.map((row) => row.read<String>('name')),
        containsAll(<String>[
          'sync_outbox',
          'categories',
          'products',
          'dashboard_snapshots',
          'sync_collections',
        ]),
      );
    } finally {
      await upgraded.close();
      await directory.delete(recursive: true);
    }
  });
}
