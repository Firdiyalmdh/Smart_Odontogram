import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/models/tooth.dart';
import 'package:tflite/tflite.dart';

class ClassificationController extends GetxController {
  CameraController? cameraController;
  CameraImage? cameraImage;
  RxList<dynamic> recognitionsList= RxList.empty();

  Rx<ToothQuadrant> quadrant = ToothQuadrant.QUADRANT_I.obs;
  RxList<int> idList = RxList.empty();
  RxMap<int, Tooth?> result = RxMap.identity();
  RxBool isReverse = false.obs;

  ClassificationController();

  initCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    cameraController?.initialize().then(
      (value) {
        cameraController?.startImageStream(
          (image) => {
            cameraImage = image,
            runModel(),
          },
        );
      },
    );
  }

  runModel() async {
    var result = await Tflite.detectObjectOnFrame(
      bytesList: cameraImage?.planes.map((plane) {
        return plane.bytes;
      }).toList() ?? List.empty(),
      imageHeight: cameraImage?.height ?? 0,
      imageWidth: cameraImage?.width ?? 0,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    );

    recognitionsList.addAll(result ?? List.empty());
  }

  Future loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (recognitionsList.isEmpty) return [];

    double factorX = screen.width;
    double factorY = screen.height;

    Color colorPick = Colors.pink;

    return recognitionsList.map((result) {
      return Positioned(
        left: result["rect"]["x"] * factorX,
        top: result["rect"]["y"] * factorY,
        width: result["rect"]["w"] * factorX,
        height: result["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['detectedClass']} ${(result['confidenceInClass'] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  void onInit() async {
    await initCamera();
    await loadModel();
    super.onInit();
  }

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
    cameraController?.stopImageStream();
    Tflite.close();
    super.onClose();
  }
}
