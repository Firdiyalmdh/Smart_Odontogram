import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:odontogram/service/firebase/auth_service.dart';
import 'package:odontogram/routes/app_routes.dart';

class RegisterController extends GetxController {
  final AuthService authService;
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;

  final nameTextController = TextEditingController();
  final instituteTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  RegisterController({required this.authService});

  Future<void> register() async {
    isLoading.value = true;
    final result = await authService.register(
        name: nameTextController.text,
        institute: instituteTextController.text,
        email: emailTextController.text,
        password: passwordTextController.text);
    if (result.error != null) {
      Get.snackbar(
        "Error!",
        result.error.toString(),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.offAllNamed(AppRoutes.HOME);
    }
    isLoading.value = false;
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }
}
