import 'package:flutter/material.dart';

import '../../app/theme/app_motion.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';

class AppSegment<T> {
  const AppSegment({
    required this.value,
    required this.label,
    this.icon,
    this.key,
  });

  final T value;
  final String label;
  final IconData? icon;
  final Key? key;
}

/// Controle segmentado responsivo para alternar visões da mesma rota.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelected,
    this.semanticLabel = 'Seletor de visualização',
  }) : assert(segments.length > 1, 'Use ao menos dois segmentos.');

  final List<AppSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onSelected;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHigh,
          borderRadius: AppRadius.xlBorder,
          border: Border.all(color: context.appColors.borderSubtle),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stacked =
                  constraints.maxWidth < 320 ||
                  MediaQuery.textScalerOf(context).scale(1) > 1.3;
              final children = [
                for (final segment in segments)
                  _SegmentButton<T>(
                    segment: segment,
                    selected: segment.value == selected,
                    onPressed: () => onSelected(segment.value),
                  ),
              ];

              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var index = 0; index < children.length; index++) ...[
                      children[index],
                      if (index < children.length - 1)
                        const SizedBox(height: AppSpacing.xs),
                    ],
                  ],
                );
              }

              return Row(
                children: [
                  for (var index = 0; index < children.length; index++) ...[
                    Expanded(child: children[index]),
                    if (index < children.length - 1)
                      const SizedBox(width: AppSpacing.xs),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SegmentButton<T> extends StatelessWidget {
  const _SegmentButton({
    required this.segment,
    required this.selected,
    required this.onPressed,
  });

  final AppSegment<T> segment;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? context.colors.onPrimaryContainer
        : context.appColors.onSurfaceMuted;

    return Semantics(
      key: segment.key,
      container: true,
      button: true,
      selected: selected,
      label: segment.label,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.lgBorder,
            onTap: onPressed,
            child: AnimatedContainer(
              duration: AppDurations.fast,
              curve: AppCurves.standard,
              constraints: const BoxConstraints(
                minHeight: AppSizes.minTouchTarget,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? context.colors.primaryContainer
                    : Colors.transparent,
                borderRadius: AppRadius.lgBorder,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (segment.icon != null) ...[
                    Icon(segment.icon, size: 18, color: foreground),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      segment.label,
                      textAlign: TextAlign.center,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: foreground,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
