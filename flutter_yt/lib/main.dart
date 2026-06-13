import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //where it goes to as soon as phone starts
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurple[200],
        appBar: AppBar(
                  ),
          body: Column(
            children: [
              Container(height: 200, width: 200, color: Colors.deepPurple),

              Container(height: 200, width: 200, color: Colors.deepPurple[400]),

              Container(height: 200, width: 200, color: Colors.deepPurple[200]),
            ],
          ),
      ),
    ); //scaffold when saved: white blank screen
    //Scaffold": skeleton widget that holds parts of the UI
  }
}
