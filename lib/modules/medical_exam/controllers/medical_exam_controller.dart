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
  RxMap<ToothQuadrant, bool> quadrantMap = {
    ToothQuadrant.QUADRANT_I: false,
    ToothQuadrant.QUADRANT_II: false,
    ToothQuadrant.QUADRANT_III: false,
    ToothQuadrant.QUADRANT_IV: false
  }.obs;
  RxMap<String, Tooth> resultMap = RxMap();

  final medExamDateController = TextEditingController(text: DateTime.now().toString().split(" ")[0]);

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

  Future<void> saveMedicalRecord() async {
    isLoading.value = true;
    final result = await toothService.saveMedicalRecord(
      resultMap.values.toList(), 
      medExamDateController.text, 
      patientId.value
    );
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
        "Hasil pemeriksaan berhasil disimpan",
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

  Future<void> navigateToClassification(ToothQuadrant quadrant) async {
    String rawResult = await Get.toNamed(
      AppRoutes.NATIVE_CLASSIFICATION,
      arguments: Map.of(<String, dynamic>{
        "quadrant": quadrant,
        "patientId": patientId.value
      })
    );
    List<Tooth> result = rawResult.parseToToothList();
    quadrantMap[quadrant] = result.isNotEmpty;
    result.forEach((tooth) => resultMap[tooth.id] = tooth);
  }

  bool isButtonDisabled() => quadrantMap.values.every((el) => el) && !isLoading.value;
}
