import 'package:flutter/animation.dart';

/// Tokens de movimento centralizados para linguagem de animação consistente.
///
/// Evita valores mágicos espalhados em widgets individuais.
abstract final class AppDurations {
  const AppDurations._();

  /// Feedback de toque, micro-interações rápidas.
  static const Duration fast = Duration(milliseconds: 120);

  /// Transições de estado, switchers de conteúdo.
  static const Duration normal = Duration(milliseconds: 250);

  /// Transições de página ou animações mais elaboradas.
  static const Duration slow = Duration(milliseconds: 400);
}

/// Curvas padrão para todas as animações do app.
///
/// Press down e release usam [standard]; transições de conteúdo usam
/// [emphasized].
abstract final class AppCurves {
  const AppCurves._();

  /// Curva padrão para a maioria das animações (entrada e saída).
  static const Curve standard = Curves.easeInOutCubic;

  /// Curva de saída enfatizada para release de toque e transições suaves.
  static const Curve emphasized = Curves.easeOutCubic;
}
