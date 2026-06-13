import 'package:flutter/material.dart';
import 'package:pawpal/model/user.dart';
import 'package:pawpal/pages/login_page.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.orange[100],
        child: Center(
          child: Text(
            "Welcome to PawPal, ${currentUser!.name}!",
            style: TextStyle(
              fontSize: 28,
              fontFamily: "Bubblegum Sans",
              fontWeight: FontWeight.bold,
              color: Colors.orange[600],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getUserData() async {}
}
