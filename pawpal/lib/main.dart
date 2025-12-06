import 'package:flutter/material.dart';
import 'package:pawpal/views/splashscreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 234, 215, 146)),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 232, 217, 164),
          foregroundColor: Colors.black,
          ),
      ),
      home: SplashScreen(),
    );
  }
}