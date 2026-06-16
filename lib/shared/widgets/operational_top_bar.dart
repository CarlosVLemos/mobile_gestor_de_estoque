import 'package:flutter/material.dart';

import '../../app/theme/app_icons.dart';
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
    final textScaler = MediaQuery.textScalerOf(context);
    final isTextLarge = textScaler.scale(1) > 1.3;
    final colors = context.colors;
    final tokens = context.appColors;

    final titleWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 2,
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
    );

    final leadingWidget =
        leading ??
        IconButton(icon: const Icon(AppIcons.menu), onPressed: () {});

    final actionsList = actions.isNotEmpty
        ? actions
        : [IconButton(icon: const Icon(AppIcons.search), onPressed: () {})];

    Widget content;
    if (isTextLarge) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leadingWidget,
              const SizedBox(width: AppSpacing.md),
              Expanded(child: titleWidget),
            ],
          ),
          if (actionsList.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: actionsList,
            ),
          ],
        ],
      );
    } else {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leadingWidget,
          const SizedBox(width: AppSpacing.md),
          Expanded(child: titleWidget),
          if (actionsList.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.md),
            Row(mainAxisSize: MainAxisSize.min, children: actionsList),
          ],
        ],
      );
    }

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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 24);
}
