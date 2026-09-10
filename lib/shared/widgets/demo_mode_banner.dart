import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/config/app_mode.dart';
import 'status_badge.dart';

class DemoModeBanner extends ConsumerWidget {
  const DemoModeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDemo = ref.watch(appModeProvider).isDemo;
    if (!isDemo) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: AppDecorations.card(context),
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: const Center(
        child: StatusBadge(
          label: 'Modo demonstração',
          tone: AppStatusTone.restricted,
        ),
      ),
    );
  }
}
