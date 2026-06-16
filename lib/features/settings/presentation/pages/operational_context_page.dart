import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/ui_states/view_status.dart';
import '../../../../shared/widgets/failure_state_card.dart';
import '../../../../shared/widgets/feature_pill.dart';
import '../../../../shared/widgets/operational_top_bar.dart';
import '../../../../shared/widgets/permission_list_tile.dart';
import '../../../../shared/widgets/restricted_info_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/tenant_context_card.dart';
import '../controllers/operational_context_controller.dart';

class OperationalContextPage extends ConsumerWidget {
  const OperationalContextPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(operationalContextControllerProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: OperationalTopBar(
        title: 'Contexto e Acesso',
        subtitle: 'Leitura operacional do seu perfil',
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBack),
          onPressed: () => context.pop(),
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
              userName: state.context!.userName,
              userEmail: state.context!.userEmail,
              tenantName: state.context!.tenantName,
              tenantSlug: state.context!.tenantSlug,
              features: state.context!.features,
              permissions: state.context!.permissions,
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
    required this.userEmail,
    required this.tenantName,
    required this.tenantSlug,
    required this.features,
    required this.permissions,
  });

  final String userName;
  final String userEmail;
  final String tenantName;
  final String tenantSlug;
  final Set<String> features;
  final Map<String, bool> permissions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TenantContextCard(
          tenantName: tenantName,
          tenantSlug: tenantSlug,
          userName: userName,
          userEmail: userEmail,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const SectionHeader(
          title: 'Features ativas',
          subtitle: 'A shell e os módulos secundários usam este contexto.',
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final feature in ['catalog', 'sales', 'reports'])
              FeaturePill(label: feature, enabled: features.contains(feature)),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const SectionHeader(
          title: 'Permissões relevantes',
          subtitle:
              'Permissão visual orienta a UX, mas a autorização final continua no backend.',
        ),
        const SizedBox(height: AppSpacing.md),
        PermissionListTile(
          label: 'Consultar catálogo',
          description: 'Habilita leitura do módulo de produtos.',
          allowed: permissions['products_view'] ?? false,
        ),
        const SizedBox(height: AppSpacing.md),
        PermissionListTile(
          label: 'Criar vendas',
          description: 'Prepara o futuro fluxo operacional de vendas.',
          allowed: permissions['sales_create'] ?? false,
        ),
        const SizedBox(height: AppSpacing.md),
        PermissionListTile(
          label: 'Ver métricas financeiras',
          description:
              'Controla a exibição de preço e indicadores financeiros no app.',
          allowed: permissions['view_financial_metrics'] ?? false,
        ),
        const SizedBox(height: AppSpacing.md),
        PermissionListTile(
          label: 'Ver relatórios',
          description:
              'Mantido para contexto operacional, ainda sem módulo mobile funcional.',
          allowed: permissions['reports_view'] ?? false,
        ),
      ],
    );
  }
}
