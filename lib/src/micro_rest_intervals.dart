import 'dart:math';

import 'package:flutter/material.dart';

import 'settings.dart';

class MicroRestIntervals {
  MicroRestIntervals(
      {this.settings = const Settings(),
      required this.onMicroRestStarted,
      required this.onMicroRestEnded,
      required this.onSessionEnded});

  final Settings settings;

  final void Function() onMicroRestStarted;
  final void Function() onMicroRestEnded;
  final void Function() onSessionEnded;

  Duration? _microRestScheduleTime;
  Duration _microRestStartTime = Duration.zero;

  void poll({required Duration timeRemaining}) {
    _microRestScheduleTime ??= settings.sessionLength;
    if (timeRemaining == _microRestScheduleTime) {
      _microRestScheduleTime =
          _microRestScheduleTime! - settings.intervalLength;
      _microRestStartTime = timeRemaining -
          Duration(
              seconds: Random().nextInt(settings.intervalLength.inSeconds -
                  settings.microRestLength.inSeconds));
      debugPrint(
          "microRestStartTime: ${(settings.sessionLength - _microRestStartTime).inSeconds}");
    }
    if (timeRemaining == _microRestStartTime) {
      onMicroRestStarted();
    } else if (timeRemaining ==
        _microRestStartTime - settings.microRestLength) {
      onMicroRestEnded();
    } else if (timeRemaining == Duration.zero) {
      onSessionEnded();
    }
  }
}
