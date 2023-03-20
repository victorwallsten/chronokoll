import 'package:flutter/material.dart';
import 'src/home_page.dart';

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
      home: const HomePage(),
    );
  }
}
