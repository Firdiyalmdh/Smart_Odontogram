// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/models/patient.dart';
import 'package:odontogram/models/user.dart';

import 'package:odontogram/service/firebase/auth_service.dart';
import 'package:odontogram/service/firebase/patient_service.dart';
import 'package:odontogram/routes/app_routes.dart';

class HomeController extends GetxController {
  final AuthService authService;
  final PatientService patientService;

  final searchController = TextEditingController();
  var user = const User(email: "", institute: "", name: "").obs;
  RxList<Patient> patients = RxList([]);
  RxList<Patient> filteredPatients = RxList([]);
  RxBool isLoading = RxBool(false);

  HomeController({
    required this.authService,
    required this.patientService,
  });

  @override
  void onReady() async {
    super.onReady();
    await getUserDetail();
    patients.bindStream(getAllPatients());
  }

  Future<void> getUserDetail() async {
    var result = await authService.getUserDetail();
    if (result.error != null) {
      Get.snackbar(
        "Error!",
        result.error.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        icon: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      );
    } else {
      user.value = result.data!;
    }
  }

  List<Patient> filterPatient() => patients
      .where((item) => item.name.toLowerCase().contains(searchController.text))
      .toList();

  void updateFilteredPatient() {
    filteredPatients.clear();
    filteredPatients.addAll(filterPatient());
  }

  Stream<List<Patient>> getAllPatients() {
    isLoading.value = true;
    final result = patientService.getAllPatients();
    if (result.error != null || result.data == null) {
      Get.snackbar(
        "Error!",
        result.error.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        icon: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      );
      return const Stream.empty();
    }
    isLoading.value = false;
    return result.data!;
  }

  Future<void> deletePatient(String id) async {
    final result = await patientService.deletePatien(id);
    if (result.error != null) {
      Get.snackbar(
        "Error!",
        result.error.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        icon: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      );
    } else {
      Get.snackbar(
        "Berhasil!",
        "Data pasien sudah terhapus",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        icon: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      );
    }
  }

  Future<void> logout() async {
    final result = await authService.logout();
    if (result.error != null) {
      Get.snackbar(
        "Error!",
        result.error.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        icon: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      );
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
