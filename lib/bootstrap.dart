import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/arara_app.dart';

import 'core/config/app_mode.dart';

void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  // Validate APP_MODE early to fail closed on invalid values.
  AppMode.fromEnvironment();
  runApp(const ProviderScope(child: AraraApp()));
}
