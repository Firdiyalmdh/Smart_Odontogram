import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/components/tooth_item.dart';
import 'package:odontogram/models/recognition.dart';
import 'package:odontogram/models/tooth.dart';
import 'package:odontogram/modules/medical_exam/controllers/classification_controller.dart';

class ClassificationScreen extends GetView<ClassificationController> {
  const ClassificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pemeriksaan Baru",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue[900],
        actions: [
          TextButton(
            onPressed: () {
              controller.save();
            },
            child: const Text(
              "Simpan",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          CameraViewerSection(),
          OdontogramListSection(),
          ActionSection()
        ],
      ),
    );
  }

  // void _restartImage() {
  //   setState(() {
  //     _selectedImage = null;
  //     _isCardVisible = false;
  //   });
  // }
}

class CameraViewerSection extends StatelessWidget {
  final ClassificationController controller = Get.find();
  CameraViewerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ClassificationController>(
      builder: (controller) {
        if (!controller.isInitialized) {
          return Container();
        } else if (controller.image.isNotEmpty) {
          return SizedBox(
            height: Get.height - 300,
            width: Get.width,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(controller.image!),
                ),
              ),
            ),
          );
        }
        return SizedBox(
          height: Get.height - 300,
          width: Get.width,
          child: CameraPreview(controller.cameraController),
        );
      },
    );
  }
}

class ActionSection extends StatelessWidget {
  final ClassificationController controller = Get.find();
  ActionSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              controller.quadrant.value.icon,
              width: 50,
              height: 50,
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => controller.capture(),
          child: Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 5)),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.camera,
                  size: 60,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: (controller.image.isNotEmpty)
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    iconSize: 32,
                    style: IconButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      controller.resetImage();
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.drive_folder_upload),
                    iconSize: 32,
                    style:
                        IconButton.styleFrom(backgroundColor: Colors.white70),
                    onPressed: () {
                      controller.pickImageFromGallery();
                    },
                  ),
          ),
        )
      ],
    );
  }
}

class OdontogramListSection extends StatelessWidget {
  final ClassificationController controller = Get.find();
  OdontogramListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(
          () => Row(
            children: controller.result.entries
                .map(
                  (entry) => ToothItem(
                    id: entry.key,
                    data: entry.value,
                    onTap: () {
                      Get.dialog(
                        ConditionModal(
                          selectedValue: entry.value?.condition.obs ??
                              ToothCondition.NORMAL.obs,
                          onClose: (selectedCondition) {
                            controller.editResult(
                                entry.key,
                                Tooth(
                                    id: entry.key.toString(),
                                    type: entry.key.toothType,
                                    condition: selectedCondition));
                            Get.back();
                          },
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class ConditionModal extends StatelessWidget {
  final ClassificationController controller = Get.find();
  final Rx<ToothCondition> selectedValue;
  final void Function(ToothCondition) onClose;

  ConditionModal({
    super.key,
    required this.selectedValue,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: PopScope(
        child: Container(
          height: 200,
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Kondisi Gigi"),
              ),
              const SizedBox(height: 5),
              InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                child: Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 10),
                      value: selectedValue.value,
                      items: ToothCondition.values
                          .map(
                            (condition) => DropdownMenuItem(
                              value: condition,
                              child: Text(
                                condition.name,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        selectedValue.value = value!;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () => onClose(selectedValue.value),
                  child: const Text("Simpan"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
