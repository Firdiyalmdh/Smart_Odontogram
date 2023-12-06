import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:odontogram/service/firebase/auth_service.dart';
import 'package:odontogram/routes/app_routes.dart';

class SplashController extends GetxController {
  final AuthService authService;
  late Rx<User?> user;

  SplashController({required this.authService});

  @override
  void onReady() {
    super.onReady();
    user = Rx<User?>(authService.currentUser);
    user.bindStream(authService.userChanges());
    ever(user, _checkUser);
  }

  Future<void> _checkUser(User? user) async {
    Future.delayed(const Duration(seconds: 3));
    if (user != null) {
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
