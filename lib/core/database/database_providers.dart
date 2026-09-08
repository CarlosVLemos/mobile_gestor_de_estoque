import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// Fornecido somente pela sessão validada e isolada (Spec 008B).
/// null mantém o modo demonstrativo; não abre banco anônimo.
final operationalDatabaseProvider = Provider<AppDatabase?>((ref) => null);
