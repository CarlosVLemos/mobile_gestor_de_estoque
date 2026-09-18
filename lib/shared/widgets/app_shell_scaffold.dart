import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
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
    return Scaffold(
      body: DecoratedBox(
        decoration: AppDecorations.atmosphericBackground(context),
        child: SafeArea(
          // The bottom navigation handles the device's lower safe area.
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
                  child: body,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: currentIndex,
        destinations: destinations,
        onSelect: onSelect,
      ),
    );
  }
}
