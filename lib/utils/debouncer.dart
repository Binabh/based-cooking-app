import 'dart:async';

class DeBouncer {
  final Duration delay;
  Timer? _timer;

  DeBouncer({required this.delay});

  run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
