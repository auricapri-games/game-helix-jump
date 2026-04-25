import 'package:flutter/material.dart';

import '../widgets/level_grid.dart';
import 'gameplay_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LevelGridBody(
        onBack: () => Navigator.of(context).pop(),
        onPickPhase: (phase) => Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => GameplayScreen(phase: phase),
          ),
        ),
      ),
    );
  }
}
