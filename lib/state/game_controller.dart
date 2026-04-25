import 'package:flutter/foundation.dart';

import '../config/level_params.dart';
import '../core/game_rules.dart';
import '../core/game_state.dart';
import '../core/level_generator.dart';

/// Mutable wrapper around the immutable [HelixState] so widgets can observe
/// changes. Lives in `lib/state/` (outside the lint layer system) so screens
/// can subscribe via [Listenable] without crossing layer boundaries.
class HelixController extends ChangeNotifier {
  HelixController(int phase) {
    _params = HelixParams.fromPhase(phase);
    _state = const HelixGenerator().generate(_params);
  }

  static const _rules = HelixRules();
  static const _generator = HelixGenerator();

  late HelixParams _params;
  late HelixState _state;

  HelixState get state => _state;
  HelixParams get params => _params;

  void drop() {
    final next = _rules.applyMove(_state, const DropBall());
    if (identical(next, _state)) return;
    _state = next;
    notifyListeners();
  }

  void rotate(int delta) {
    final next = _rules.applyMove(_state, RotateBy(delta));
    if (identical(next, _state)) return;
    _state = next;
    notifyListeners();
  }

  void restart() {
    _state = _generator.generate(_params);
    notifyListeners();
  }

  void advancePhase() {
    _params = HelixParams.fromPhase(_params.phase + 1);
    _state = _generator.generate(_params);
    notifyListeners();
  }
}
