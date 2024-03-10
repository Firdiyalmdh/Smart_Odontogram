import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/models/tooth.dart';
import 'package:odontogram/routes/app_routes.dart';
import 'package:odontogram/service/firebase/patient_service.dart';
import 'package:odontogram/service/firebase/tooth_service.dart';

class MedicalExamController extends GetxController {
  final ToothService toothService;
  final PatientService patientService;
  RxBool isLoading = false.obs;
  RxString patientId = "".obs;
  RxMap<ToothQuadrant, bool> resultMap = {
    ToothQuadrant.QUADRANT_I: false,
    ToothQuadrant.QUADRANT_II: false,
    ToothQuadrant.QUADRANT_III: false,
    ToothQuadrant.QUADRANT_IV: false
  }.obs;

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

  Future<void> navigateToClassification(ToothQuadrant quadrant) async {
    final result = await Get.toNamed(
      AppRoutes.NATIVE_CLASSIFICATION,
      arguments: Map.of(<String, dynamic>{
        "quadrant": quadrant,
        "patientId": patientId.value
      })
    );
    resultMap[quadrant] = result.toString() == "SUCCESS";
  }
}
