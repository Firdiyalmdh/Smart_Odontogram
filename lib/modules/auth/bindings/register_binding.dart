import 'package:get/get.dart';
import 'package:odontogram/modules/auth/controllers/register_controller.dart';
import 'package:odontogram/service/firebase/auth_service.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => RegisterController(authService: Get.find()));
  }
}
