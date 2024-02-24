import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/modules/medical_exam/index.dart';

class NativeClassificationScreen extends GetView<NativeClassificationController> {
  const NativeClassificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Center(
          child: (controller.result.value == "") ? const Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text("Menyimpan data ke Firebase...")
            ]
          ) : Text(controller.result.value),
        ),
      ),
    );
  }
}