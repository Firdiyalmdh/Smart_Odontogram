import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/modules/medical_exam/index.dart';

class NativeClassificationScreen extends GetView<NativeClassificationController> {
  const NativeClassificationScreen({Key? key}) : super(key: key);

  Widget child(String value) {
    if (value == "") {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text("Menyiapkan Kamera...")
        ]
      );
    } else {
      return Text(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Center(
          child: child(controller.result.value),
        ),
      ),
    );
  }
}