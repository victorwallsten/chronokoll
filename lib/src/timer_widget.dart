import 'package:flutter/material.dart';
import 'periodic_timer.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({
    Key? key,
    required this.finishedAfter,
    required this.onFinished,
    required this.onPlayPressed,
    required this.onPausePressed,
    required this.onStopPressed,
  }) : super(key: key);

  final Duration finishedAfter;
  final void Function() onFinished;
  final void Function(Duration timeElapsed) onPlayPressed;
  final void Function() onPausePressed;
  final void Function() onStopPressed;

  final Duration resolution = const Duration(seconds: 1);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  PeriodicTimer? _timer;
  bool _isRunning = false;
  bool _isFinished = false;

  @override
  void initState() {
    _timer = PeriodicTimer(
        periodicity: widget.resolution,
        callback: () => setState(() {}),
        finishedAfter: widget.finishedAfter,
        onFinished: () {
          setState(() {
            _isRunning = false;
            _isFinished = true;
          });
          widget.onFinished();
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _text('${_twoDigitString(_timeRemaining().inMinutes, 100)}'
            ':'
            '${_twoDigitString(_timeRemaining().inSeconds, 60)}'),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _isRunning
                ? _iconButton(
                    iconData: Icons.pause_circle_rounded,
                    onPressed: _pause,
                  )
                : _iconButton(
                    iconData: Icons.play_circle_rounded,
                    onPressed: _play,
                  ),
            _iconButton(
              iconData: Icons.stop_circle_rounded,
              onPressed: _stop,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.pause();
    super.dispose();
  }

  Duration _timeRemaining() {
    Duration t =
        widget.finishedAfter - (_timer?.timeElapsed ?? const Duration());
    return t.compareTo(const Duration()) < 0 ? const Duration() : t;
  }

  IconButton _iconButton(
      {required IconData iconData, required void Function() onPressed}) {
    return IconButton(
      iconSize: 80.0,
      icon: Icon(iconData),
      onPressed: onPressed,
    );
  }

  void _play() {
    if (_isFinished == true) {
      return;
    }
    _timer?.start();
    setState(() {
      _isRunning = true;
    });
    widget.onPlayPressed(_timer?.timeElapsed ?? const Duration());
  }

  void _pause() {
    if (_isFinished == true) {
      return;
    }
    _timer?.pause();
    setState(() {
      _isRunning = false;
    });
    widget.onPausePressed();
  }

  void _stop() {
    _timer?.stop();
    setState(() {
      _isRunning = false;
      _isFinished = false;
    });
    widget.onStopPressed();
  }

  Text _text(String string) =>
      Text(string, style: const TextStyle(fontSize: 80.0));

  String _twoDigitString(int n, int modulus) =>
      n.remainder(modulus).toString().padLeft(2, '0');
}
