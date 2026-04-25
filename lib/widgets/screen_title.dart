import 'package:flutter/material.dart';

import '../ds/app_colors.dart';

/// Big bold title used at the top of Splash and on Home.
class ScreenTitle extends StatelessWidget {
  const ScreenTitle({required this.text, super.key, this.size = 40});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.text,
        fontSize: size,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.6,
        shadows: const [
          Shadow(
            color: Color(0x99000000),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}
