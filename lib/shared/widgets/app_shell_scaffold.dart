import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_sizes.dart';
import '../../app/theme/app_spacing.dart';
import 'app_bottom_navigation.dart';

class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.destinations,
    required this.onSelect,
    this.banner,
  });

  final Widget body;
  final int currentIndex;
  final List<AppBottomNavigationDestination> destinations;
  final ValueChanged<int> onSelect;
  final Widget? banner;

  @override
  Widget build(BuildContext context) {
    final isTextLarge = MediaQuery.textScalerOf(context).scale(1) > 1.3;
    final navigationHeight = isTextLarge
        ? AppSizes.bottomNavigationExpandedHeight
        : AppSizes.bottomNavigationHeight;
    final bottomPadding =
        navigationHeight + MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      extendBody: true,
      body: DecoratedBox(
        decoration: AppDecorations.atmosphericBackground(context),
        child: SafeArea(
          // Preserves top safe area. Bottom is handled manually below with extendBody
          bottom: false,
          child: Column(
            children: [
              if (banner != null) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    0,
                  ),
                  child: banner!,
                ),
              ],
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: body,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: DecoratedBox(
            decoration: AppDecorations.glassSurfaceBar(context),
            child: AppBottomNavigation(
              currentIndex: currentIndex,
              destinations: destinations,
              onSelect: onSelect,
            ),
          ),
        ),
      ),
    );
  }
}
