import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/shell/shell_profile.dart';
import 'package:gestor_de_estoque/app/theme/app_theme_mode_controller.dart';

void main() {
  test('tema alterna a partir do brilho efetivo do sistema', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(appThemeModeProvider.notifier);

    expect(container.read(appThemeModeProvider), ThemeMode.system);

    controller.toggle(Brightness.light);
    expect(container.read(appThemeModeProvider), ThemeMode.dark);

    controller.toggle(Brightness.light);
    expect(container.read(appThemeModeProvider), ThemeMode.light);
  });

  test('nome local é normalizado e entrada vazia é ignorada', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(
      shellDisplayNameControllerProvider.notifier,
    );
    final originalName = container.read(shellProfileProvider).userName;

    controller.updateName('   ');
    expect(container.read(shellProfileProvider).userName, originalName);

    controller.updateName('  Maria Campo  ');
    expect(container.read(shellDisplayNameControllerProvider), 'Maria Campo');
    final profile = container.read(shellProfileProvider);
    expect(profile.userName, 'Maria Campo');
    expect(
      () => profile.permissions['products_view'] = false,
      throwsUnsupportedError,
    );
  });
}
