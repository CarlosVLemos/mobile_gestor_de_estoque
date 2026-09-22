import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/shell/shell_profile.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_context.dart';
import '../../../../shared/ui_states/view_status.dart';
import '../../../../shared/widgets/failure_state_card.dart';
import '../../../../shared/widgets/operational_top_bar.dart';
import '../../../../shared/widgets/permission_list_tile.dart';
import '../../../../shared/widgets/restricted_info_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../domain/entities/operational_context.dart';
import '../controllers/operational_context_controller.dart';

class OperationalContextPage extends ConsumerWidget {
  const OperationalContextPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(operationalContextControllerProvider);
    final shellProfile = ref.watch(shellProfileProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: OperationalTopBar(
        title: 'Conta',
        leading: IconButton(
          tooltip: 'Voltar',
          icon: const Icon(AppIcons.arrowBack),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.more);
            }
          },
        ),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          switch (state.status) {
            ViewStatus.loading => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: CircularProgressIndicator(),
              ),
            ),
            ViewStatus.restricted => RestrictedInfoCard(
              title: 'Acesso restrito ao contexto',
              message: state.message ?? 'O backend bloqueou este contexto.',
            ),
            ViewStatus.failure => FailureStateCard(
              title: 'Não foi possível carregar o contexto',
              message: state.message ?? 'Tente novamente em instantes.',
              action: TextButton(
                onPressed: () => ref
                    .read(operationalContextControllerProvider.notifier)
                    .load(),
                child: const Text('Tentar novamente'),
              ),
            ),
            _ when state.context != null => _OperationalContextContent(
              userName: shellProfile.userName,
              operationalContext: state.context!,
            ),
            _ => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }
}

class _OperationalContextContent extends StatelessWidget {
  const _OperationalContextContent({
    required this.userName,
    required this.operationalContext,
  });

  final String userName;
  final OperationalContext operationalContext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Conta e empresa',
          subtitle: 'Informações da operação que está em uso.',
        ),
        const SizedBox(height: AppSpacing.md),
        _AccountIdentityCard(
          userName: userName,
          userEmail: operationalContext.userEmail,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const SectionHeader(
          title: 'Empresa atual',
          subtitle: 'A empresa associada à sua conta nesta operação.',
        ),
        const SizedBox(height: AppSpacing.md),
        DecoratedBox(
          decoration: AppDecorations.card(context),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EMPRESA EM USO',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.appColors.onSurfaceMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  operationalContext.tenantName,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Sua conta está usando esta empresa nesta operação.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.appColors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const SectionHeader(
          title: 'Acesso disponível',
          subtitle: 'Recursos liberados para esta conta.',
        ),
        const SizedBox(height: AppSpacing.md),
        PermissionListTile(
          label: 'Consultar catálogo',
          description: 'Visualizar produtos e disponibilidade operacional.',
          allowed: operationalContext.permissionGranted('products_view'),
        ),
        const SizedBox(height: AppSpacing.sm),
        PermissionListTile(
          label: 'Registrar vendas',
          description: 'Criar rascunhos e futuras intenções de venda.',
          allowed: operationalContext.permissionGranted('sales_create'),
        ),
        const SizedBox(height: AppSpacing.sm),
        PermissionListTile(
          label: 'Ver métricas financeiras',
          description: 'Exibir preços, totais e indicadores financeiros.',
          allowed: operationalContext.permissionGranted(
            'view_financial_metrics',
          ),
        ),
      ],
    );
  }
}

class _AccountIdentityCard extends StatelessWidget {
  const _AccountIdentityCard({required this.userName, required this.userEmail});

  final String userName;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.card(context),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Icon(
                  AppIcons.account,
                  color: context.colors.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sua conta',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.appColors.onSurfaceMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(userName, style: context.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    userEmail,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.appColors.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
