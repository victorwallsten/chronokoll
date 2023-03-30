import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            IconButton(
              iconSize: 64.0,
              onPressed: () {
                Navigator.pushNamed(context, '/timer');
              },
              icon: const Icon(Icons.timer_rounded),
            ),
            IconButton(
              iconSize: 64.0,
              onPressed: () {
                Navigator.pushNamed(context, '/microrestintervals');
              },
              icon: const Icon(Icons.punch_clock_rounded),
            ),
          ])),
    );
  }
}
