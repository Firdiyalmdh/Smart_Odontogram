import 'package:get/get.dart';
import 'package:odontogram/modules/home/controllers/home_controller.dart';
import 'package:odontogram/service/firebase/auth_service.dart';
import 'package:odontogram/service/firebase/patient_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => PatientService());
    Get.lazyPut(
      () => HomeController(
        authService: Get.find(),
        patientService: Get.find(),
      ),
    );
  }
}
