import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_mode_controller.dart';
import '../../../../shared/ui_states/view_status.dart';
import '../../../../shared/widgets/animated_state_switcher.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../shared/widgets/empty_state_card.dart';
import '../../../../shared/widgets/failure_state_card.dart';
import '../../../../shared/widgets/interactive_feedback.dart';
import '../../../../shared/widgets/offline_state_banner.dart';
import '../../../../shared/widgets/operational_top_bar.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/restricted_info_card.dart';
import '../../domain/entities/catalog_product.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../controllers/catalog_controller.dart';
import '../state/catalog_state.dart';
import '../widgets/catalog_filter_bar.dart';

class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  IconData _getCategoryIcon(String? categoryName) {
    if (categoryName == null) return AppIcons.productFallback;
    final normalized = categoryName.toLowerCase().trim();
    if (normalized == 'proteção' || normalized == 'protecao') {
      return AppIcons.productProtection;
    }
    if (normalized == 'elétrica' || normalized == 'eletrica') {
      return AppIcons.productElectrical;
    }
    if (normalized == 'acessórios' || normalized == 'acessorios') {
      return AppIcons.productAccessories;
    }
    return AppIcons.productFallback;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogControllerProvider);
    final controller = ref.read(catalogControllerProvider.notifier);
    final themeMode = ref.watch(appThemeModeProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.transparent,
      appBar: OperationalTopBar(
        title: 'Produtos',
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(AppIcons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        showSearchAction: true,
        onSearchPressed: () => _showSearchMessage(context),
        themeMode: themeMode,
        onThemeToggle: () {
          ref
              .read(appThemeModeProvider.notifier)
              .toggle(MediaQuery.platformBrightnessOf(context));
        },
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            CatalogFilterBar(
              searchValue: state.query.search,
              categories: state.categories,
              selectedCategory: state.query.category ?? 'Todos',
              onSearchChanged: controller.updateSearch,
              onCategorySelected: controller.updateCategory,
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            if (state.status == ViewStatus.offline &&
                state.message != null) ...[
              OfflineStateBanner(message: state.message!),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
            AnimatedStateSwitcher(
              child: _buildContent(context, state, controller),
            ),
          ],
        ),
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
          onPressed: controller.load,
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
              onPressed: controller.refresh,
              child: const Text('Atualizar agora'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        for (final product in state.items) ...[
          InteractiveFeedback(
            child: ProductCard(
              categoryIcon: _getCategoryIcon(product.categoryName),
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

  void _showSearchMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Busca global ainda não entrou no app.')),
    );
  }
}
