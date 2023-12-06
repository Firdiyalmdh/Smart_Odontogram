import 'package:get/get.dart';
import 'package:odontogram/modules/patient/controllers/add_patient_controller.dart';
import 'package:odontogram/service/firebase/patient_service.dart';

class AddPatientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PatientService());
    Get.lazyPut(() => AddPatientController(patientService: Get.find()));
  }
}
