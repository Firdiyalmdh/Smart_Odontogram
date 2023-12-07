import 'package:get/get.dart';
import 'package:odontogram/modules/medical_exam/controllers/classification_controller.dart';
import 'package:odontogram/service/firebase/tooth_service.dart';

class ClassificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ToothService());
    Get.lazyPut(() => ClassificationController(toothService: Get.find()));
  }
}
