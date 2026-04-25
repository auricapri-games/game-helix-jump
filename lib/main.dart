import 'package:flutter/material.dart';

import 'ds/app_theme.dart';
import 'l10n/strings.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const GameHelixJumpApp());
}

class GameHelixJumpApp extends StatelessWidget {
  const GameHelixJumpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (ctx) => S.of(ctx).appTitle,
      theme: AppTheme.themeData,
      home: const SplashScreen(),
    );
  }
}
