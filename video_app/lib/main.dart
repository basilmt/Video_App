import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_app/home.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp(),debugShowCheckedModeBanner: false,));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return LoginScreen();
    }
    else {
      return Home();
    }
  }
}

