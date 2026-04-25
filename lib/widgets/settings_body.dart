import 'package:auricapri_games_common/auricapri_games_common.dart';
import 'package:flutter/material.dart';

import '../ds/app_colors.dart';
import '../l10n/strings.dart';
import 'gradient_background.dart';
import 'screen_header.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({
    required this.onBack,
    required this.onLegal,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onLegal;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return GradientBackground(
      child: Column(
        children: [
          ScreenHeader(title: s.settings, onBack: onBack),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                const _ToggleTile(
                  icon: Icons.volume_up_outlined,
                  labelKey: 'sound',
                ),
                const _ToggleTile(
                  icon: Icons.vibration,
                  labelKey: 'vibration',
                ),
                const SizedBox(height: 16),
                const LocalStorageNotice(),
                const SizedBox(height: 8),
                LegalLink(onTap: onLegal),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatefulWidget {
  const _ToggleTile({required this.icon, required this.labelKey});

  final IconData icon;
  final String labelKey;

  @override
  State<_ToggleTile> createState() => _ToggleTileState();
}

class _ToggleTileState extends State<_ToggleTile> {
  bool _on = true;

  String _resolveLabel(BuildContext context) {
    final s = S.of(context);
    if (widget.labelKey == 'sound') return s.sound;
    if (widget.labelKey == 'vibration') return s.vibration;
    return widget.labelKey;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon, color: AppColors.secondary),
      title: Text(
        _resolveLabel(context),
        style: const TextStyle(color: AppColors.text),
      ),
      trailing: Switch(
        value: _on,
        onChanged: (v) => setState(() => _on = v),
        activeColor: AppColors.secondary,
      ),
    );
  }
}
