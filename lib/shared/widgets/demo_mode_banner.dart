import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_decorations.dart';
import '../../core/config/app_mode.dart';
import 'status_badge.dart';

class DemoModeBanner extends ConsumerWidget {
  const DemoModeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(appModeProvider).isDemo) {
      return const SizedBox.shrink();
    }
    return const SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.centerLeft,
        child: StatusBadge(
          label: 'Modo demonstração — dados fictícios',
          tone: AppStatusTone.warning,
        ),
      ),
    );
  }
}
