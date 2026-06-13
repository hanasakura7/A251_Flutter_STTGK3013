import 'package:flutter/material.dart';
import 'package:pawpal/pages/register_page.dart';

void main() {
  runApp(const PawPal());
}

class PawPal extends StatefulWidget {
  const PawPal({super.key});

  @override
  State<PawPal> createState() => _PawPalState();
}

class _PawPalState extends State<PawPal> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange[400],
          foregroundColor: Colors.white,
          toolbarTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'Bubblegum Sans',
          ),
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Bubblegum Sans',
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: RegisterPage(),
    );
  }
}
