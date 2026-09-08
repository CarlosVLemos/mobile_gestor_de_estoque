import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/network/api_client.dart';
import 'application/use_cases/auth_use_cases.dart';
import 'data/local/secure_token_storage.dart';
import 'data/remote/auth_remote_data_source.dart';
import 'data/repositories/sanctum_auth_repository.dart';
import 'domain/repositories/auth_repository.dart';

final secureTokenStorageProvider = Provider<SecureTokenStorage>(
  (ref) => SecureTokenStorage(const FlutterSecureStorage()),
);
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(ref.watch(apiClientProvider)),
);
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => SanctumAuthRepository(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(secureTokenStorageProvider),
  ),
);
final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);
final restoreSessionUseCaseProvider = Provider<RestoreSessionUseCase>(
  (ref) => RestoreSessionUseCase(ref.watch(authRepositoryProvider)),
);
final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>(
  (ref) => ChangePasswordUseCase(ref.watch(authRepositoryProvider)),
);
