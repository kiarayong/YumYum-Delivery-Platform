
import 'package:firebase_core/firebase_core.dart'; // Import the firebase_core package.
import 'package:flutter/material.dart';
import 'package:l1_213544z_yongle_project/screens/homepage.dart';
//import 'package:l1_213544z_yongle_project/screens/loginpages/login.dart';
import 'package:l1_213544z_yongle_project/screens/loginpages/login_page.dart';
import 'package:l1_213544z_yongle_project/utils/universal_variables.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  // Initialize Firebase before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: UniversalVariables.orangeColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/login':(context)=> LoginPage(),
        '/home':(context)=>HomePage(),
      },
      home: LoginPage(),
    );
  }
}
