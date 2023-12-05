import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/models/tooth.dart';
import 'package:odontogram/modules/medical_exam/controllers/classification_controller.dart';

class ClassificationScreen extends GetView<ClassificationController> {
  const ClassificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    list.add(
      Positioned(
        top: 0.0,
        left: 0.0,
        width: Get.width,
        height: Get.height - 100,
        child: Container(
          height: Get.height - 100,
          child: (controller.cameraController == null || controller.cameraController?.value.isInitialized == false)
              ? new Container()
              : AspectRatio(
                  aspectRatio: controller.cameraController!.value.aspectRatio,
                  child: CameraPreview(controller.cameraController!),
                ),
        ),
      ),
    );

    list.addAll(controller.displayBoxesAroundRecognizedObjects(Get.size));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        title: Text(
          "Pemeriksaan ${controller.quadrant.value.title}",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue[900],
      ),
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(top: 50),
          color: Colors.black,
          child: Stack(
            children: list,
          ),
        ),
      ),
    );
  }

  // Future _pickImageFromGallery() async {
  //   final returnImage =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (returnImage == null) return;
  //   setState(() {
  //     _selectedImage = File(returnImage.path);
  //   });
  // }

  // void _restartImage() {
  //   setState(() {
  //     _selectedImage = null;
  //     _isCardVisible = false;
  //   });
  // }
}

class CardKlasifikasi extends StatelessWidget {
  const CardKlasifikasi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Jenis Gigi:",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                "Kondisi Gigi:",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          )),
    );
  }
}
