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

  test('banco novo cria o schema v4 completo', () async {
    final rows = await database.customSelect(
      "SELECT name FROM sqlite_master WHERE type = 'table'",
    ).get();

    expect(database.schemaVersion, 4);
    expect(
      rows.map((row) => row.read<String>('name')),
      containsAll(<String>[
        'sync_outbox',
        'categories',
        'products',
        'dashboard_snapshots',
        'sync_collections',
        'sync_locks',
        'local_sales',
        'local_sale_items',
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

  test('migração v1 para v4 preserva linha pendente da sync_outbox', () async {
    final directory = await Directory.systemTemp.createTemp('arara-v1-to-v2-');
    final file = File('${directory.path}${Platform.pathSeparator}context.db');
    final legacy = sqlite3.open(file.path);
    legacy
      ..execute('CREATE TABLE sync_outbox (id TEXT NOT NULL PRIMARY KEY, status TEXT NOT NULL)')
      ..execute("INSERT INTO sync_outbox (id, status) VALUES ('sale-pending', 'pending')")
      ..execute('PRAGMA user_version = 1')
      ..close();

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
      expect(version.read<int>('user_version'), 4);
      expect(
        tables.map((row) => row.read<String>('name')),
        containsAll(<String>[
          'sync_outbox',
          'categories',
          'products',
          'dashboard_snapshots',
          'sync_collections',
          'sync_locks',
          'local_sales',
          'local_sale_items',
        ]),
      );
    } finally {
      await upgraded.close();
      await directory.delete(recursive: true);
    }
  });

  test('migração v2 para v4 preserva 009A e adiciona schema 010', () async {
    final directory = await Directory.systemTemp.createTemp('arara-v2-to-v3-');
    final file = File('${directory.path}${Platform.pathSeparator}context.db');
    final legacy = sqlite3.open(file.path);
    legacy
      ..execute('CREATE TABLE sync_outbox (id TEXT NOT NULL PRIMARY KEY, status TEXT NOT NULL)')
      ..execute("INSERT INTO sync_outbox VALUES ('sale-pending', 'pending')")
      ..execute('CREATE TABLE sync_collections (collection TEXT NOT NULL PRIMARY KEY, mode TEXT NOT NULL, cursor TEXT, checkpoint TEXT, target_checkpoint TEXT, revision TEXT, last_success_at INTEGER, is_bootstrapped INTEGER NOT NULL, total_received INTEGER NOT NULL, last_error TEXT)')
      ..execute("INSERT INTO sync_collections VALUES ('products', 'delta', 'opaque', NULL, NULL, NULL, NULL, 1, 8, NULL)")
      ..execute('PRAGMA user_version = 2')
      ..close();

    final upgraded = AppDatabase(NativeDatabase(file));
    try {
      expect((await upgraded.select(upgraded.syncOutbox).getSingle()).id, 'sale-pending');
      expect((await upgraded.readSyncCollection('products'))?.cursor, 'opaque');
      final locks = await upgraded.customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'sync_locks'",
      ).get();
      expect(locks, hasLength(1));
    } finally {
      await upgraded.close();
      await directory.delete(recursive: true);
    }
  });

  test('migração v3 para v4 preserva e evolui a sync_outbox', () async {
    final directory = await Directory.systemTemp.createTemp('arara-v3-to-v4-');
    final file = File('${directory.path}${Platform.pathSeparator}context.db');
    final legacy = sqlite3.open(file.path);
    legacy
      ..execute(
        'CREATE TABLE sync_outbox (id TEXT NOT NULL PRIMARY KEY, status TEXT NOT NULL)',
      )
      ..execute(
        'CREATE TABLE categories (id TEXT NOT NULL PRIMARY KEY, name TEXT NOT NULL)',
      )
      ..execute(
        'CREATE TABLE products (id TEXT NOT NULL PRIMARY KEY, name TEXT NOT NULL, sku TEXT NOT NULL, brand TEXT, price REAL, stock_quantity INTEGER NOT NULL, stock_status TEXT NOT NULL, is_available_for_sale INTEGER NOT NULL, image_url TEXT, category_id TEXT, remote_updated_at INTEGER, deleted_at INTEGER)',
      )
      ..execute(
        'CREATE TABLE dashboard_snapshots (scope_key TEXT NOT NULL PRIMARY KEY, period TEXT NOT NULL, group_by TEXT NOT NULL, page INTEGER NOT NULL, revision TEXT NOT NULL, generated_at INTEGER NOT NULL, reference_date TEXT NOT NULL, web_dashboard_url TEXT NOT NULL, can_view_financial INTEGER NOT NULL, payload_json TEXT NOT NULL)',
      )
      ..execute(
        'CREATE TABLE sync_collections (collection TEXT NOT NULL PRIMARY KEY, mode TEXT NOT NULL, cursor TEXT, checkpoint TEXT, target_checkpoint TEXT, revision TEXT, last_success_at INTEGER, is_bootstrapped INTEGER NOT NULL, total_received INTEGER NOT NULL, last_error TEXT)',
      )
      ..execute(
        'CREATE TABLE sync_locks (name TEXT NOT NULL PRIMARY KEY, owner_id TEXT NOT NULL, acquired_at INTEGER NOT NULL, expires_at INTEGER NOT NULL)',
      )
      ..execute(
        "INSERT INTO sync_outbox VALUES ('legacy-pending', 'pending')",
      )
      ..execute("INSERT INTO categories VALUES ('1', 'Categoria')")
      ..execute(
        "INSERT INTO products VALUES ('2', 'Produto', 'SKU-2', NULL, NULL, 1, 'available', 1, NULL, '1', NULL, NULL)",
      )
      ..execute(
        "INSERT INTO dashboard_snapshots VALUES ('day:2026-09:1', '2026-09', 'day', 1, 'r1', 1, '2026-09-09', 'https://example.test', 0, '{}')",
      )
      ..execute(
        "INSERT INTO sync_collections VALUES ('products', 'delta', 'cursor', NULL, NULL, NULL, NULL, 1, 1, NULL)",
      )
      ..execute("INSERT INTO sync_locks VALUES ('global', 'owner', 1, 2)")
      ..execute('PRAGMA user_version = 3')
      ..close();

    final upgraded = AppDatabase(NativeDatabase(file));
    try {
      final row = await upgraded.select(upgraded.syncOutbox).getSingle();
      expect(row.id, 'legacy-pending');
      expect(row.status, 'pending');
      expect(row.operationType, 'legacy_unknown');
      expect(row.clientRequestId, isNull);
      expect(row.payloadJson, '{}');
      expect(row.payloadVersion, 1);
      expect(row.attempts, 0);
      expect(
        await upgraded.customSelect('SELECT id FROM products').get(),
        hasLength(1),
      );
      expect(
        await upgraded.customSelect('SELECT scope_key FROM dashboard_snapshots').get(),
        hasLength(1),
      );
      expect((await upgraded.readSyncCollection('products'))?.cursor, 'cursor');
      expect(
        await upgraded.customSelect('SELECT name FROM sync_locks').get(),
        hasLength(1),
      );
      final indexes = await upgraded.customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'index'",
      ).get();
      expect(
        indexes.map((row) => row.read<String>('name')),
        containsAll(<String>[
          'sync_outbox_client_request_id_unique',
          'sync_outbox_local_operation_id_unique',
          'sync_outbox_eligibility',
        ]),
      );
      await upgraded.customStatement(
        "INSERT INTO sync_outbox (id, status, client_request_id) VALUES ('new-1', 'pending', 'duplicate')",
      );
      await expectLater(
        upgraded.customStatement(
          "INSERT INTO sync_outbox (id, status, client_request_id) VALUES ('new-2', 'pending', 'duplicate')",
        ),
        throwsA(isA<SqliteException>()),
      );
      expect(await upgraded.select(upgraded.localSalesTable).get(), isEmpty);
      expect(
        await upgraded.select(upgraded.localSaleItemsTable).get(),
        isEmpty,
      );
    } finally {
      await upgraded.close();
      await directory.delete(recursive: true);
    }
  });

  test('future migration without an explicit path fails closed', () async {
    await expectLater(
      database.migration.onUpgrade(Migrator(database), 4, 5),
      throwsA(isA<StateError>()),
    );
  });
}
