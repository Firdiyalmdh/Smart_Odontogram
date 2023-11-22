import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './pages/login_page.dart';

void main() {
  //await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}
