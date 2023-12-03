// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:odontogram/remote/firebase/auth_service.dart';
import 'package:odontogram/remote/firebase/patient_service.dart';
import 'package:odontogram/routes/app_routes.dart';

class HomeController extends GetxController {
  final AuthService authService;
  final PatientService patientService;

  final searchController = TextEditingController();

  HomeController({
    required this.authService,
    required this.patientService,
  });

  Future<void> logout() async {
    final result = await authService.logout();
    if (result.error != null) {
      Get.snackbar(
        "Error!",
        result.error.toString(),
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
