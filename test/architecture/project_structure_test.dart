import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'architecture_validator.dart';

void main() {
  test('a árvore canônica está materializada', () {
    for (final path in _requiredDirectories()) {
      expect(
        Directory(path).existsSync(),
        isTrue,
        reason: 'Diretório obrigatório ausente: $path',
      );
    }
  });

  test('.gitkeep existe apenas em diretórios sem implementação', () {
    for (final path in _requiredEmptyDirectories()) {
      final entries = Directory(path).listSync();
      final hasImplementation = entries.any(
        (entry) => entry is File && entry.path.endsWith('.dart'),
      );

      if (hasImplementation) {
        expect(
          File('$path/.gitkeep').existsSync(),
          isFalse,
          reason: 'Diretório com código ainda contém .gitkeep: $path',
        );
      } else {
        expect(entries, hasLength(1), reason: 'Marcador inválido em $path');
        expect(
          normalizeProjectPath(entries.single.path),
          endsWith('/.gitkeep'),
          reason: 'Diretório vazio sem .gitkeep: $path',
        );
      }
    }

    for (final path in _implementedDirectories) {
      expect(
        File('$path/.gitkeep').existsSync(),
        isFalse,
        reason: 'Diretório com código ainda contém .gitkeep: $path',
      );
    }
  });

  test('a lista estrutural funciona com separadores Windows e Unix', () {
    final unix = _requiredDirectories().map(normalizeProjectPath).toSet();
    final windows = _requiredDirectories()
        .map((path) => path.replaceAll('/', r'\'))
        .map(normalizeProjectPath)
        .toSet();

    expect(windows, unix);
  });
}

const _features = [
  'auth',
  'catalog',
  'clients',
  'dashboard',
  'inventory',
  'reports',
  'sales',
  'settings',
];

const _featureDirectories = [
  'domain/entities',
  'domain/failures',
  'domain/repositories',
  'domain/value_objects',
  'application/services',
  'application/use_cases',
  'data/dto',
  'data/local',
  'data/mappers',
  'data/remote',
  'data/repositories',
  'presentation/controllers',
  'presentation/pages',
  'presentation/state',
  'presentation/widgets',
];

const _coreDirectories = [
  'auth',
  'background',
  'config',
  'database',
  'errors',
  'images',
  'logging',
  'network',
  'result',
  'security',
  'sync',
];

const _sharedDirectories = ['formatters', 'ui_states', 'validators', 'widgets'];

const _implementedDirectories = [
  'lib/app',
  'lib/app/localization',
  'lib/app/router',
  'lib/app/startup',
  'lib/app/theme',
];

Iterable<String> _requiredDirectories() sync* {
  yield* _implementedDirectories;
  yield* _requiredEmptyDirectories();
}

Iterable<String> _requiredEmptyDirectories() sync* {
  for (final directory in _coreDirectories) {
    yield 'lib/core/$directory';
  }
  for (final directory in _sharedDirectories) {
    yield 'lib/shared/$directory';
  }
  for (final feature in _features) {
    for (final directory in _featureDirectories) {
      yield 'lib/features/$feature/$directory';
    }
  }
}
