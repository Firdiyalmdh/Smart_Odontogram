import 'package:get/get.dart';
import 'package:odontogram/modules/medical_exam/controllers/medical_exam_controller.dart';
import 'package:odontogram/service/firebase/patient_service.dart';
import 'package:odontogram/service/firebase/tooth_service.dart';

class MedicalExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ToothService());
    Get.lazyPut(() => PatientService());
    Get.lazyPut(
      () => MedicalExamController(
        toothService: Get.find(),
        patientService: Get.find(),
      ),
    );
  }
}
