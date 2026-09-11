import 'package:drift/native.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/core/database/app_database.dart';
import 'package:gestor_de_estoque/core/database/drift_sync_checkpoint_store.dart';
import 'package:gestor_de_estoque/core/network/api_client.dart';
import 'package:gestor_de_estoque/core/sync/sync_collection.dart';
import 'package:gestor_de_estoque/features/clients/data/remote/client_remote_data_source.dart';
import 'package:gestor_de_estoque/features/clients/data/sync/client_sync_collection.dart';

void main() {
  late AppDatabase database;
  setUp(() => database = AppDatabase(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('parseia ID inteiro como String e preserva city/state nulos', () {
    final page = RemoteClientPage(
      _page(
        data: [
          {'id': 123, 'name': 'Cliente', 'city': null, 'state': null},
        ],
      ),
    );
    expect(page.clients.single.id, '123');
    expect(page.clients.single.city, isNull);
    expect(page.clients.single.state, isNull);
    expect(page.snapshotUpperBoundId, 123);
  });

  test('rejeita ID textual e metadados de cursor incoerentes', () {
    expect(
      () => RemoteClientPage(
        _page(
          data: [
            {'id': '123', 'name': 'Cliente', 'city': null, 'state': null},
          ],
        ),
      ),
      throwsFormatException,
    );
    expect(
      () => RemoteClientPage(_page(hasMore: true, nextCursor: null)),
      throwsFormatException,
    );
  });

  test('datasource envia cursor opaco e paginação contratada', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    late RequestOptions request;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          request = options;
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: _page(upperBound: 0),
            ),
          );
        },
      ),
    );
    await ClientRemoteDataSource(
      ApiClient(dio),
      accessToken: 'token',
    ).fetch(cursor: 'opaque+tenant-bound');
    expect(request.path, '/api/mobile/clients');
    expect(request.queryParameters['per_page'], 50);
    expect(request.queryParameters['cursor'], 'opaque+tenant-bound');
    expect(request.headers['Authorization'], 'Bearer token');
  });

  test('snapshot interrompido persiste cursor e nunca poda clientes', () async {
    await database
        .into(database.clientsTable)
        .insert(ClientsTableCompanion.insert(id: '9', name: 'Legado'));
    final collection = ClientSyncCollection(
      database: database,
      remote: _Remote([
        _page(
          data: [
            {'id': 1, 'name': 'Primeiro', 'city': 'Belém', 'state': 'PA'},
          ],
          hasMore: true,
          nextCursor: 'opaque-page-2',
          upperBound: 2,
        ),
      ]),
    );
    final page = await collection.fetchPage(const SyncCheckpoint());
    await collection.commitPage(page);

    expect(
      (await database.select(database.clientsTable).get()).map((e) => e.id),
      containsAll(['1', '9']),
    );
    final checkpoint = await DriftSyncCheckpointStore(database).read('clients');
    expect(checkpoint.cursor, 'opaque-page-2');
    expect(checkpoint.targetCheckpoint, '2');
  });

  test(
    'restart retoma snapshot e poda ausência somente na página terminal',
    () async {
      await database
          .into(database.clientsTable)
          .insert(
            ClientsTableCompanion.insert(id: '9', name: 'Removido remotamente'),
          );
      final first = ClientSyncCollection(
        database: database,
        remote: _Remote([
          _page(
            data: [
              {'id': 1, 'name': 'Um', 'city': null, 'state': null},
            ],
            hasMore: true,
            nextCursor: 'opaque',
            upperBound: 2,
          ),
        ]),
      );
      await first.commitPage(await first.fetchPage(const SyncCheckpoint()));

      final saved = await DriftSyncCheckpointStore(database).read('clients');
      final resumed = ClientSyncCollection(
        database: database,
        remote: _Remote([
          _page(
            data: [
              {'id': 2, 'name': 'Dois', 'city': 'Rio', 'state': 'RJ'},
            ],
            upperBound: 2,
          ),
        ]),
      );
      await resumed.commitPage(await resumed.fetchPage(saved));

      final rows = await database.select(database.clientsTable).get();
      expect(rows.map((e) => e.id), unorderedEquals(['1', '2']));
      expect(
        await database.select(database.clientSnapshotEntriesTable).get(),
        isEmpty,
      );
      final completed = await DriftSyncCheckpointStore(
        database,
      ).read('clients');
      expect(completed.cursor, isNull);
      expect(completed.checkpoint, '2');
      expect(completed.isBootstrapped, isTrue);
    },
  );

  test('snapshot completo vazio reconcilia hard delete por ausência', () async {
    await database
        .into(database.clientsTable)
        .insert(ClientsTableCompanion.insert(id: '1', name: 'Excluído'));
    final collection = ClientSyncCollection(
      database: database,
      remote: _Remote([_page(upperBound: 0)]),
    );
    await collection.commitPage(
      await collection.fetchPage(const SyncCheckpoint()),
    );
    expect(await database.select(database.clientsTable).get(), isEmpty);
  });
}

class _Remote extends ClientRemoteDataSource {
  _Remote(this.pages) : super(ApiClient(Dio()), accessToken: 'token');
  final List<Map<String, dynamic>> pages;
  final cursors = <String?>[];

  @override
  Future<RemoteClientPage> fetch({String? cursor}) async {
    cursors.add(cursor);
    return RemoteClientPage(pages.removeAt(0));
  }
}

Map<String, dynamic> _page({
  List<Map<String, dynamic>> data = const [],
  bool hasMore = false,
  String? nextCursor,
  int upperBound = 123,
}) => {
  'data': data,
  'meta': {
    'next_cursor': nextCursor,
    'has_more': hasMore,
    'snapshot_upper_bound_id': upperBound,
  },
};
