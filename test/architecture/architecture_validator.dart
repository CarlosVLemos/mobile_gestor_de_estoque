import 'dart:io';

class ArchitectureViolation {
  const ArchitectureViolation({
    required this.file,
    required this.layer,
    required this.rule,
    required this.import,
  });

  final String file;
  final String layer;
  final String rule;
  final String import;

  @override
  String toString() => '$file [$layer] $rule: $import';
}

List<ArchitectureViolation> validateArchitecture(Map<String, String> sources) {
  final violations = <ArchitectureViolation>[];

  for (final entry in sources.entries) {
    final sourcePath = normalizeProjectPath(entry.key);
    final layer = _layerOf(sourcePath);
    final imports = _importsFrom(entry.value);

    for (final import in imports) {
      final target = _resolveImport(sourcePath, import);

      void report(String rule) {
        violations.add(
          ArchitectureViolation(
            file: sourcePath,
            layer: layer,
            rule: rule,
            import: import,
          ),
        );
      }

      if (layer == 'presentation') {
        if (_isPackage(import, 'dio') || _isPackage(import, 'drift')) {
          report('presentation não pode importar transporte ou persistência');
        }
        if (target.contains('/data/')) {
          report('presentation não pode importar detalhes de data');
        }
        if (_isDaoOrRemoteSource(target)) {
          report('presentation não pode importar DAO ou fonte remota');
        }
      }

      if (layer == 'application') {
        if (_isFlutter(import)) {
          report('application não pode importar Flutter ou widgets');
        }
        if (_isPackage(import, 'dio') || _isPackage(import, 'drift')) {
          report('application não pode importar transporte ou persistência');
        }
        if (target.contains('/data/')) {
          report('application não pode importar DTO ou implementação de data');
        }
      }

      if (layer == 'domain') {
        if (_isFlutter(import) ||
            _isPackage(import, 'dio') ||
            _isPackage(import, 'drift') ||
            import == 'dart:convert' ||
            target.contains('/data/')) {
          report('domain deve permanecer independente de detalhes técnicos');
        }
      }

      if (layer == 'data' && _isVisualPresentationTarget(target)) {
        report('data não pode importar apresentação visual');
      }

      if (layer == 'core' && target.startsWith('lib/features/')) {
        report('core não pode importar features');
      }

      if (layer == 'shared' && target.startsWith('lib/features/')) {
        report('shared não pode importar detalhes de features');
      }

      if (layer == 'app' &&
          (target.contains('/data/dto/') ||
              target.contains('/data/local/') ||
              target.contains('/data/remote/') ||
              _isDaoOrRemoteSource(target))) {
        report('app não pode importar DTO, DAO ou fonte remota');
      }

      final sourceFeature = _featureOf(sourcePath);
      final targetFeature = _featureOf(target);
      if (sourceFeature != null &&
          targetFeature != null &&
          sourceFeature != targetFeature) {
        report('uma feature não pode importar detalhes internos de outra');
      }

      if (sourcePath.contains('/presentation/pages/') &&
          (target.contains('/data/') || _isDaoOrRemoteSource(target))) {
        report('páginas não podem acessar repositórios concretos, DAO ou API');
      }
    }
  }

  return violations;
}

Map<String, String> readLibSources() {
  final sources = <String, String>{};
  final root = normalizeProjectPath(Directory.current.path);

  for (final entity in Directory('lib').listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }

    final path = normalizeProjectPath(entity.path);
    final relativePath = path.startsWith('$root/')
        ? path.substring(root.length + 1)
        : path;
    sources[relativePath] = entity.readAsStringSync();
  }

  return sources;
}

String normalizeProjectPath(String path) => path.replaceAll('\\', '/');

Iterable<String> _importsFrom(String source) {
  final expression = RegExp("""import\\s+['"]([^'"]+)['"]""");
  return expression.allMatches(source).map((match) => match.group(1)!);
}

String _resolveImport(String sourcePath, String import) {
  if (import.startsWith('package:gestor_de_estoque/')) {
    return 'lib/${import.substring('package:gestor_de_estoque/'.length)}';
  }
  if (import.startsWith('package:') || import.startsWith('dart:')) {
    return import;
  }

  final separator = sourcePath.lastIndexOf('/');
  final sourceDirectory = sourcePath.substring(0, separator + 1);
  return normalizeProjectPath(Uri.parse(sourceDirectory).resolve(import).path);
}

String _layerOf(String path) {
  for (final layer in ['presentation', 'application', 'domain', 'data']) {
    if (path.contains('/$layer/')) {
      return layer;
    }
  }
  if (path.startsWith('lib/core/')) {
    return 'core';
  }
  if (path.startsWith('lib/shared/')) {
    return 'shared';
  }
  if (path.startsWith('lib/app/')) {
    return 'app';
  }
  return 'root';
}

String? _featureOf(String path) {
  final match = RegExp(r'^lib/features/([^/]+)/').firstMatch(path);
  return match?.group(1);
}

bool _isPackage(String import, String package) {
  return import == 'package:$package' || import.startsWith('package:$package/');
}

bool _isFlutter(String import) => import.startsWith('package:flutter/');

bool _isDaoOrRemoteSource(String target) {
  final lower = target.toLowerCase();
  return lower.contains('/dao/') ||
      lower.endsWith('_dao.dart') ||
      lower.contains('/remote/') ||
      lower.endsWith('_remote_data_source.dart');
}

bool _isVisualPresentationTarget(String target) {
  return target.contains('/presentation/pages/') ||
      target.contains('/presentation/widgets/') ||
      target.contains('/presentation/controllers/') ||
      target.contains('/presentation/state/');
}
