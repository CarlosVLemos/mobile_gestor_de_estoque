import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';
import '../formatters/app_currency_formatter.dart';
import '../formatters/app_stock_formatter.dart';
import 'status_badge.dart';

enum ProductCardStockTone { available, low, out }

class ProductCardData {
  const ProductCardData({
    required this.name,
    required this.sku,
    required this.brand,
    required this.stockQuantity,
    required this.stockTone,
    required this.availableForSale,
    required this.updatedAtLabel,
    this.price,
    this.categoryName,
  });

  final String name;
  final String sku;
  final String brand;
  final int stockQuantity;
  final ProductCardStockTone stockTone;
  final bool availableForSale;
  final String updatedAtLabel;
  final double? price;
  final String? categoryName;
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.categoryIcon,
  });

  final ProductCardData product;
  final IconData categoryIcon;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final isTextLarge = textScaler.scale(1) > 1.3;

    final stockTone = _stockBadgeTone(product.stockTone);
    final stockLabel = _stockLabel(product.stockTone);

    // Placeholder box: 48x48, radius 12, primaryContainer neutral background
    final placeholder = Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: context.colors.primaryContainer,
        borderRadius: const BorderRadius.all(AppRadius.radiusLg),
      ),
      child: Center(
        child: Icon(
          categoryIcon,
          size: 22,
          color: context.colors.onPrimaryContainer,
        ),
      ),
    );

    // Name & SKU/Brand
    final coreContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          '${product.brand} • ${product.sku}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.appColors.onSurfaceMuted,
          ),
        ),
      ],
    );

    // Quantity, Price & Stock status tag
    final infoContent = Column(
      crossAxisAlignment: isTextLarge
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStockFormatter.units(product.stockQuantity),
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          alignment: isTextLarge ? WrapAlignment.start : WrapAlignment.end,
          children: [
            StatusBadge(label: stockLabel, tone: stockTone),
            if (product.price != null)
              StatusBadge(
                label: AppCurrencyFormatter.format(product.price!),
                tone: AppStatusTone.success,
              )
            else
              const StatusBadge(
                label: 'Preço restrito',
                tone: AppStatusTone.restricted,
              ),
          ],
        ),
      ],
    );

    // Borda/indicador sutil baseada no estoque
    final borderSide = BorderSide(
      color: switch (product.stockTone) {
        ProductCardStockTone.available => context.appColors.borderSubtle,
        ProductCardStockTone.low => context.appColors.warning,
        ProductCardStockTone.out => context.colors.error,
      },
      width: product.stockTone == ProductCardStockTone.available ? 1 : 1.5,
    );

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: const BorderRadius.all(AppRadius.radiusXl),
        border: Border.fromBorderSide(borderSide),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final shouldStackTrailing = isTextLarge || constraints.maxWidth < 320;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (shouldStackTrailing) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    placeholder,
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: coreContent),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                infoContent,
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    placeholder,
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: coreContent),
                    const SizedBox(width: AppSpacing.md),
                    Flexible(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: infoContent,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  String _stockLabel(ProductCardStockTone tone) {
    return switch (tone) {
      ProductCardStockTone.available => 'Estoque saudável',
      ProductCardStockTone.low => 'Baixo estoque',
      ProductCardStockTone.out => 'Sem saldo',
    };
  }

  AppStatusTone _stockBadgeTone(ProductCardStockTone tone) {
    return switch (tone) {
      ProductCardStockTone.available => AppStatusTone.success,
      ProductCardStockTone.low => AppStatusTone.warning,
      ProductCardStockTone.out => AppStatusTone.error,
    };
  }
}
