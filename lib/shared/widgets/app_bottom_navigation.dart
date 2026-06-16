import 'package:flutter/material.dart';

import '../../app/theme/app_radius.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_theme_context.dart';

class AppBottomNavigationDestination {
  const AppBottomNavigationDestination({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;
}

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.destinations,
    required this.onSelect,
  });

  final int currentIndex;
  final List<AppBottomNavigationDestination> destinations;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final colors = context.colors;
    final tokens = context.appColors;
    final textScaler = MediaQuery.textScalerOf(context);
    final isTextLarge = textScaler.scale(1) > 1.3;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: isTextLarge
            ? AppSizes.bottomNavigationExpandedHeight
            : AppSizes.bottomNavigationHeight,
        child: Padding(
          padding: isTextLarge
              ? const EdgeInsets.symmetric(vertical: 8.0)
              : EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < destinations.length; i++) ...[
                (() {
                  final destination = destinations[i];
                  final isSelected = i == currentIndex;
                  final contentColor = isSelected
                      ? colors.primary
                      : tokens.onSurfaceMuted;

                  return Expanded(
                    child: Semantics(
                      selected: isSelected,
                      container: true,
                      button: true,
                      label: destination.label,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onSelect(i),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: AppSizes.minTouchTarget,
                              minHeight: AppSizes.minTouchTarget,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colors.primary.withValues(alpha: 0.1)
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                      AppRadius.radiusSm,
                                    ),
                                  ),
                                  child: Icon(
                                    destination.icon,
                                    size: AppSizes.navigationIcon,
                                    color: contentColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  destination.label,
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: contentColor,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                })(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
