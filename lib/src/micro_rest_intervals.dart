import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'periodic_timer.dart';

class MicroRestIntervals {
  MicroRestIntervals(
      {required this.intervalLength,
      required this.microRestLength,
      required this.onMicroRestStarted,
      required this.onMicroRestEnded,
      this.sessionLength,
      this.onSessionEnded});

  final Duration? sessionLength;
  final Duration intervalLength;
  final Duration microRestLength;

  final void Function() onMicroRestStarted;
  final void Function() onMicroRestEnded;
  final void Function()? onSessionEnded;

  Duration _microRestOffset = const Duration();

  bool _isRunning = false;
  bool _isPaused = false;
  bool _isMicroResting = false;

  PeriodicTimer? _intervalTimer;
  Timer? _microRestOffsetTimer;
  Timer? _microRestTimer;
  Timer? _resumeTimer;

  void _cancelTimers() {
    _microRestOffsetTimer?.cancel();
    _microRestTimer?.cancel();
    _resumeTimer?.cancel();
  }

  void _startIntervalTimer() {
    _scheduleMicroRest();
    _intervalTimer = PeriodicTimer(
        periodicity: intervalLength,
        callback: _scheduleMicroRest,
        finishedAfter: sessionLength,
        onFinished: onSessionEnded);
    _intervalTimer?.start();
  }

  void start(Duration timeElapsed) {
    Duration intervalElapsed =
        Duration(seconds: timeElapsed.inSeconds % intervalLength.inSeconds);
    if (_isRunning == false) {
      _isRunning = true;
      _startIntervalTimer();
    }
    if (_isPaused == true) {
      debugPrint(
          "start: calling startIntervalTimer in ${(intervalLength - intervalElapsed).inSeconds}");
      _resumeTimer =
          Timer(intervalLength - intervalElapsed, _startIntervalTimer);
      if (intervalElapsed.compareTo(_microRestOffset) < 0) {
        debugPrint(
            "start: calling microRestStart in ${(_microRestOffset - intervalElapsed).inSeconds}");
        _microRestOffsetTimer =
            Timer(_microRestOffset - intervalElapsed, _microRestStart);
      } else if (_isMicroResting == true) {
        debugPrint(
            "start: calling microRestEnd in ${(_microRestOffset + microRestLength - intervalElapsed).inSeconds}");
        _microRestTimer = Timer(
            _microRestOffset + microRestLength - intervalElapsed,
            _microRestEnd);
      }
    }
    _isPaused = false;
  }

  void pause() {
    _isPaused = true;
    _intervalTimer?.pause();
    _cancelTimers();
  }

  void stop() {
    _isRunning = false;
    _isPaused = false;
    _intervalTimer?.stop();
    _cancelTimers();
  }

  void _microRestEnd() {
    _isMicroResting = false;
    onMicroRestEnded();
  }

  void _microRestStart() {
    _isMicroResting = true;
    onMicroRestStarted();
    _microRestTimer = Timer(microRestLength, _microRestEnd);
  }

  void _scheduleMicroRest() {
    int randomInt =
        Random().nextInt(intervalLength.inSeconds - microRestLength.inSeconds);
    _microRestOffset = Duration(seconds: randomInt);
    _microRestOffsetTimer = Timer(_microRestOffset, _microRestStart);
    debugPrint("Offset: ${_microRestOffset.inSeconds}");
  }
}
