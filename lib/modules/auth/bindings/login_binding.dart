import 'package:get/get.dart';
import 'package:odontogram/modules/auth/controllers/login_controller.dart';
import 'package:odontogram/service/firebase/auth_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => LoginController(authService: Get.find()));
  }
}
