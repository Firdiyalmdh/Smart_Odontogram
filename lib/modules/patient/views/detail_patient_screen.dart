import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/components/odontogram.dart';
import 'package:odontogram/models/patient.dart';
import 'package:odontogram/modules/patient/controllers/detail_patient_controller.dart';
import 'package:odontogram/routes/app_routes.dart';

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
      body: Obx(
        () => GestureDetector(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              CardDetailPasien(patient: controller.patient.value),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Odontogram(toothList: controller.toothList.value),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
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
                      "Tempat tanggal lahir: ${patient!.birthPlace}, ${patient!.birthDate}"),
                  Text(
                      "Pemeriksaan terakhir: ${patient!.lastCheckupDate ?? 'Belum ada pemeriksaan'}"),
                ],
              ),
            )
          : const SizedBox(),
    );
  }
}
