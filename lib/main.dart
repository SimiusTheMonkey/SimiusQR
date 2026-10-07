import 'package:flutter/material.dart';

import 'scanner_screen.dart';

void main() {
  runApp(const SimiusQrApp());
}

class SimiusQrApp extends StatelessWidget {
  const SimiusQrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimiusQR',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ScannerScreen(),
    );
  }
}
