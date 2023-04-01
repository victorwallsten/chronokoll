import 'package:flutter/material.dart';
import 'src/home_page.dart';
import 'src/settings.dart';
import 'src/settings_page.dart';
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
      onGenerateRoute: (RouteSettings routeSettings) {
        final Settings? settings = routeSettings.arguments as Settings?;
        switch (routeSettings.name) {
          case '/':
            return MaterialPageRoute(
                builder: (context) => HomePage(
                      settings: settings ?? const Settings(),
                    ));
          case '/microrestintervals':
            return MaterialPageRoute(
                builder: (context) => MicroRestIntervalsPage(
                    settings: settings ?? const Settings()));
          case '/settings':
            return MaterialPageRoute(
                builder: (context) =>
                    SettingsPage(settings: settings ?? const Settings()));
          default:
            assert(false, 'Not implemented: ${routeSettings.name}');
            return null;
        }
      },
    );
  }
}
