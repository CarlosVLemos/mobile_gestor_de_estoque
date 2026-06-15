import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StartupStatus { loading, ready, failure }

class StartupState {
  const StartupState({required this.status, this.message});

  const StartupState.loading() : this(status: StartupStatus.loading);

  const StartupState.ready() : this(status: StartupStatus.ready);

  const StartupState.failure(String message)
    : this(status: StartupStatus.failure, message: message);

  final StartupStatus status;
  final String? message;
}

final startupControllerProvider =
    NotifierProvider<StartupController, StartupState>(StartupController.new);

class StartupController extends Notifier<StartupState> {
  var _initialized = false;

  @override
  StartupState build() {
    if (!_initialized) {
      _initialized = true;
      Future<void>.microtask(_bootstrap);
    }
    return const StartupState.loading();
  }

  Future<void> retry() => _bootstrap();

  Future<void> _bootstrap() async {
    state = const StartupState.loading();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    state = const StartupState.ready();
  }
}
