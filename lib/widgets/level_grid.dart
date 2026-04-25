import 'package:flutter/material.dart';

import '../ds/app_colors.dart';
import '../l10n/strings.dart';
import 'gradient_background.dart';
import 'screen_header.dart';

class LevelGridBody extends StatelessWidget {
  const LevelGridBody({
    required this.onPickPhase,
    required this.onBack,
    super.key,
  });

  final void Function(int phase) onPickPhase;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return GradientBackground(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          ScreenHeader(title: s.levelSelect, onBack: onBack),
          const SizedBox(height: 8),
          Expanded(child: _Grid(onPick: onPickPhase)),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.onPick});

  final void Function(int) onPick;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 24,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) => _PhaseTile(
        phase: index + 1,
        onTap: onPick,
      ),
    );
  }
}

class _PhaseTile extends StatelessWidget {
  const _PhaseTile({required this.phase, required this.onTap});

  final int phase;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xCC1F0E07),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.secondary, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onTap(phase),
        child: Center(
          child: Text(
            '$phase',
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
