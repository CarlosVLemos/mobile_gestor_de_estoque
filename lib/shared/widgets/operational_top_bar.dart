import 'package:flutter/material.dart';

import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme_context.dart';

class OperationalTopBar extends StatelessWidget implements PreferredSizeWidget {
  const OperationalTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.appColors;

    final titleWidget = Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              subtitle!,
              style: context.textTheme.bodySmall?.copyWith(
                color: tokens.onSurfaceMuted,
              ),
            ),
          ],
        ],
      ),
    );

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: AppSpacing.md),
        ],
        Expanded(child: titleWidget),
        if (actions.isNotEmpty) ...[
          const SizedBox(width: AppSpacing.sm),
          Row(mainAxisSize: MainAxisSize.min, children: actions),
        ],
      ],
    );

    return Container(
      color: colors.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: content,
            ),
            Divider(height: 1, thickness: 1, color: tokens.borderSubtle),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    subtitle == null
        ? AppSizes.appBarHeight + 16
        : AppSizes.appBarHeight + 40,
  );
}
