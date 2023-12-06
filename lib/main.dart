import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/modules/splash/index.dart';
import 'package:odontogram/service/firebase/auth_service.dart';
import 'package:odontogram/routes/app_pages.dart';
import 'package:odontogram/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SmartOdontogramApp());
}

class SmartOdontogramApp extends StatelessWidget {
  const SmartOdontogramApp({super.key});

  static GlobalKey smartOdontogramKey = GlobalKey();
  static String appName = "Smart Odontogram";

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: smartOdontogramKey,
      debugShowCheckedModeBanner: false,
      title: appName,
      defaultTransition: Transition.fadeIn,
      getPages: AppPages.routes,
      initialRoute: AppRoutes.START,
      onReady: () {
        Get.put(AuthService());
        Get.put(SplashController(authService: Get.find()));
      },
      navigatorObservers: <NavigatorObserver>[GetObserver()],
    );
  }
}
