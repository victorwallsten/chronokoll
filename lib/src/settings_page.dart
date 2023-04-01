import 'package:flutter/material.dart';

import 'settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    this.settings = const Settings(),
  });

  final Settings settings;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _settings),
        ),
        title: const Text('Settings'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              _durationText(
                  'session',
                  _settings?.sessionLength ??
                      widget.settings.sessionLength),
              const SizedBox(height: 40),
              Slider(
                  min: 1,
                  max: 90,
                  value: _settings?.sessionLength.inMinutes.toDouble() ??
                      widget.settings.sessionLength.inMinutes.toDouble(),
                  divisions: 89,
                  onChanged: (double value) => setState(() {
                        _settings = Settings(
                            sessionLength: Duration(minutes: value.toInt()),
                            intervalLength: _settings?.intervalLength ??
                                widget.settings.intervalLength,
                            microRestLength: _settings?.microRestLength ??
                                widget.settings.microRestLength);
                      })),
            ],
          ),
          Column(
            children: [
              _durationText(
                  'interval',
                  _settings?.intervalLength ??
                      widget.settings.intervalLength),
              const SizedBox(height: 40),
              Slider(
                  min: 10,
                  max: 600,
                  value: _settings?.intervalLength.inSeconds.toDouble() ??
                      widget.settings.intervalLength.inSeconds.toDouble(),
                  divisions: 59,
                  onChanged: (double value) => setState(() {
                        _settings = Settings(
                            sessionLength: _settings?.sessionLength ??
                                widget.settings.sessionLength,
                            intervalLength: Duration(seconds: value.toInt()),
                            microRestLength: _settings?.microRestLength ??
                                widget.settings.microRestLength);
                      })),
            ],
          ),
          Column(
            children: [
              _durationText(
                  'micro rest',
                  _settings?.microRestLength ??
                      widget.settings.microRestLength),
              const SizedBox(height: 40),
              Slider(
                  min: 1,
                  max: 60,
                  value: _settings?.microRestLength.inSeconds.toDouble() ??
                      widget.settings.microRestLength.inSeconds.toDouble(),
                  divisions: 59,
                  onChanged: (double value) => setState(() {
                        _settings = Settings(
                          sessionLength: _settings?.sessionLength ??
                              widget.settings.sessionLength,
                          intervalLength: _settings?.intervalLength ??
                              widget.settings.intervalLength,
                          microRestLength: Duration(seconds: value.toInt()),
                        );
                      })),
            ],
          ),
        ],
      ),
    );
  }

  Text _durationText(String label, Duration duration) {
    String durationToTime(Duration duration) {
      int h = duration.inHours;
      int m = duration.inMinutes.remainder(60);
      int s = duration.inSeconds.remainder(60);
      String hours = h > 0 ? '${h.toString()} h ' : '';
      String minutes = m > 0 ? '${m.toString()} m ' : '';
      String seconds = s > 0 ? '${s.toString()} s' : '';
      return '$hours$minutes$seconds';
    }

    return Text('$label: ${durationToTime(duration)}',
        style: const TextStyle(fontSize: 32));
  }
}
