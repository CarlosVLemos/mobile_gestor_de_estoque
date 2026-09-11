import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppMode {
  normal,
  demo;

  static AppMode fromEnvironment() {
    const raw = String.fromEnvironment('APP_MODE', defaultValue: 'normal');
    return parse(raw);
  }

  static AppMode parse(String? raw) {
    final original = raw ?? '';
    final value = original.trim().isEmpty ? 'normal' : original.trim();
    return switch (value) {
      'normal' => AppMode.normal,
      'demo' => AppMode.demo,
      _ => throw StateError(
        'Valor de APP_MODE inválido: "$original". Use "normal" ou "demo".',
      ),
    };
  }

  bool get isDemo => this == AppMode.demo;
}

final appModeProvider = Provider<AppMode>((ref) => AppMode.fromEnvironment());
