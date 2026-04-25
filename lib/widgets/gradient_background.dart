import 'package:flutter/material.dart';

import '../ds/app_theme.dart';

/// Sunset-gradient backdrop. Use as the root child of a Scaffold body so
/// every screen feels part of the same world.
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.child,
    super.key,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: SafeArea(
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
