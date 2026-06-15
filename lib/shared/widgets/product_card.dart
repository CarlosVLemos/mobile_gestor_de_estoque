import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
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
  const ProductCard({super.key, required this.product});

  final ProductCardData product;

  @override
  Widget build(BuildContext context) {
    final stockTone = _stockBadgeTone(product.stockTone);

    return DecoratedBox(
      decoration: AppDecorations.elevatedCard(context),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ImagePlaceholder(name: product.name, tone: stockTone),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          if (product.price != null)
                            DecoratedBox(
                              decoration: AppDecorations.tonalBadge(
                                context,
                                AppStatusTone.success,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                child: Text(
                                  AppCurrencyFormatter.format(product.price!),
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.appColors.onSuccessContainer,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${product.brand} • ${product.sku}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.appColors.onSurfaceMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                StatusBadge(
                  label: _stockLabel(product.stockTone),
                  tone: stockTone,
                ),
                StatusBadge(
                  label: product.availableForSale
                      ? 'Disponível para venda'
                      : 'Venda depende de revalidação',
                  tone: product.availableForSale
                      ? AppStatusTone.success
                      : AppStatusTone.restricted,
                ),
                if (product.categoryName != null)
                  StatusBadge(
                    label: product.categoryName!,
                    tone: AppStatusTone.restricted,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppStockFormatter.units(product.stockQuantity),
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Atualizado em ${product.updatedAtLabel}',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.appColors.onSurfaceMuted,
              ),
            ),
            if (product.price == null) ...[
              const SizedBox(height: AppSpacing.md),
              const StatusBadge(
                label: 'Preço restrito',
                tone: AppStatusTone.restricted,
              ),
            ],
          ],
        ),
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

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.name, required this.tone});

  final String name;
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.tonalBadge(
        context,
        tone,
      ).copyWith(borderRadius: BorderRadius.circular(22)),
      child: SizedBox(
        width: 72,
        height: 72,
        child: Center(
          child: Text(
            (name.isNotEmpty ? name[0] : '?').toUpperCase(),
            style: context.textTheme.titleLarge?.copyWith(
              color: _foreground(context),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Color _foreground(BuildContext context) {
    return switch (tone) {
      AppStatusTone.success => context.appColors.onSuccessContainer,
      AppStatusTone.warning => context.appColors.onWarningContainer,
      AppStatusTone.error => context.colors.onErrorContainer,
      AppStatusTone.restricted => context.appColors.onRestricted,
    };
  }
}
