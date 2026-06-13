import 'package:aquabuddy/mainscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  //shows SplashScreen as first screen
  Widget build(BuildContext context) {
    return const MaterialApp(home: SplashScreen());
  }
}

//time-based navigation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        //opens to MainScreen after 2 seconds of delay
        MaterialPageRoute(builder: (context) => const MainScreen()), 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/drink-water.png', scale: 4.0),
            Text(
              "AquaBuddy",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ), //TextStyle
            ), //Text 
            Text(
              "Your Hydration Calculator",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ), //TextStyle
            ), //Text 
          SizedBox(height: 10),
          CircularProgressIndicator(),
          SizedBox(height: 30),        
          ],
        ), //Column
      ), //Center
    ); //Scaffold
  }
}