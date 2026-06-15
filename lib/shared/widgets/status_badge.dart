import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.tone});

  final String label;
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.tonalBadge(context, tone),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: _foreground(context),
          ),
        ),
      ),
    );
  }

  Color _foreground(BuildContext context) {
    final colors = context.colors;
    final tokens = context.appColors;
    return switch (tone) {
      AppStatusTone.success => tokens.onSuccessContainer,
      AppStatusTone.warning => tokens.onWarningContainer,
      AppStatusTone.error => colors.onErrorContainer,
      AppStatusTone.restricted => tokens.onRestricted,
    };
  }
}
