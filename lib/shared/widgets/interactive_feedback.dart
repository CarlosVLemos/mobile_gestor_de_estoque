import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_motion.dart';

/// Widget reutilizável que adiciona feedback visual reativo de micro-escala
/// ao ser pressionado.
///
/// Envolve qualquer widget interativo (cards, botões) para dar impressão
/// tátil de que o componente "afundou" levemente na tela ao toque.
///
/// O haptic feedback é controlado por [enableHaptics] e só dispara quando
/// [onTap] está definido e [enabled] é `true`.
class InteractiveFeedback extends StatefulWidget {
  const InteractiveFeedback({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.enableHaptics = false,
    this.scaleFactor = 0.97,
  });

  /// Widget filho envolvido pela animação.
  final Widget child;

  /// Callback de toque. Se nulo, o widget não reage.
  final VoidCallback? onTap;

  /// Quando `false`, desabilita toda interação e animação.
  final bool enabled;

  /// Quando `true`, dispara [HapticFeedback.lightImpact] no toque.
  ///
  /// Deve ser usado com parcimônia — em listas longas, desativar para
  /// evitar haptic em scroll acidental.
  final bool enableHaptics;

  /// Fator de escala mínimo durante o press (padrão: 0.97).
  final double scaleFactor;

  @override
  State<InteractiveFeedback> createState() => _InteractiveFeedbackState();
}

class _InteractiveFeedbackState extends State<InteractiveFeedback>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  bool get _isInteractive => widget.enabled && widget.onTap != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppDurations.fast);
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleFactor)
        .animate(
          CurvedAnimation(parent: _controller, curve: AppCurves.emphasized),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!_isInteractive) return;
    _controller.forward();
    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!_isInteractive) return;
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    if (!_isInteractive) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInteractive) return widget.child;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
