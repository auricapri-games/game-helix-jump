import 'package:flutter/material.dart';

import '../ds/app_colors.dart';

/// Subtitle / description line shown under the title on Home and Splash.
class Tagline extends StatelessWidget {
  const Tagline({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.accent,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.35,
      ),
    );
  }
}
