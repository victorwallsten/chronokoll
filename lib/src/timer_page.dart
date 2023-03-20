import 'package:flutter/material.dart';
import 'timer_widget.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({
    Key? key,
    required this.finishedAfter,
  }) : super(key: key);

  final Duration finishedAfter;

  final String title = 'Timer';

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  TimerWidget? _timerWidget;

  @override
  void initState() {
    _timerWidget =
        TimerWidget(finishedAfter: widget.finishedAfter, onFinished: () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: _timerWidget,
        ));
  }
}
