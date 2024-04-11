import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/modules/patient/index.dart';

class AddPatientScreen extends GetView<AddPatientController> {
  const AddPatientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Pasien",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Nama Pasien"),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("NIK"),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: controller.nikController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Jenis Kelamin"),
              ),
              const SizedBox(height: 5),
              InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 10,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: Obx(
                    () => DropdownButton(
                      isExpanded: true,
                      value: controller.selectedGender.value,
                      items: const [
                        DropdownMenuItem(
                          value: "Laki-laki",
                          child: Text(
                            "Laki-laki",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Perempuan",
                          child: Text(
                            "Perempuan",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        controller.selectedGender.value = value.toString();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Tempat Lahir"),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: controller.birthPlaceController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Tanggal Lahir"),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: controller.birthDateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: const EdgeInsets.all(8),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: controller.selectDate,
              ),
              const SizedBox(height: 15),
              Obx(
                () => SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      controller.addPatient();
                    },
                    child: (controller.isLoading.value)
                        ? Transform.scale(
                            scale: .75,
                            child: const CircularProgressIndicator(
                                color: Colors.white))
                        : const Text("Tambahkan Pasien"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
