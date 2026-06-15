import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_spacing.dart';

class MovementListItemData {
  const MovementListItemData({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String subtitle;
  final String trailing;
}

class MovementListItem extends StatelessWidget {
  const MovementListItem({super.key, required this.data});

  final MovementListItemData data;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.card(context),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        title: Text(data.title),
        subtitle: Text(data.subtitle),
        trailing: Text(data.trailing),
      ),
    );
  }
}
