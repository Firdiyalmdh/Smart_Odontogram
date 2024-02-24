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
    print("test controller");
    result.value = await nativeClassificationService.runNativeClassification();
    result; // TODO call api to save it into firebase
  }
}