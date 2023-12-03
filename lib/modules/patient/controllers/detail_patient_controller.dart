import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/models/patient.dart';
import 'package:odontogram/models/tooth.dart';
import 'package:odontogram/remote/firebase/patient_service.dart';
import 'package:odontogram/remote/firebase/tooth_service.dart';

class DetailPatientController extends GetxController {
  final PatientService patientService;
  final ToothService toothService;

  Rx<Patient?> patient = Rx(null);
  RxList<Tooth> toothList = RxList([]);

  DetailPatientController({
    required this.patientService,
    required this.toothService,
  });

  @override
  void onReady() async {
    super.onReady();
    patient.value = Get.arguments as Patient;
    assert(patient.value != null);
    toothList.bindStream(getAllToothData(patient.value!.id));
  }

  Stream<List<Tooth>> getAllToothData(String id) {
    final result = toothService.getAllToothData(id);
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
    } else {
      return result.data!;
    }
  }
}
