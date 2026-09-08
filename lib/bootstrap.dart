import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/arara_app.dart';
import 'app/sync/read_sync_providers.dart';
import 'app/sync/read_sync_scope.dart';
import 'core/sync/sync_providers.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(
    overrides: [
      syncEngineProvider.overrideWith((ref) => ref.watch(readSyncEngineProvider)),
    ],
    child: const ReadSyncScope(child: AraraApp()),
  ));
}
