import 'package:flutter/material.dart';
import 'src/home_page.dart';
import 'src/timer_page.dart';
import 'src/micro_rest_intervals_page.dart';

void main() {
  runApp(const Chronokoll());
}

class Chronokoll extends StatelessWidget {
  const Chronokoll({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chronokoll',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/timer': (context) =>
            const TimerPage(finishedAfter: Duration(minutes: 90)),
        '/microrestintervals': (context) => const MicroRestIntervalsPage(
            sessionLength: Duration(minutes: 90),
            intervalLength: Duration(minutes: 2),
            microRestLength: Duration(seconds: 10)),
      },
    );
  }
}
