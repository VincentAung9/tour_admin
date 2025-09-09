import 'dart:async';
import 'package:flutter/foundation.dart';

class Debouncer {
  final Duration delay;
  final bool leading; // if true, call immediately on first run then debounce
  Timer? _timer;
  bool _hasCalledLeading = false;

  Debouncer({required this.delay, this.leading = false});

  /// Run the [action] after [delay]. If [leading] is true, the first call
  /// executes immediately and subsequent calls are suppressed until [delay]
  /// passes.
  void run(VoidCallback action) {
    if (leading && !_hasCalledLeading) {
      _hasCalledLeading = true;
      action();
      _timer?.cancel();
      _timer = Timer(delay, () {
        _hasCalledLeading = false;
      });
      return;
    }

    // Standard trailing behavior: cancel previous and schedule new
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Alias so you can call instance like `debouncer(() => ...)`
  void call(VoidCallback action) => run(action);

  /// Cancel any pending action.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _hasCalledLeading = false;
  }

  /// Dispose when no longer needed (e.g. in State.dispose()).
  void dispose() => cancel();
}
