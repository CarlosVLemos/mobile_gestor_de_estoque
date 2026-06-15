import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/app_decorations.dart';
import '../../app/theme/app_spacing.dart';
import 'app_bottom_navigation.dart';

/// Altura estimada da bottom navigation bar para compensação de padding.
const double _kBottomNavHeight = 76;

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
    // Padding inferior para compensar o extendBody — garante que o último
    // item do conteúdo não fique permanentemente oculto sob a bottom nav.
    final bottomPadding =
        _kBottomNavHeight + MediaQuery.of(context).padding.bottom;

    return Scaffold(
      extendBody: true,
      body: DecoratedBox(
        decoration: AppDecorations.atmosphericBackground(context),
        child: SafeArea(
          // Preserva proteção superior (status bar, notch, câmera).
          // O padding inferior é gerenciado manualmente para funcionar
          // junto com extendBody: true.
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
            child: SafeArea(
              top: false,
              child: AppBottomNavigation(
                currentIndex: currentIndex,
                destinations: destinations,
                onSelect: onSelect,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
