import 'package:chronokoll/src/micro_rest_intervals.dart';
import 'package:chronokoll/src/timer_widget.dart';
import 'package:flutter/material.dart';

class MicroRestIntervalsPage extends StatefulWidget {
  const MicroRestIntervalsPage(
      {super.key,
      required this.sessionLength,
      required this.intervalLength,
      required this.microRestLength});

  final Duration sessionLength;
  final Duration intervalLength;
  final Duration microRestLength;

  @override
  State<MicroRestIntervalsPage> createState() => _MicroRestIntervalsPageState();
}

class _MicroRestIntervalsPageState extends State<MicroRestIntervalsPage> {
  MicroRestIntervals? _microRestIntervals;
  TimerWidget? _timerWidget;

  bool _isPaused = true;

  Color _backgroundColor = Colors.white;

  @override
  void initState() {
    _microRestIntervals = MicroRestIntervals(
        intervalLength: widget.intervalLength,
        microRestLength: widget.microRestLength,
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
        });
    _timerWidget = TimerWidget(
        finishedAfter: widget.sessionLength,
        onFinished: () {
          _microRestIntervals?.stop();
          debugPrint("Finished");
        },
        onPlayPressed: (Duration timeElapsed) {
          if (_isPaused == true) {
            _isPaused = false;
            _microRestIntervals?.start(timeElapsed);
          }
        },
        onPausePressed: () {
          if (_isPaused == false) {
            _isPaused = true;
            _microRestIntervals?.pause();
          }
        },
        onStopPressed: () {
          _isPaused = true;
          _microRestIntervals?.stop();
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Micro-Rest Intervals')),
      backgroundColor: _backgroundColor,
      body: Column(children: [
        Center(child: _timerWidget),
      ]),
    );
  }

  @override
  void dispose() {
    _microRestIntervals?.pause();
    super.dispose();
  }
}
