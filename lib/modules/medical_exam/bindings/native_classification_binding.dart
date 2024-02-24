import 'package:get/get.dart';
import 'package:odontogram/service/native/native_classification_service.dart';
import '../index.dart';

class NativeClassificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NativeClassificationService());
    Get.lazyPut(() => NativeClassificationController(nativeClassificationService: Get.find()));
  }
}