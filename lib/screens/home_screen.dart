import 'package:flutter/material.dart';

import '../state/best_score_store.dart';
import '../widgets/home_body.dart';
import 'gameplay_screen.dart';
import 'legal_screen.dart';
import 'level_select_screen.dart';
import 'remove_ads_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BestScoreStore _store = BestScoreStore();

  @override
  void initState() {
    super.initState();
    _store.load();
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  void _push(WidgetBuilder b) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: b));
  }

  void _play() => _push(
        (_) => GameplayScreen(phase: 1, onGameEnd: _store.submit),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeBody(
        store: _store,
        callbacks: HomeNavCallbacks(
          onPlay: _play,
          onLevelSelect: () => _push((_) => const LevelSelectScreen()),
          onSettings: () => _push((_) => const SettingsScreen()),
          onRemoveAds: () => _push((_) => const RemoveAdsScreen()),
          onLegal: () => _push((_) => const LegalScreenWrapper()),
        ),
      ),
    );
  }
}
