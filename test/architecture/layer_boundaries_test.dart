import 'package:flutter_test/flutter_test.dart';

import 'architecture_validator.dart';

void main() {
  test('o código atual respeita as fronteiras arquiteturais', () {
    final violations = validateArchitecture(readLibSources());

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  group('o validador rejeita imports proibidos', () {
    final cases = <String, Map<String, String>>{
      'presentation com Dio': {
        'lib/features/catalog/presentation/pages/page.dart':
            "import 'package:dio/dio.dart';",
      },
      'presentation com data': {
        r'lib\features\catalog\presentation\controllers\controller.dart':
            "import '../../data/repositories/catalog_repository.dart';",
      },
      'application com Flutter': {
        'lib/features/catalog/application/use_cases/load.dart':
            "import 'package:flutter/widgets.dart';",
      },
      'application com DTO': {
        'lib/features/catalog/application/services/service.dart':
            "import '../../data/dto/product_dto.dart';",
      },
      'domain com JSON': {
        'lib/features/catalog/domain/entities/product.dart':
            "import 'dart:convert';",
      },
      'domain com persistência': {
        'lib/features/catalog/domain/repositories/repository.dart':
            "import '../../data/local/product_dao.dart';",
      },
      'data com widget': {
        'lib/features/catalog/data/mappers/mapper.dart':
            "import '../../presentation/widgets/product_card.dart';",
      },
      'core com feature': {
        'lib/core/network/client.dart':
            "import 'package:gestor_de_estoque/features/catalog/domain/entities/product.dart';",
      },
      'shared com feature': {
        'lib/shared/widgets/card.dart':
            "import '../../features/catalog/presentation/state/catalog_state.dart';",
      },
      'app com DTO': {
        'lib/app/router/route.dart':
            "import '../../features/catalog/data/dto/product_dto.dart';",
      },
      'acesso entre features': {
        'lib/features/sales/domain/entities/sale.dart':
            "import '../../../catalog/domain/entities/product.dart';",
      },
      'página com DAO': {
        'lib/features/catalog/presentation/pages/catalog_page.dart':
            "import '../../data/local/product_dao.dart';",
      },
    };

    for (final entry in cases.entries) {
      test(entry.key, () {
        final violations = validateArchitecture(entry.value);

        expect(
          violations,
          isNotEmpty,
          reason: 'A amostra deveria violar ao menos uma fronteira.',
        );
        expect(violations.first.file, startsWith('lib/'));
        expect(violations.first.rule, isNotEmpty);
      });
    }
  });

  test('aceita dependências permitidas e paths Unix ou Windows', () {
    final sources = {
      'lib/features/catalog/presentation/controllers/controller.dart':
          "import '../../application/use_cases/load_catalog.dart';",
      r'lib\features\catalog\application\use_cases\load_catalog.dart':
          "import '../../domain/repositories/catalog_repository.dart';",
      'lib/features/catalog/data/repositories/catalog_repository.dart':
          "import '../../domain/repositories/catalog_repository.dart';",
    };

    expect(validateArchitecture(sources), isEmpty);
    expect(
      normalizeProjectPath(r'lib\features\catalog'),
      'lib/features/catalog',
    );
    expect(
      normalizeProjectPath('lib/features/catalog'),
      'lib/features/catalog',
    );
  });
}
