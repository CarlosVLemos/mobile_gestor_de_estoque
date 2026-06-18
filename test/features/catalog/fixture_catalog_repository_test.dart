import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/features/catalog/data/repositories/fixture_catalog_repository.dart';
import 'package:gestor_de_estoque/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:gestor_de_estoque/features/catalog/domain/value_objects/catalog_query.dart';

void main() {
  const repository = FixtureCatalogRepository();

  test('busca por SKU sem diferenciar maiúsculas', () async {
    final result = await repository.load(const CatalogQuery(search: 'sku-led'));

    expect(result.status, CatalogLoadStatus.ready);
    expect(result.items, hasLength(1));
    expect(result.items.single.sku, 'SKU-LED-443');
  });

  test(
    'filtra categoria e retorna vazio para combinação sem resultado',
    () async {
      final filtered = await repository.load(
        const CatalogQuery(category: 'Proteção'),
      );
      final empty = await repository.load(
        const CatalogQuery(search: 'inexistente', category: 'Proteção'),
      );

      expect(filtered.status, CatalogLoadStatus.ready);
      expect(
        filtered.items.every((item) => item.categoryName == 'Proteção'),
        isTrue,
      );
      expect(empty.status, CatalogLoadStatus.empty);
      expect(empty.items, isEmpty);
    },
  );

  test('rejeita filtro longo como entrada inválida', () async {
    final result = await repository.load(
      CatalogQuery(search: List.filled(41, 'a').join()),
    );

    expect(result.status, CatalogLoadStatus.invalidFilter);
    expect(result.message, isNotEmpty);
  });

  test('mantém produtos sem preço e sem estoque no catálogo', () async {
    final result = await repository.load(const CatalogQuery());

    expect(result.status, CatalogLoadStatus.ready);
    expect(result.items.any((item) => item.price == null), isTrue);
    expect(result.items.any((item) => item.stockQuantity == 0), isTrue);
  });
}
