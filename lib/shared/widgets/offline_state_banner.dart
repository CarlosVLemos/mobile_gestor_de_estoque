import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';
import 'status_badge.dart';

class OfflineStateBanner extends StatelessWidget {
  const OfflineStateBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final isTextLarge = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final badge = const StatusBadge(
      label: 'Offline',
      tone: AppStatusTone.warning,
    );
    final text = Text(
      message,
      style: context.textTheme.bodySmall?.copyWith(
        color: context.appColors.onSurfaceMuted,
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.appColors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: isTextLarge
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  badge,
                  const SizedBox(height: AppSpacing.md),
                  text,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  badge,
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: text),
                ],
              ),
      ),
    );
  }
}
