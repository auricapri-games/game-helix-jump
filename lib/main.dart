import 'package:flutter/material.dart';

import 'ds/app_colors.dart';

void main() {
  runApp(const GameHelixJumpApp());
}

class GameHelixJumpApp extends StatelessWidget {
  const GameHelixJumpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helix Jump',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Helix Jump — building...',
            style: TextStyle(color: AppColors.text, fontSize: 22),
          ),
        ),
      ),
    );
  }
}
