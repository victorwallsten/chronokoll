import 'package:flutter/material.dart';
import 'periodic_timer.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget(
      {Key? key, required this.finishedAfter, required this.onFinished})
      : super(key: key);

  final Duration finishedAfter;
  final void Function() onFinished;

  final Duration periodicity = const Duration(milliseconds: 100);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  PeriodicTimer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    _timer = PeriodicTimer(
        periodicity: widget.periodicity,
        callback: (_) => setState(() {}),
        finishedAfter: widget.finishedAfter,
        onFinished: () {
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
                    onPressed: _start,
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
    Duration t = _timer?.timeRemaining() ?? widget.finishedAfter;
    return t.inMilliseconds < 0 ? const Duration() : t;
  }

  IconButton _iconButton(
      {required IconData iconData, required void Function() onPressed}) {
    return IconButton(
      iconSize: 80.0,
      icon: Icon(iconData),
      onPressed: onPressed,
    );
  }

  void _start() {
    _timer?.start();
    setState(() {
      _isRunning = true;
    });
  }

  void _stop() {
    _timer?.stop();
    setState(() {
      _isRunning = false;
    });
  }

  void _pause() {
    _timer?.pause();
    setState(() {
      _isRunning = false;
    });
  }

  Text _text(String string) =>
      Text(string, style: const TextStyle(fontSize: 80.0));

  String _twoDigitString(int n, int modulus) =>
      n.remainder(modulus).toString().padLeft(2, '0');
}
