import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// takkan berubah, tetap
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//initialize counter yang kita tekan jadi 0 
//private class 
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

//logic bila tambah button
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter', //tunjuk berapa kali dia tekan button
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            
            MaterialButton(
              onPressed: _incrementCounter, //bila tekan, counter akan bertambah
              color: const Color.fromARGB(255, 151, 128, 214), //warna butang yang kita tekan 
              child: const Text("Press ME"), //teks butang yang kita tekan
            ),
          ],
        ),
      ),
    );
  }
}