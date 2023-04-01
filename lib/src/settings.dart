class Settings {
  const Settings(
      {this.sessionLength = const Duration(minutes: 90),
      this.intervalLength = const Duration(minutes: 2),
      this.microRestLength = const Duration(seconds: 10)});

  final Duration sessionLength;
  final Duration intervalLength;
  final Duration microRestLength;

  final Duration resolution = const Duration(seconds: 1);
}
