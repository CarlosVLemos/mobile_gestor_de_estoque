import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/shell/shell_profile.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_mode_controller.dart';
import '../../../../shared/formatters/app_currency_formatter.dart';
import '../../../../shared/widgets/app_drawer.dart';
import '../../../../shared/widgets/empty_state_card.dart';
import '../../../../shared/widgets/offline_state_banner.dart';
import '../../../../shared/widgets/operational_top_bar.dart';
import '../../../../shared/widgets/restricted_info_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/entities/sale_reference_data.dart';
import '../controllers/pending_sales_controller.dart';
import '../controllers/sales_controller.dart';
import '../state/sales_state.dart';

class SalesPage extends ConsumerWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(salesControllerProvider);
    final controller = ref.read(salesControllerProvider.notifier);
    final themeMode = ref.watch(appThemeModeProvider);
    final pendingSales = ref.watch(pendingSalesProvider);
    final shellProfile = ref.watch(shellProfileProvider);
    final permissions = shellProfile.permissions;
    final features = shellProfile.features;
    final canCreateSales = permissions['sales_create'] ?? false;
    final canViewFinancial = permissions['view_financial_metrics'] ?? false;

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.transparent,
      appBar: OperationalTopBar(
        title: 'Vendas',
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
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          if (!features.contains('sales') || !canCreateSales)
            const RestrictedInfoCard(
              title: 'Vendas indisponíveis',
              message: 'Seu perfil ainda não pode registrar vendas no app.',
            )
          else ...[
            if (pendingSales.isNotEmpty) ...[
              OfflineStateBanner(
                message:
                    '${pendingSales.length} venda${pendingSales.length > 1 ? 's' : ''} armazenada${pendingSales.length > 1 ? 's' : ''} localmente. A fila física entra em uma etapa futura.',
              ),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
            _ClientCard(
              selectedClient: state.selectedClient,
              onSelect: () => _showClientPicker(context, state, controller),
            ),
            const SizedBox(height: AppSpacing.sectionGap),
            SectionHeader(
              title: 'Carrinho',
              action: TextButton.icon(
                onPressed: () => _showProductPicker(context, state, controller),
                icon: const Icon(AppIcons.products, size: 18),
                label: const Text('Adicionar produto'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (state.cartItems.isEmpty)
              const EmptyStateCard(
                title: 'Carrinho vazio',
                message: 'Selecione um cliente e adicione itens.',
              )
            else
              _CartItemsCard(
                items: state.cartItems.values.toList(growable: false),
                canViewFinancial: canViewFinancial,
                onIncrement: controller.incrementQuantity,
                onDecrement: controller.decrementQuantity,
                onRemove: controller.removeItem,
              ),
            const SizedBox(height: AppSpacing.sectionGap),
            _SummaryCard(
              state: state,
              canViewFinancial: canViewFinancial,
              pendingCount: pendingSales.length,
              onRegister: state.canRegister
                  ? () {
                      final pendingSale = controller.registerSale();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Venda ${pendingSale.clientRequestId.substring(0, 8)} armazenada offline.',
                          ),
                        ),
                      );
                    }
                  : null,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showClientPicker(
    BuildContext context,
    SalesState state,
    SalesController controller,
  ) async {
    final selected = await showModalBottomSheet<SaleClientOption>(
      context: context,
      builder: (context) {
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: state.clients.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final client = state.clients[index];
            return DecoratedBox(
              decoration: AppDecorations.card(context),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  title: Text(client.name),
                  subtitle: Text('${client.code} • ${client.city}'),
                  onTap: () => Navigator.of(context).pop(client),
                ),
              ),
            );
          },
        );
      },
    );

    if (selected != null) {
      controller.selectClient(selected);
    }
  }

  Future<void> _showProductPicker(
    BuildContext context,
    SalesState state,
    SalesController controller,
  ) async {
    final selected = await showModalBottomSheet<SaleProductOption>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: state.products.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final product = state.products[index];
            return DecoratedBox(
              decoration: AppDecorations.card(context),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.sku),
                  trailing: product.price == null
                      ? const Text('Preço restrito')
                      : Text(AppCurrencyFormatter.format(product.price!)),
                  onTap: () => Navigator.of(context).pop(product),
                ),
              ),
            );
          },
        );
      },
    );

    if (selected != null) {
      controller.addProduct(selected);
    }
  }

  void _showSearchMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Busca global ainda não entrou no app.')),
    );
  }
}

class _ClientCard extends StatelessWidget {
  const _ClientCard({required this.selectedClient, required this.onSelect});

  final SaleClientOption? selectedClient;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.card(context),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Cliente'),
            const SizedBox(height: AppSpacing.md),
            if (selectedClient == null)
              Text(
                'Nenhum cliente selecionado.',
                style: Theme.of(context).textTheme.bodyMedium,
              )
            else ...[
              Text(
                selectedClient!.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text('${selectedClient!.code} • ${selectedClient!.city}'),
            ],
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonal(
                onPressed: onSelect,
                child: Text(
                  selectedClient == null
                      ? 'Selecionar cliente'
                      : 'Trocar cliente',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemsCard extends StatelessWidget {
  const _CartItemsCard({
    required this.items,
    required this.canViewFinancial,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final List<SaleCartItem> items;
  final bool canViewFinancial;
  final ValueChanged<String> onIncrement;
  final ValueChanged<String> onDecrement;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.card(context),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[index].name,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(items[index].sku),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(AppIcons.removeItem),
                        onPressed: () => onRemove(items[index].productId),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(AppIcons.decreaseQuantity),
                            onPressed: () =>
                                onDecrement(items[index].productId),
                          ),
                          Text('${items[index].quantity}'),
                          IconButton(
                            icon: const Icon(AppIcons.increaseQuantity),
                            onPressed: () =>
                                onIncrement(items[index].productId),
                          ),
                        ],
                      ),
                      _ValueChip(
                        label: canViewFinancial
                            ? _unitPriceLabel(items[index].unitPrice)
                            : 'Financeiro restrito',
                      ),
                      _ValueChip(
                        label: canViewFinancial
                            ? _subtotalLabel(items[index].subtotal)
                            : 'Subtotal restrito',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _unitPriceLabel(double? unitPrice) {
    if (unitPrice == null) {
      return 'Preço pendente';
    }
    return 'Unitário ${AppCurrencyFormatter.format(unitPrice)}';
  }

  String _subtotalLabel(double? subtotal) {
    if (subtotal == null) {
      return 'Subtotal pendente';
    }
    return 'Subtotal ${AppCurrencyFormatter.format(subtotal)}';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.state,
    required this.canViewFinancial,
    required this.pendingCount,
    required this.onRegister,
  });

  final SalesState state;
  final bool canViewFinancial;
  final int pendingCount;
  final VoidCallback? onRegister;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.card(context),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Registro offline'),
            const SizedBox(height: AppSpacing.md),
            Text(
              _totalLabel(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              pendingCount == 0
                  ? 'Pronto para criar a primeira intenção local.'
                  : 'Fila em memória com $pendingCount registro${pendingCount > 1 ? 's' : ''}.',
            ),
            const SizedBox(height: AppSpacing.md),
            const StatusBadge(label: 'Offline', tone: AppStatusTone.warning),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onRegister,
                child: const Text('Registrar venda'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _totalLabel() {
    if (!canViewFinancial) {
      return 'Financeiro restrito';
    }

    if (state.cartItems.isEmpty) {
      return 'Total R\$ 0,00';
    }

    if (state.hasPendingPrice) {
      return 'Total com preço pendente';
    }

    final total = state.cartItems.values.fold<double>(
      0,
      (sum, item) => sum + (item.subtotal ?? 0),
    );
    return 'Total ${AppCurrencyFormatter.format(total)}';
  }
}

class _ValueChip extends StatelessWidget {
  const _ValueChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.tonalBadge(context, AppStatusTone.restricted),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Text(label),
      ),
    );
  }
}
