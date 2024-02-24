import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/service/firebase/patient_service.dart';
import 'package:odontogram/service/firebase/tooth_service.dart';

class MedicalExamController extends GetxController {
  final ToothService toothService;
  final PatientService patientService;
  RxBool isLoading = false.obs;
  RxString patientId = "".obs;

  final medExamDateController = TextEditingController();

  MedicalExamController({
    required this.toothService,
    required this.patientService,
  });

  @override
  void onReady() {
    super.onReady();
    patientId.value = Get.arguments as String;
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      medExamDateController.text = picked.toString().split(" ")[0];
    }
  }
}
