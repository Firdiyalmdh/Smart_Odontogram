import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/models/patient.dart';
import 'package:odontogram/service/firebase/patient_service.dart';

class AddPatientController extends GetxController {
  final PatientService patientService;

  final nameController = TextEditingController();
  final nikController = TextEditingController();
  final birthPlaceController = TextEditingController();
  final birthDateController = TextEditingController();
  RxString selectedGender = "Laki-laki".obs;
  RxBool isLoading = false.obs;

  AddPatientController({required this.patientService});

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      birthDateController.text = picked.toString().split(" ")[0];
    }
  }

  Future<void> addPatient() async {
    final data = Patient(
      id: "",
      name: nameController.text,
      gender: selectedGender.value,
      birthDate: birthDateController.text,
      birthPlace: birthPlaceController.text,
      nik: nikController.text,
      lastCheckupDate: null,
    );
    isLoading.value = true;
    final result = await patientService.addPatient(data);
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
      Get.back();
      Get.snackbar(
        "Berhasil!",
        "Pasien berhasil ditambahkan",
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
    isLoading.value = false;
  }
}
