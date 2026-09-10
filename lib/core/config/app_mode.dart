import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppMode {
  normal,
  demo;

  static AppMode fromEnvironment() {
    const raw = String.fromEnvironment('APP_MODE', defaultValue: 'normal');
    final value = raw.trim().isEmpty ? 'normal' : raw.trim();

    switch (value) {
      case 'normal':
        return AppMode.normal;
      case 'demo':
        return AppMode.demo;
      default:
        throw StateError(
          'Valor de APP_MODE inválido: "$raw". Use "normal" ou "demo".',
        );
    }
  }

  bool get isDemo => this == AppMode.demo;
  bool get isNormal => this == AppMode.normal;
}

final appModeProvider = Provider<AppMode>((ref) {
  return AppMode.fromEnvironment();
});
