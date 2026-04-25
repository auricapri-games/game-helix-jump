import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kBestScoreKey = 'helix_best_score';

/// Lightweight ChangeNotifier wrapping the persisted best score so the home
/// screen can react without owning the SharedPreferences contract.
class BestScoreStore extends ChangeNotifier {
  int _value = 0;
  int get value => _value;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _value = prefs.getInt(kBestScoreKey) ?? 0;
    notifyListeners();
  }

  Future<bool> submit(int score) async {
    if (score <= _value) return false;
    _value = score;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kBestScoreKey, score);
    return true;
  }
}
