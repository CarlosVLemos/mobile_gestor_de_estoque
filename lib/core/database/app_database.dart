import 'package:drift/drift.dart';

import 'tables/categories_table.dart';
import 'tables/dashboard_tables.dart';
import 'tables/products_table.dart';
import 'tables/sync_checkpoints_table.dart';
import 'tables/sync_locks_table.dart';

part 'app_database.g.dart';

/// Schema inicial, ainda sem conexão ao bootstrap do aplicativo.
///
/// O executor deve pertencer exclusivamente ao contexto autenticado ativo.
/// A abertura de arquivos aguarda a estratégia de isolamento da Spec 008B.
@DriftDatabase(
  tables: [
    CategoriesTable,
    ProductsTable,
    SyncCheckpointsTable,
    SyncLocksTable,
    DashboardKpisTable,
    DashboardStockAlertsTable,
    DashboardSnapshotsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      // Não recriar o banco nem descartar dados diante de versão inesperada.
      throw StateError('Migração de schema $from para $to não implementada.');
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
