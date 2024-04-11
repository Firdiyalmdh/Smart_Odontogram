import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/components/medical_exam_button.dart';
import 'package:odontogram/models/tooth.dart';
import 'package:odontogram/modules/medical_exam/index.dart';

class MedicalExamScreen extends GetView<MedicalExamController> {
  const MedicalExamScreen({super.key});

  void coba() {
    controller.isLoading;
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Tanggal Pemeriksaan:"),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: controller.medExamDateController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                  prefixIcon: Icon(Icons.calendar_today)),
              readOnly: true,
              onTap: controller.selectDate,
            ),
            const SizedBox(height: 15),
            Obx(() => GridView.count(
              primary: false,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: [
                MedicalExamButton(
                  labelPosition: const Rect.fromLTRB(16, 16, 0, 0),
                  labelText: "Kuad\nran I",
                  labelAlign: TextAlign.left,
                  iconPosition: const Rect.fromLTRB(0, 0, 6, 6),
                  iconAsset: ToothQuadrant.QUADRANT_I.icon,
                  checkPosition: const Rect.fromLTRB(16, 0, 0, 16),
                  isFilled: controller.quadrantMap[ToothQuadrant.QUADRANT_I] ?? false,
                  onTap: () {
                    controller.navigateToClassification(ToothQuadrant.QUADRANT_I);
                  },
                ),
                MedicalExamButton(
                  labelPosition: const Rect.fromLTRB(0, 16, 16, 0),
                  labelText: "Kuad\nran II",
                  labelAlign: TextAlign.right,
                  iconPosition: const Rect.fromLTRB(6, 0, 0, 6),
                  iconAsset: ToothQuadrant.QUADRANT_II.icon,
                  checkPosition: const Rect.fromLTRB(0, 0, 16, 16),
                  isFilled: controller.quadrantMap[ToothQuadrant.QUADRANT_II] ?? false,
                  onTap: () {
                    controller.navigateToClassification(ToothQuadrant.QUADRANT_II);
                  },
                ),
                MedicalExamButton(
                  labelPosition: const Rect.fromLTRB(16, 0, 0, 16),
                  labelText: "Kuad\nran III",
                  labelAlign: TextAlign.left,
                  iconPosition: const Rect.fromLTRB(0, 6, 6, 0),
                  iconAsset: ToothQuadrant.QUADRANT_III.icon,
                  checkPosition: const Rect.fromLTRB(16, 16, 0, 0),
                  isFilled: controller.quadrantMap[ToothQuadrant.QUADRANT_III] ?? false,
                  onTap: () {
                    controller.navigateToClassification(ToothQuadrant.QUADRANT_III);
                  },
                ),
                MedicalExamButton(
                  labelPosition: const Rect.fromLTRB(0, 0, 16, 12),
                  labelText: "Kuad\nran IV",
                  labelAlign: TextAlign.right,
                  iconPosition: const Rect.fromLTRB(6, 6, 0, 0),
                  iconAsset: ToothQuadrant.QUADRANT_IV.icon,
                  checkPosition: const Rect.fromLTRB(0, 16, 16, 0),
                  isFilled: controller.quadrantMap[ToothQuadrant.QUADRANT_IV] ?? false,
                  onTap: () {
                    controller.navigateToClassification(ToothQuadrant.QUADRANT_IV);
                  },
                ),
              ],
            )),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: controller.isButtonDisabled() ? null : () => controller.saveMedicalRecord(),
                child: (controller.isLoading.value)
                    ? Transform.scale(
                        scale: .75,
                        child: const CircularProgressIndicator(
                            color: Colors.white),
                      )
                    : const Text(
                        "Simpan Pemeriksaan",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
