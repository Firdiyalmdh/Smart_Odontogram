// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/components/edit_tooth_dialog.dart';
import 'package:odontogram/components/odontogram.dart';
import 'package:odontogram/models/patient.dart';
import 'package:odontogram/modules/patient/controllers/detail_patient_controller.dart';
import 'package:odontogram/routes/app_routes.dart';
import 'package:odontogram/utils/utils.dart';

class DetailPatientScreen extends GetView<DetailPatientController> {
  const DetailPatientScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Pasien",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            CardDetailPasien(patient: controller.patient.value),
            const SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Odontogram(
                    toothList: controller.toothList.value,
                    onTap: (tooth) {
                      controller.toothCondition.value = tooth.condition.name;
                      Get.dialog(
                        Obx(() => EditToothDialog(
                            tooth: tooth, 
                            selectedCondition: controller.toothCondition.value, 
                            isLoading: controller.isLoading.value, 
                            onSelectCondition: (condition) { controller.toothCondition.value = condition; }, 
                            onSave: () { controller.editToothCondition(tooth.id); }
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.NEW_MEDICAL_EXAM,
                            arguments: controller.patient.value?.id ?? "");
                      },
                      child: const Text("Buat Pemeriksaan"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardDetailPasien extends StatelessWidget {
  final Patient? patient;

  const CardDetailPasien({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3,
            offset: Offset(0, 0.5),
          ),
        ],
      ),
      child: (patient != null)
          ? ListTile(
              title: Text(patient!.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Jenis kelamin: ${patient!.gender}"),
                  Text("NIK: ${patient!.nik}"),
                  Text(
                      "TTL: ${patient!.birthPlace}, ${formatDate(inputStringDate: patient!.birthDate)}"),
                  Text(
                      "Pemeriksaan terakhir: ${patient!.lastCheckupDate != null ? formatDate(inputStringDate: patient!.lastCheckupDate!) : 'Belum ada pemeriksaan'}"),
                ],
              ),
            )
          : const SizedBox(),
    );
  }
}
