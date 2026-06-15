import 'package:flutter/material.dart';

import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';

class CatalogFilterBar extends StatelessWidget {
  const CatalogFilterBar({
    super.key,
    required this.searchValue,
    required this.categories,
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onCategorySelected,
  });

  final String searchValue;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.glassSurface(context),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: searchValue,
              onChanged: (value) => onSearchChanged(value),
              decoration: const InputDecoration(
                prefixIcon: Icon(AppIcons.search),
                hintText: 'Buscar por nome, marca ou SKU',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final category in categories) ...[
                    ChoiceChip(
                      label: Text(category),
                      selected: category == selectedCategory,
                      onSelected: (_) => onCategorySelected(category),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
