import 'package:get/get.dart';
import 'package:odontogram/modules/medical_exam/controllers/classification_controller.dart';

class ClassificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ClassificationController());
  }
}
