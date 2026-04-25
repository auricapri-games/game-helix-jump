import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../config/level_params.dart';
import '../core/game_rules.dart';
import '../core/game_state.dart';
import '../core/level_generator.dart';

/// Drives the immutable [HelixState] forward via a [Ticker]. Widgets observe
/// it via [Listenable]; tests can drive it manually with [stepFor] without
/// needing a real frame loop.
class HelixController extends ChangeNotifier {
  HelixController(int phase, {TickerProvider? vsync, this.autoStart = true}) {
    _params = HelixParams.fromPhase(phase);
    _rules = HelixRules(_params);
    _state = const HelixGenerator().generate(_params);
    if (vsync != null) {
      _ticker = vsync.createTicker(_onTick);
      if (autoStart) _ticker!.start();
    }
  }

  static const HelixGenerator _generator = HelixGenerator();

  late HelixParams _params;
  late HelixRules _rules;
  late HelixState _state;
  Ticker? _ticker;
  Duration? _lastElapsed;

  /// Pending rotation accumulated from drag input, applied on next tick.
  double _pendingRotation = 0;

  final bool autoStart;

  HelixState get state => _state;
  HelixParams get params => _params;
  bool get isRunning => _ticker?.isActive ?? false;

  /// Advance the simulation by [dt] seconds, applying any pending rotation.
  /// Public so tests (and the integration test) can step deterministically.
  void stepFor(double dt) {
    if (_state.isOver) return;
    final move = HelixMove(
      rotationDelta: _pendingRotation,
      fallDelta: _params.fallSpeed * dt,
    );
    _pendingRotation = 0;
    final next = _rules.applyMove(_state, move);
    if (identical(next, _state)) return;
    _state = next;
    notifyListeners();
  }

  /// Queue a rotation in radians. Positive = clockwise (visually rightward
  /// drag rotates the tower's top toward the right).
  void addRotation(double radians) {
    if (_state.isOver) return;
    _pendingRotation += radians;
  }

  /// Restart the run for the same params (new seed reuses params.seed).
  void restart() {
    _state = _generator.generate(_params);
    _pendingRotation = 0;
    _lastElapsed = null;
    notifyListeners();
    if (_ticker != null && !_ticker!.isActive) _ticker!.start();
  }

  /// Bump phase (used by Level Complete flow if the title later opts in).
  void advancePhase() {
    _params = HelixParams.fromPhase(_params.phase + 1);
    _rules = HelixRules(_params);
    restart();
  }

  void pause() {
    if (_ticker?.isActive ?? false) _ticker!.stop();
  }

  void resume() {
    if (_ticker != null && !_ticker!.isActive) _ticker!.start();
  }

  void _onTick(Duration elapsed) {
    final last = _lastElapsed;
    _lastElapsed = elapsed;
    if (last == null) return;
    final dt = (elapsed - last).inMicroseconds / 1e6;
    if (dt <= 0) return;
    // Clamp to avoid huge jumps after backgrounding.
    stepFor(dt > 0.05 ? 0.05 : dt);
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }
}
