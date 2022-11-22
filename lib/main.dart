import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: const Text("Hello World"),
        ),
        body: ListView.builder(itemBuilder: (_, index) {
          return randomColor(index);
        }),
      ),
    );
  }

  Container randomColor(int index) {
    return Container(
      color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0),
      width: 200,
      height: 500,
      child: Center(
        child: Text(
          "$index",
          style: const TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}
