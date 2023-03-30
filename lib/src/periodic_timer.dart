import 'dart:async';

import 'package:flutter/material.dart';

class PeriodicTimer {
  PeriodicTimer(
      {required this.periodicity,
      required this.callback,
      this.finishedAfter,
      this.onFinished});

  final Duration periodicity;
  final void Function() callback;
  final Duration? finishedAfter;
  final void Function()? onFinished;

  Duration timeElapsed = const Duration();

  Timer? _callbackTimer;
  Timer? _pauseTimer;

  void _cancelTimers() {
    _callbackTimer?.cancel();
    _pauseTimer?.cancel();
  }

  void start() {
    _callbackTimer = Timer.periodic(periodicity, (_) {
      timeElapsed = timeElapsed + periodicity;
      debugPrint("Time elapsed: ${timeElapsed.inSeconds}");
      callback();
      if (finishedAfter != null) {
        if (timeElapsed.compareTo(finishedAfter!) >= 0) {
          _cancelTimers();
          onFinished?.call();
        }
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
}
