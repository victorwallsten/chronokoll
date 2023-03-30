import 'package:flutter/material.dart';
import 'timer_widget.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({
    Key? key,
    required this.finishedAfter,
  }) : super(key: key);

  final Duration finishedAfter;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  TimerWidget? _timerWidget;

  @override
  void initState() {
    _timerWidget = TimerWidget(
      finishedAfter: widget.finishedAfter,
      onFinished: () {},
      onPlayPressed: (Duration timeElapsed) {},
      onPausePressed: () {},
      onStopPressed: () {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Timer'),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: _timerWidget,
        ));
  }
}
