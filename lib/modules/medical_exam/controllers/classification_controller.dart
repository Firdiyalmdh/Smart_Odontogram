import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odontogram/models/tooth.dart';
import 'package:image/image.dart' as img;
import 'package:odontogram/service/firebase/tooth_service.dart';
import 'package:odontogram/utils/image_utils.dart';

class ClassificationController extends GetxController {
  Rx<ToothQuadrant> quadrant = ToothQuadrant.QUADRANT_I.obs;
  RxList<int> idList = RxList.empty();
  RxMap<int, Tooth?> result = RxMap.identity();
  RxBool isReverse = false.obs;
  final RxString patientId = "".obs;

  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  final RxBool _isInitialized = false.obs;
  CameraImage? _cameraImage;
  final Rx<Uint8List> _image = Rx(Uint8List(0));

  CameraController get cameraController => _cameraController;
  bool get isInitialized => _isInitialized.value;
  Uint8List get image => _image.value;

  final ToothService toothService;

  ClassificationController({required this.toothService});

  @override
  void dispose() {
    _isInitialized.value = false;
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void onReady() {
    super.onReady();
    final arguments = Get.arguments as Map<String, dynamic>;
    patientId.value = arguments["patientId"] as String;
    quadrant.value = arguments["quadrant"] as ToothQuadrant;

    idList.clear();
    idList.addAll(quadrant.value.idList);
    isReverse.value = quadrant.value.isReverse;
    for (var id in idList) {
      result[id] = null;
    }
  }

  @override
  void onInit() {
    initCamera();
    super.onInit();
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.bgra8888);
    _cameraController.initialize().then((value) {
      _isInitialized.value = true;
      _cameraController.startImageStream((image) => _cameraImage = image);

      _isInitialized.refresh();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  void capture() async {
    if (_cameraImage != null) {
      img.Image? image = await convertCameraImageToImage(_cameraImage!);
      Uint8List list = Uint8List.fromList(img.encodeJpg(image!));
      _image.value = list;
    }
  }

  Future pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnImage == null) return;
    _image.value = await returnImage.readAsBytes();
  }

  void editResult(int id, Tooth data) {
    result[id] = data;
  }

  void resetImage() {
    _image.value = Uint8List(0);
  }

  Future<void> save() async {
    print("mulai");
    List<Future<void>> updateJob = [];
    result.values.forEach((tooth) {
      if (tooth != null) {
        updateJob.add(toothService.editMedicalRecord(tooth, patientId.value));
      }
    });
    await Future.wait(updateJob);
    print("selesai");
    Get.back();
  }
}
