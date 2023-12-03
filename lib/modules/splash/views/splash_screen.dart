import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/modules/splash/index.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
