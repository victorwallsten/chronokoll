import 'dart:async';

class PeriodicTimer {
  PeriodicTimer(
      {required this.periodicity,
      required this.callback,
      required this.finishedAfter,
      required this.onFinished});

  final Duration periodicity;
  final void Function(Timer timer) callback;
  final Duration finishedAfter;
  final void Function() onFinished;

  Duration timeElapsed = const Duration();

  Timer? _callbackTimer;
  Timer? _pauseTimer;

  void _cancelTimers() {
    _callbackTimer?.cancel();
    _pauseTimer?.cancel();
  }

  void start() {
    _cancelTimers();
    _callbackTimer = Timer.periodic(periodicity, (t) {
      callback(t);
      timeElapsed = Duration(
          milliseconds:
              timeElapsed.inMilliseconds + periodicity.inMilliseconds);
      if (timeElapsed.compareTo(finishedAfter) > 0) {
        pause();
        onFinished();
      }
    });
  }

  void stop() {
    _cancelTimers();
    timeElapsed = const Duration();
  }

  void pause() {
    _cancelTimers();
  }

  void pauseFor(Duration duration) {
    _cancelTimers();
    _pauseTimer = Timer(duration, start);
  }

  Duration timeRemaining() {
    return Duration(
        milliseconds:
            finishedAfter.inMilliseconds - timeElapsed.inMilliseconds);
  }
}
