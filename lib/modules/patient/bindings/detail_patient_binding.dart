import 'package:get/get.dart';
import 'package:odontogram/modules/patient/controllers/detail_patient_controller.dart';
import 'package:odontogram/service/firebase/patient_service.dart';
import 'package:odontogram/service/firebase/tooth_service.dart';

class DetailPatientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PatientService());
    Get.lazyPut(() => ToothService());
    Get.lazyPut(
      () => DetailPatientController(
        patientService: Get.find(),
        toothService: Get.find(),
      ),
    );
  }
}
