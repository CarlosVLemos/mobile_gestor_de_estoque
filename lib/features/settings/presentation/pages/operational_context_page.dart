import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/shell/shell_profile.dart';
import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_context.dart';
import '../../../../shared/ui_states/view_status.dart';
import '../../../../shared/widgets/failure_state_card.dart';
import '../../../../shared/widgets/operational_top_bar.dart';
import '../../../../shared/widgets/restricted_info_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/tenant_context_card.dart';
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
              userName: shellProfile.userName,
              userEmail: state.context!.userEmail,
              tenantName: state.context!.tenantName,
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
  });

  final String userName;
  final String userEmail;
  final String tenantName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TenantContextCard(
          tenantName: tenantName,
          userName: userName,
          userEmail: userEmail,
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const SectionHeader(
          title: 'Vínculo da conta',
          subtitle: 'Esta conta está associada à empresa abaixo.',
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
                  'Empresa vinculada',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.appColors.onSurfaceMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  tenantName,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '$userName usa esta conta para acessar a operação dessa empresa.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.appColors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
