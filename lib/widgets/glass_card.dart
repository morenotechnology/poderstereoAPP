import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.gradient,
    this.borderRadius = const BorderRadius.all(Radius.circular(28)),
  });

  final Widget child;
  final EdgeInsets padding;
  final Gradient? gradient;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final overlayColor = Colors.white.withValues(alpha: 0.04);
    return GlassContainer(
      blur: 22,
      shadowStrength: 6,
      borderRadius: borderRadius,
      gradient: gradient,
      border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: overlayColor,
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}
