import 'package:get/get.dart';
import 'package:odontogram/modules/splash/index.dart';
import 'package:odontogram/service/firebase/auth_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(() => AuthService());
    Get.put(() => SplashController(authService: Get.find()));
  }
}
