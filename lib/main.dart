import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrumboard/Screens/ScrumBoard_Screen.dart';
import 'package:scrumboard/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //ignore: avoid_print
  print("handling a background message ${message.messageId}");
}

void initInfo() {
  var androidInitialize =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iosInitialize = const DarwinInitializationSettings(); //IOS
  var initializationsSettings =
      InitializationSettings(android: androidInitialize, iOS: iosInitialize);
  flutterLocalNotificationsPlugin.initialize(
    initializationsSettings,
    onDidReceiveNotificationResponse: ((NotificationResponse details) async {
      // ignore: avoid_print
      print(details.payload);
    }),
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  FirebaseMessaging.onMessage.listen((message) async {
    // ignore: avoid_print
    print("............ onMessage.................");
    // ignore: avoid_print
    print(
        "onMessage: ${message.notification?.title}/${message.notification?.body}");
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(),
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      playSound: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data['body'],
    );
  });
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initInfo();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyBoardApp());
}

class MyBoardApp extends StatefulWidget {
  const MyBoardApp({super.key});

  @override
  State<MyBoardApp> createState() => _MyBoardAppState();
}

class _MyBoardAppState extends State<MyBoardApp> {
  String? _token;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    requestPermission();
    fetchToken();
    initInfo();
    // ignore: avoid_print
    print("............ READY ..................");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft]);

    return MaterialApp(
      title: 'H4_ScrumBoard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity),
      home: const Home(),
    );
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        // ignore: avoid_print
        print("....... User granted permission....");
        break;
      case AuthorizationStatus.provisional:
        // ignore: avoid_print
        print("....... User granted provisional permission....");
        break;
      default:
        // ignore: avoid_print
        print("....... User denied permission....");
        break;
    }
  }

  Future<void> fetchToken() async {
    await FirebaseMessaging.instance
        .getToken()
        // ignore: avoid_print
        .then((token) => {_token = token, print("Token: $_token")});

    //save the token to Firebase live database
    String? modelInfo = Platform.isAndroid
        ? (await fetchModelInfo() as AndroidDeviceInfo).model
        : (await fetchModelInfo() as IosDeviceInfo).name;

    FirebaseDatabase.instance
        .ref("usertokens")
        .child(modelInfo!)
        .set({"token": _token});
  }

  Future<BaseDeviceInfo> fetchModelInfo() async {
    if (Platform.isAndroid) {
      return await deviceInfoPlugin.androidInfo;
    }
    if (Platform.isIOS) {
      return await deviceInfoPlugin.iosInfo;
    }
    throw Exception("Only Android or IOS is supported!");
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
