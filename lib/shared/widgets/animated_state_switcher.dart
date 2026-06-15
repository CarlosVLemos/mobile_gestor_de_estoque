import 'package:flutter/material.dart';

import '../../app/theme/app_motion.dart';

/// Wrapper que suaviza as transições de estado dentro de uma página.
///
/// Usa [AnimatedSwitcher] com fade + slide vertical sutil para evitar
/// o "piscar" brusco ao trocar entre loading, empty, failure e ready.
///
/// **Importante**: todo widget passado como [child] deve possuir uma
/// [ValueKey] semântica e estável (ex: `ValueKey('dashboard-loading')`,
/// `ValueKey('catalog-ready')`). Sem isso, o [AnimatedSwitcher] pode
/// não animar porque o Flutter entende que é o mesmo widget.
class AnimatedStateSwitcher extends StatelessWidget {
  const AnimatedStateSwitcher({super.key, required this.child});

  /// Widget filho com Key semântica obrigatória para animação correta.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppDurations.normal,
      switchInCurve: AppCurves.standard,
      switchOutCurve: AppCurves.standard,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.02),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
