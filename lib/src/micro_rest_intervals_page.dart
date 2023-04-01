import 'package:chronokoll/src/micro_rest_intervals.dart';
import 'package:chronokoll/src/periodic_timer.dart';
import 'package:chronokoll/src/timer_widget.dart';
import 'package:flutter/material.dart';

import 'settings.dart';

class MicroRestIntervalsPage extends StatefulWidget {
  const MicroRestIntervalsPage({super.key, this.settings = const Settings()});

  final Settings settings;

  @override
  State<MicroRestIntervalsPage> createState() => _MicroRestIntervalsPageState();
}

class _MicroRestIntervalsPageState extends State<MicroRestIntervalsPage> {
  Settings? _settings;
  Duration? _timeRemaining;
  MicroRestIntervals? _microRestIntervals;
  TimerWidget? _timerWidget;
  PeriodicTimer? _periodicTimer;

  bool _isPaused = false;
  bool _isRunning = false;

  Color _backgroundColor = Colors.white;

  @override
  void initState() {
    _settings = widget.settings;
    _timeRemaining = widget.settings.sessionLength;
    _periodicTimer = PeriodicTimer(
        periodicity: widget.settings.resolution,
        callback: () {
          setState(() {
            _timeRemaining = (_timeRemaining ?? widget.settings.sessionLength) -
                widget.settings.resolution;
            _timerWidget = _makeTimerWidget();
            _microRestIntervals?.poll(
                timeRemaining: _timeRemaining ?? widget.settings.sessionLength);
          });
        });
    _microRestIntervals = _makeMicroRestIntervals();
    _timerWidget = _makeTimerWidget();
    super.initState();
  }

  MicroRestIntervals _makeMicroRestIntervals() {
    return MicroRestIntervals(
        settings: _settings ?? widget.settings,
        onMicroRestStarted: () {
          debugPrint("Rest start");
          setState(() {
            _backgroundColor = Colors.grey;
          });
        },
        onMicroRestEnded: () {
          debugPrint("Rest end");
          setState(() {
            _backgroundColor = Colors.white;
          });
        },
        onSessionEnded: () {
          debugPrint("Session end");
          _periodicTimer?.stop();
          setState(() {
            _isRunning = false;
            _isPaused = false;
            _backgroundColor = Colors.green;
            _timerWidget = _makeTimerWidget();
          });
        });
  }

  TimerWidget _makeTimerWidget() {
    return TimerWidget(
        timeRemaining: _timeRemaining ?? widget.settings.sessionLength,
        buttons: _makeButtons());
  }

  List<IconButton> _makeButtons() {
    return [
      _isPaused == true || _isRunning == false
          ? TimerWidget.timerWidgetIconButton(
              iconData: Icons.play_circle_rounded,
              onPressed: () {
                if (_timeRemaining?.compareTo(Duration.zero) == 0) {
                  return;
                }
                if (_isRunning == false) {
                  setState(() {
                    _isRunning = true;
                  });
                  _microRestIntervals?.poll(
                      timeRemaining:
                          _timeRemaining ?? widget.settings.sessionLength);
                }
                setState(() {
                  _isPaused = false;
                  _timerWidget = _makeTimerWidget();
                });
                _periodicTimer?.start();
              },
            )
          : TimerWidget.timerWidgetIconButton(
              iconData: Icons.pause_circle_rounded,
              onPressed: () {
                _periodicTimer?.pause();
                setState(() {
                  _isPaused = true;
                  _timerWidget = _makeTimerWidget();
                });
              },
            ),
      TimerWidget.timerWidgetIconButton(
        iconData: Icons.stop_circle_rounded,
        onPressed: () {
          _periodicTimer?.stop();
          setState(() {
            _isRunning = false;
            _isPaused = false;
            _backgroundColor = Colors.white;
            _timeRemaining =
                _settings?.sessionLength ?? widget.settings.sessionLength;
            _timerWidget = _makeTimerWidget();
            _microRestIntervals = _makeMicroRestIntervals();
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context, _settings),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Micro-Rest Intervals'),
        actions: [
          IconButton(
              tooltip: 'Settings',
              onPressed: () async {
                _periodicTimer?.stop();
                setState(() {
                  _isRunning = false;
                  _isPaused = true;
                  _timerWidget = _makeTimerWidget();
                });
                _settings = await Navigator.pushNamed(
                  context,
                  '/settings',
                  arguments: _settings,
                ) as Settings?;
                setState(() {
                  _timeRemaining =
                      _settings?.sessionLength ?? widget.settings.sessionLength;
                  _timerWidget = _makeTimerWidget();
                  _microRestIntervals = _makeMicroRestIntervals();
                });
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      backgroundColor: _backgroundColor,
      body: Column(children: [
        Center(child: _timerWidget),
      ]),
    );
  }

  @override
  void dispose() {
    _periodicTimer?.pause();
    super.dispose();
  }
}
