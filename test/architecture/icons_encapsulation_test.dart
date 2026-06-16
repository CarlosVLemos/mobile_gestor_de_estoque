import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('LucideIcons is only imported in app_icons.dart', () {
    final dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final file in dartFiles) {
      final normalized = file.path.replaceAll('\\', '/');
      if (normalized.endsWith('lib/app/theme/app_icons.dart')) {
        continue;
      }

      final contents = file.readAsStringSync();
      final hasLucideImport =
          contents.contains('lucide_icons_flutter') ||
          contents.contains('LucideIcons');

      expect(
        hasLucideImport,
        isFalse,
        reason:
            'Uso direto de LucideIcons ou importacao de lucide_icons_flutter em $normalized. Use AppIcons.',
      );
    }
  });

  test('Material Icons is not used in features or shared folders', () {
    final targetDirs = ['lib/features', 'lib/shared'];
    for (final dirPath in targetDirs) {
      final dir = Directory(dirPath);
      if (!dir.existsSync()) continue;

      final dartFiles = dir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'));

      for (final file in dartFiles) {
        final normalized = file.path.replaceAll('\\', '/');
        final contents = file.readAsStringSync();

        final hasMaterialIconsUsage = contents.contains(
          RegExp(r'(?<![A-Za-z])Icons\.'),
        );

        expect(
          hasMaterialIconsUsage,
          isFalse,
          reason:
              'Uso direto de Material Icons (Icons.*) em $normalized. Encapsule em AppIcons.',
        );
      }
    }
  });
}
