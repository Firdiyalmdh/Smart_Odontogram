import 'package:get/get.dart';
import 'package:odontogram/service/native/native_classification_service.dart';

class NativeClassificationController extends GetxController {
  final NativeClassificationService nativeClassificationService;
  RxString result = "".obs;

  NativeClassificationController({
    required this.nativeClassificationService
  });

  @override
  void onReady() async {
    super.onReady();
    final args = Get.arguments as Map<String, dynamic>;
    result.value = await nativeClassificationService.runNativeClassification(
      args['patientId'] ?? "",
      args['quadrant']
    );
    result; // TODO show toast and back to new medical exam screen
  }
}