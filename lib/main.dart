import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrumboard/Screens/ScrumBoard_Screen.dart';
import 'Screens/Screens.dart';
import 'dart:math' as math;

void main() {
  runApp(MyBoardApp());
}

class MyBoardApp extends StatefulWidget {
  const MyBoardApp({super.key});

  @override
  State<MyBoardApp> createState() => _MyBoardAppState();
}

class _MyBoardAppState extends State<MyBoardApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);

    return MaterialApp(
      title: 'Awesome Board',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E0AB5),
        elevation: 0,
        title: Row(
          children: const <Widget>[
            Icon(
              Icons.view_column,
              color: Color(0xFF03995A),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              'Hello',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF01052C)),
            )
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
        ),
      ),
      body: ScrumBoardScreen(),
    );
  }
}
