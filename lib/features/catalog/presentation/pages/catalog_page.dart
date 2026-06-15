import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/ui_states/view_status.dart';
import '../../../../shared/widgets/animated_state_switcher.dart';
import '../../../../shared/widgets/empty_state_card.dart';
import '../../../../shared/widgets/failure_state_card.dart';
import '../../../../shared/widgets/interactive_feedback.dart';
import '../../../../shared/widgets/offline_state_banner.dart';
import '../../../../shared/widgets/operational_page_header.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/restricted_info_card.dart';
import '../../domain/entities/catalog_product.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../controllers/catalog_controller.dart';
import '../state/catalog_state.dart';
import '../widgets/catalog_filter_bar.dart';

class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogControllerProvider);
    final controller = ref.read(catalogControllerProvider.notifier);

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          OperationalPageHeader(
            eyebrow: 'CATÁLOGO OPERACIONAL',
            title: 'Produtos para consulta rápida',
            description:
                'Busca operacional, estoque visível e preço opcional respeitando o contexto do usuário.',
            icon: AppIcons.products,
            tags: [
              OperationalHeaderTag(
                label: state.query.category ?? 'Todas as categorias',
                tone: AppStatusTone.restricted,
              ),
              OperationalHeaderTag(
                label: state.items.any((item) => item.price == null)
                    ? 'Preço parcialmente protegido'
                    : 'Preço liberado',
                tone: state.items.any((item) => item.price == null)
                    ? AppStatusTone.warning
                    : AppStatusTone.success,
              ),
            ],
            metrics: [
              OperationalHeaderMetric(
                label: 'Produtos visíveis',
                value: state.items.isEmpty ? '0' : '${state.items.length}',
                icon: AppIcons.storefront,
              ),
              OperationalHeaderMetric(
                label: 'Filtros ativos',
                value:
                    state.query.category == null &&
                        state.query.search.trim().isEmpty
                    ? 'Base padrão'
                    : 'Refinados',
                icon: AppIcons.tune,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          CatalogFilterBar(
            searchValue: state.query.search,
            categories: state.categories,
            selectedCategory: state.query.category ?? 'Todos',
            onSearchChanged: (value) {
              controller.updateSearch(value);
            },
            onCategorySelected: (value) {
              controller.updateCategory(value);
            },
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          if (state.status == ViewStatus.offline && state.message != null) ...[
            OfflineStateBanner(message: state.message!),
            const SizedBox(height: AppSpacing.sectionGap),
          ],
          AnimatedStateSwitcher(
            child: _buildContent(context, state, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    CatalogState state,
    CatalogController controller,
  ) {
    if (state.status == ViewStatus.loading && state.items.isEmpty) {
      return const Center(
        key: ValueKey('catalog-loading'),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.status == ViewStatus.restricted) {
      final title =
          state.restrictionKind == CatalogRestrictionKind.featureDisabled
          ? 'Catálogo indisponível para este tenant'
          : 'Seu perfil não pode consultar produtos';

      return RestrictedInfoCard(
        key: const ValueKey('catalog-restricted'),
        title: title,
        message:
            state.message ?? 'O backend indicou restrição para este módulo.',
      );
    }

    if (state.status == ViewStatus.failure && state.items.isEmpty) {
      return FailureStateCard(
        key: const ValueKey('catalog-failure'),
        title: 'Falha ao consultar o catálogo',
        message:
            state.message ??
            'Tente novamente em instantes para recarregar os produtos.',
        action: TextButton(
          onPressed: () => controller.load(),
          child: const Text('Tentar novamente'),
        ),
      );
    }

    if (state.status == ViewStatus.empty) {
      return EmptyStateCard(
        key: const ValueKey('catalog-empty'),
        title: 'Nenhum produto encontrado',
        message:
            state.message ??
            'Ajuste a busca ou aguarde a próxima atualização do catálogo.',
      );
    }

    return Column(
      key: const ValueKey('catalog-ready'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.status == ViewStatus.refreshing)
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.lg),
            child: LinearProgressIndicator(),
          ),
        if (state.status == ViewStatus.failure && state.message != null) ...[
          FailureStateCard(
            title: 'Última atualização não concluiu',
            message: state.message!,
            action: TextButton(
              onPressed: () => controller.refresh(),
              child: const Text('Atualizar agora'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        for (final product in state.items) ...[
          InteractiveFeedback(
            child: ProductCard(
              product: ProductCardData(
                name: product.name,
                sku: product.sku,
                brand: product.brand,
                stockQuantity: product.stockQuantity,
                stockTone: switch (product.stockStatus) {
                  CatalogStockStatus.available =>
                    ProductCardStockTone.available,
                  CatalogStockStatus.low => ProductCardStockTone.low,
                  CatalogStockStatus.out => ProductCardStockTone.out,
                },
                availableForSale: product.isAvailableForSale,
                updatedAtLabel: product.updatedAtLabel,
                price: product.price,
                categoryName: product.categoryName,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}
