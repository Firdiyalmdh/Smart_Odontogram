import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:odontogram/service/firebase/auth_service.dart';
import 'package:odontogram/routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthService authService;
  RxBool showPassword = false.obs;
  RxBool isLoading = false.obs;

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  LoginController({required this.authService});

  Future<void> login() async {
    isLoading.value = true;
    final result = await authService.login(
        email: emailTextController.text, password: passwordTextController.text);
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
