import 'package:flutter/material.dart';

import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.settings = const Settings()});

  final Settings settings;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Settings? _settings;

  @override
  void initState() {
    _settings = widget.settings;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              tooltip: 'Settings',
              onPressed: () async {
                _settings = await Navigator.pushNamed(
                  context,
                  '/settings',
                  arguments: _settings,
                ) as Settings?;
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            IconButton(
              iconSize: 64.0,
              onPressed: () async {
                _settings = await Navigator.pushNamed(
                  context,
                  '/microrestintervals',
                  arguments: _settings,
                ) as Settings?;
              },
              icon: const Icon(Icons.punch_clock_rounded),
            ),
          ])),
    );
  }
}
