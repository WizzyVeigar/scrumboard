import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrumboard/Screens/ScrumBoard_Screen.dart';
import 'package:scrumboard/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyBoardApp());
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
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E0AB5),
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
          preferredSize: const Size.fromHeight(1.0),
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
