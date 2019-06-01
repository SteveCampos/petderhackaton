import 'package:adoptame/src/login.dart';
import 'package:adoptame/src/model/message.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp( AppMain());
}

class AppMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      title: "Petder",
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      theme: ThemeData(
        primaryColor: Colors.purple[800],
        accentColor: Colors.cyan[600],
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        ),
      )
    ); 
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  final List<Message> messages =[];

  @override
  void initState(){
    super.initState();
    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async{
        print("onMessage: $message");
        final notification = message['notification'];
        setState((){
          messages.add(Message(
            title:notification['title'], body:notification['body']));

        });
      },
      onLaunch: (Map<String, dynamic> message) async{
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async{
        print("onResume: $message");
      }
    );
    _messaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true,badge: true,alert: true));

  }

  @override
  Widget build(BuildContext context) {
    return  SplashScreen(
      seconds:4,
      navigateAfterSeconds: LoginScreen(),
      imageBackground: AssetImage('assets/splash.png'),
      backgroundColor: Colors.green,
      photoSize: 100.0,
      loaderColor: Colors.white
    );
  }
}




