import 'package:flutter/material.dart';

import '../widgets/settings_body.dart';
import 'legal_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsBody(
        onBack: () => Navigator.of(context).pop(),
        onLegal: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const LegalScreenWrapper()),
        ),
      ),
    );
  }
}
