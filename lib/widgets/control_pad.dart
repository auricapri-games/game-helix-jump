import 'package:flutter/material.dart';

import '../ds/app_colors.dart';

/// Bottom controls in Gameplay: rotate-left, big DROP, rotate-right.
class ControlPad extends StatelessWidget {
  const ControlPad({
    required this.dropLabel,
    required this.onRotateLeft,
    required this.onRotateRight,
    required this.onDrop,
    super.key,
  });

  final String dropLabel;
  final VoidCallback onRotateLeft;
  final VoidCallback onRotateRight;
  final VoidCallback onDrop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        children: [
          _RoundIcon(
            icon: Icons.rotate_left,
            onTap: onRotateLeft,
            heroKey: const Key('rotate-left'),
          ),
          const SizedBox(width: 12),
          Expanded(child: _DropButton(label: dropLabel, onTap: onDrop)),
          const SizedBox(width: 12),
          _RoundIcon(
            icon: Icons.rotate_right,
            onTap: onRotateRight,
            heroKey: const Key('rotate-right'),
          ),
        ],
      ),
    );
  }
}

class _DropButton extends StatelessWidget {
  const _DropButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(28),
      elevation: 8,
      shadowColor: const Color(0x99000000),
      child: InkWell(
        key: const Key('drop'),
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Container(
          height: 64,
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.background,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    required this.onTap,
    required this.heroKey,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Key heroKey;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x33000000),
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.secondary, width: 1.4),
      ),
      child: InkWell(
        key: heroKey,
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(icon, color: AppColors.secondary, size: 28),
        ),
      ),
    );
  }
}
