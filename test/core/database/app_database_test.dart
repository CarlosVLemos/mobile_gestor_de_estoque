import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart' show SqliteException;

void main() {
  late AppDatabase database;
  final updatedAt = DateTime.utc(2026, 9, 8, 12);

  ProductsTableCompanion product({
    String? categoryId,
    double? price,
  }) => ProductsTableCompanion.insert(
    id: 'product-1',
    name: 'Produto',
    sku: 'SKU-1',
    brand: 'Marca',
    price: Value(price),
    stockQuantity: 0,
    stockStatus: 'out',
    isAvailableForSale: false,
    categoryId: Value(categoryId),
    updatedAt: updatedAt,
  );

  Future<void> insertCategory() => database
      .into(database.categoriesTable)
      .insert(CategoriesTableCompanion.insert(id: 'category-1', name: 'Peças'))
      .then((_) {});

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('CRUD de categorias e produtos preserva preço nulo e estoque zero', () async {
    await insertCategory();
    await database.into(database.productsTable).insert(
      product(categoryId: 'category-1', price: 49.9),
    );
    var stored = await database.select(database.productsTable).getSingle();
    expect(stored.price, 49.9);
    expect(stored.categoryId, 'category-1');
    expect(stored.updatedAt.toUtc(), updatedAt);

    await database.into(database.productsTable).insertOnConflictUpdate(
      product(categoryId: 'category-1'),
    );
    stored = await database.select(database.productsTable).getSingle();
    expect(stored.price, isNull);
    expect(stored.stockQuantity, 0);
    expect(stored.isAvailableForSale, isFalse);

    await database.into(database.categoriesTable).insertOnConflictUpdate(
      CategoriesTableCompanion.insert(id: 'category-1', name: 'Acessórios'),
    );
    expect(
      (await database.select(database.categoriesTable).getSingle()).name,
      'Acessórios',
    );
    await database.delete(database.productsTable).go();
    expect(await database.select(database.productsTable).get(), isEmpty);
    expect(await database.select(database.categoriesTable).get(), hasLength(1));
  });

  test('categoria deve existir antes do produto e exclusão aplica SET NULL', () async {
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
    expect(await database.select(database.categoriesTable).get(), isEmpty);
    expect(
      (await database.select(database.productsTable).getSingle()).categoryId,
      isNull,
    );
  });

  test('checkpoints suportam bootstrap, atualização e exclusão por coleção', () async {
    await database.into(database.syncCheckpointsTable).insert(
      SyncCheckpointsTableCompanion.insert(collectionName: 'products'),
    );
    final initial = await database.select(database.syncCheckpointsTable).getSingle();
    expect(initial.lastSyncedAt, isNull);
    expect(initial.cursor, isNull);
    await database.into(database.syncCheckpointsTable).insertOnConflictUpdate(
      SyncCheckpointsTableCompanion.insert(
        collectionName: 'products',
        lastSyncedAt: Value(updatedAt),
        cursor: const Value('page-2'),
      ),
    );
    final stored = await database.select(database.syncCheckpointsTable).getSingle();
    expect(stored.lastSyncedAt!.toUtc(), updatedAt);
    expect(stored.cursor, 'page-2');
    await database.delete(database.syncCheckpointsTable).go();
    expect(await database.select(database.syncCheckpointsTable).get(), isEmpty);
  });

  test('falha de página reverte dados e preserva checkpoint anterior', () async {
    await database.into(database.syncCheckpointsTable).insert(
      SyncCheckpointsTableCompanion.insert(
        collectionName: 'products',
        cursor: const Value('page-1'),
      ),
    );
    await expectLater(
      database.transaction(() async {
        await insertCategory();
        await database.into(database.syncCheckpointsTable).insertOnConflictUpdate(
          SyncCheckpointsTableCompanion.insert(
            collectionName: 'products',
            cursor: const Value('page-2'),
          ),
        );
        await database.into(database.productsTable).insert(
          product(categoryId: 'missing'),
        );
      }),
      throwsA(isA<SqliteException>()),
    );
    expect(await database.select(database.categoriesTable).get(), isEmpty);
    expect(await database.select(database.productsTable).get(), isEmpty);
    expect(
      (await database.select(database.syncCheckpointsTable).getSingle()).cursor,
      'page-1',
    );
  });

  test('arquivo preserva produto após fechar e reabrir o banco', () async {
    final directory = await Directory.systemTemp.createTemp('arara-database-');
    try {
      final file = File('${directory.path}/test.sqlite');
      final first = AppDatabase(NativeDatabase(file));
      try {
        await first.into(first.productsTable).insert(product());
      } finally {
        await first.close();
      }
      final reopened = AppDatabase(NativeDatabase(file));
      try {
        final stored = await reopened.select(reopened.productsTable).getSingle();
        expect(stored.id, 'product-1');
        expect(stored.price, isNull);
      } finally {
        await reopened.close();
      }
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
