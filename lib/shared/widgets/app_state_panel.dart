import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_icons.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';
import 'status_badge.dart';

enum AppStatePanelTone { empty, failure, restricted, offline, info }

enum AppStatePanelLayout { card, banner }

/// Superfície semântica compartilhada para estados operacionais.
///
/// Mantém empty, failure, restricted, offline e info visualmente relacionados
/// sem apagar a distinção de significado entre eles.
class AppStatePanel extends StatelessWidget {
  const AppStatePanel({
    super.key,
    required this.tone,
    required this.message,
    this.title,
    this.action,
    this.layout = AppStatePanelLayout.card,
    this.icon,
  });

  final AppStatePanelTone tone;
  final String? title;
  final String message;
  final Widget? action;
  final AppStatePanelLayout layout;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final visuals = _visuals(context);
    final isCompact = layout == AppStatePanelLayout.banner;
    final padding = isCompact
        ? const EdgeInsets.all(AppSpacing.md)
        : const EdgeInsets.all(AppSpacing.xl);

    return Semantics(
      container: true,
      liveRegion:
          tone == AppStatePanelTone.failure ||
          tone == AppStatePanelTone.offline,
      child: DecoratedBox(
        decoration: isCompact
            ? BoxDecoration(
                color: context.colors.surfaceContainerHigh,
                borderRadius: AppRadius.xlBorder,
                border: Border.all(color: context.appColors.borderSubtle),
              )
            : AppDecorations.card(context),
        child: Padding(
          padding: padding,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stackBanner =
                  isCompact &&
                  (constraints.maxWidth < 320 ||
                      MediaQuery.textScalerOf(context).scale(1) > 1.3);
              final heading = _StateHeading(
                icon: icon ?? visuals.icon,
                iconColor: visuals.iconColor,
                badgeLabel: visuals.badgeLabel,
                badgeTone: visuals.badgeTone,
              );
              final content = _StateContent(
                title: title,
                message: message,
                action: action,
                compact: isCompact,
              );

              if (!isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading,
                    const SizedBox(height: AppSpacing.md),
                    content,
                  ],
                );
              }

              if (stackBanner) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading,
                    const SizedBox(height: AppSpacing.md),
                    content,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heading,
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: content),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _StateVisuals _visuals(BuildContext context) {
    return switch (tone) {
      AppStatePanelTone.empty => _StateVisuals(
        icon: AppIcons.search,
        iconColor: context.appColors.onSurfaceMuted,
        badgeLabel: 'Sem dados',
        badgeTone: AppStatusTone.info,
      ),
      AppStatePanelTone.failure => _StateVisuals(
        icon: AppIcons.error,
        iconColor: context.colors.error,
        badgeLabel: 'Falha',
        badgeTone: AppStatusTone.error,
      ),
      AppStatePanelTone.restricted => _StateVisuals(
        icon: AppIcons.lock,
        iconColor: context.appColors.onRestricted,
        badgeLabel: 'Restrito',
        badgeTone: AppStatusTone.restricted,
      ),
      AppStatePanelTone.offline => _StateVisuals(
        icon: AppIcons.wifiOff,
        iconColor: context.appColors.onWarningContainer,
        badgeLabel: 'Offline',
        badgeTone: AppStatusTone.warning,
      ),
      AppStatePanelTone.info => _StateVisuals(
        icon: AppIcons.info,
        iconColor: context.colors.primary,
        badgeLabel: 'Informação',
        badgeTone: AppStatusTone.info,
      ),
    };
  }
}

class _StateHeading extends StatelessWidget {
  const _StateHeading({
    required this.icon,
    required this.iconColor,
    required this.badgeLabel,
    required this.badgeTone,
  });

  final IconData icon;
  final Color iconColor;
  final String badgeLabel;
  final AppStatusTone badgeTone;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.10),
            borderRadius: AppRadius.lgBorder,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Icon(icon, size: 20, color: iconColor),
          ),
        ),
        StatusBadge(label: badgeLabel, tone: badgeTone),
      ],
    );
  }
}

class _StateContent extends StatelessWidget {
  const _StateContent({
    required this.title,
    required this.message,
    required this.action,
    required this.compact,
  });

  final String? title;
  final String message;
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: context.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
        ],
        Text(
          message,
          style: (compact
                  ? context.textTheme.bodySmall
                  : context.textTheme.bodyMedium)
              ?.copyWith(color: context.appColors.onSurfaceMuted),
        ),
        if (action != null) ...[
          const SizedBox(height: AppSpacing.lg),
          action!,
        ],
      ],
    );
  }
}

class _StateVisuals {
  const _StateVisuals({
    required this.icon,
    required this.iconColor,
    required this.badgeLabel,
    required this.badgeTone,
  });

  final IconData icon;
  final Color iconColor;
  final String badgeLabel;
  final AppStatusTone badgeTone;
}
