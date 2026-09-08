import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import 'app_database.dart';
import 'local_context.dart';

typedef DirectoryProvider = Future<Directory> Function();
typedef AppDatabaseBuilder = AppDatabase Function(QueryExecutor executor);
typedef QueryExecutorBuilder = Future<QueryExecutor> Function(String path);

/// Owns exactly one open database connection. A caller must close a context
/// before activating a different user/tenant pair.
class DatabaseFactory {
  DatabaseFactory({
    DirectoryProvider? documentsDirectory,
    DirectoryProvider? temporaryDirectory,
    AppDatabaseBuilder? databaseBuilder,
    QueryExecutorBuilder? queryExecutorBuilder,
  }) : _documentsDirectory =
           documentsDirectory ?? getApplicationDocumentsDirectory,
       _databaseBuilder = databaseBuilder ?? AppDatabase.new,
       _queryExecutorBuilder =
           queryExecutorBuilder ??
           ((databasePath) async {
             final tempDirectory =
                 await (temporaryDirectory ?? getTemporaryDirectory)();
             sqlite3.tempDirectory = tempDirectory.path;
             return NativeDatabase.createInBackground(File(databasePath));
           });

  final DirectoryProvider _documentsDirectory;
  final AppDatabaseBuilder _databaseBuilder;
  final QueryExecutorBuilder _queryExecutorBuilder;

  AppDatabase? _activeDatabase;
  LocalContext? _activeContext;
  Future<AppDatabase>? _openingDatabase;
  LocalContext? _openingContext;

  AppDatabase? get activeDatabase => _activeDatabase;
  LocalContext? get activeContext => _activeContext;

  Future<String> databasePathFor(LocalContext context) async {
    final directory = await _documentsDirectory();
    return path.join(directory.path, context.databaseFileName);
  }

  Future<AppDatabase> open(LocalContext context) async {
    final current = _activeDatabase;
    if (current != null) {
      if (_activeContext == context) return current;
      throw StateError(
        'O banco do contexto anterior deve ser fechado antes de trocar de contexto.',
      );
    }

    final opening = _openingDatabase;
    if (opening != null) {
      if (_openingContext == context) return opening;
      throw StateError(
        'O banco do contexto anterior ainda estÃ¡ sendo aberto.',
      );
    }

    final next = _openNew(context);
    _openingDatabase = next;
    _openingContext = context;
    try {
      return await next;
    } finally {
      _openingDatabase = null;
      _openingContext = null;
    }
  }

  Future<AppDatabase> _openNew(LocalContext context) async {
    final databasePath = await databasePathFor(context);
    final database = _databaseBuilder(
      LazyDatabase(() async {
        return _queryExecutorBuilder(databasePath);
      }),
    );

    try {
      // Forces the lazy executor to open only after an authenticated context
      // has been supplied to this factory.
      await database.customSelect('SELECT 1').get();
    } catch (_) {
      await database.close();
      rethrow;
    }

    _activeContext = context;
    _activeDatabase = database;
    return database;
  }

  Future<void> closeActive() async {
    final opening = _openingDatabase;
    if (opening != null) await opening;
    final database = _activeDatabase;
    if (database == null) return;

    await database.close();
    _activeDatabase = null;
    _activeContext = null;
  }
}
