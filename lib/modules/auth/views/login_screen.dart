import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/modules/auth/controllers/login_controller.dart';
import 'package:odontogram/routes/app_routes.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/login_background.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
              height: Get.height,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome Back.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Smart Odontogram",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Email"),
                  ),
                  TextField(
                    controller: controller.emailTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Password"),
                  ),
                  Obx(
                    () => TextField(
                      controller: controller.passwordTextController,
                      obscureText: !controller.showPassword.value,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(8),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.showPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            controller.togglePasswordVisibility();
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          controller.login();
                        },
                        child: (controller.isLoading.value)
                            ? Transform.scale(
                                scale: .75,
                                child: const CircularProgressIndicator(
                                    color: Colors.white))
                            : const Text("Login"),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Belum punya akun?"),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.REGISTER);
                        },
                        child: const Text("Daftar disini"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
