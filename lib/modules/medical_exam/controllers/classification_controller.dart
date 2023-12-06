import 'package:get/get.dart';
import 'package:odontogram/models/tooth.dart';

class ClassificationController extends GetxController {
  Rx<ToothQuadrant> quadrant = ToothQuadrant.QUADRANT_I.obs;
  RxList<int> idList = RxList.empty();
  RxMap<int, Tooth?> result = RxMap.identity();
  RxBool isReverse = false.obs;

  ClassificationController();

  @override
  void onReady() {
    super.onReady();
    quadrant.value = Get.arguments as ToothQuadrant;
    idList.clear();
    idList.addAll(quadrant.value.idList);
    isReverse.value = quadrant.value.isReverse;
    for (var id in idList) {
      result[id] = null;
    }
  }

  void editResult(int id, Tooth data) {
    result[id] = data;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
