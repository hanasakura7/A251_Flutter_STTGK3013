import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';

//kena direct kat mainscreen/homescreen, tunjuk "welcome, (nama user tu)!"
class MainScreen extends StatefulWidget {
  final User? user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //to be adjusted
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" PawPal 🐾")),
      body: Center(
        child: Text(
          "Welcome, ${widget.user!.userName}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
