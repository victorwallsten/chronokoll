import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    Key? key,
    required this.timeRemaining,
    required this.buttons,
  }) : super(key: key);

  final Duration timeRemaining;
  final List<IconButton> buttons;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _timerWidgetText('${_twoDigitString(timeRemaining.inMinutes, 100)}'
            ':'
            '${_twoDigitString(timeRemaining.inSeconds, 60)}'),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons,
        ),
      ],
    );
  }

  String _twoDigitString(int n, int modulus) =>
      n.remainder(modulus).toString().padLeft(2, '0');

  Text _timerWidgetText(String string) =>
      Text(string, style: const TextStyle(fontSize: 80.0));

  static IconButton timerWidgetIconButton(
      {required IconData iconData, required VoidCallback onPressed}) {
    return IconButton(
      iconSize: 80.0,
      icon: Icon(iconData),
      onPressed: onPressed,
    );
  }
}
