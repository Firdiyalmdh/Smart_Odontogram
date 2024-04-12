import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odontogram/components/home_app_bar.dart';
import 'package:odontogram/components/card_data_pasien.dart';
import 'package:odontogram/components/search_form.dart';
import 'package:odontogram/modules/home/index.dart';
import 'package:odontogram/routes/app_routes.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ever(controller.patients, (patients) => controller.updateFilteredPatient());
    controller.searchController.addListener(() => controller.updateFilteredPatient());

    return Scaffold(
      appBar: HomeAppBar(
        user: controller.user,
        onLogoutClick: () {
          controller.logout();
        },
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 390,
              height: 175,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/banner.png'),
                fit: BoxFit.cover,
              )),
            ),
            const SizedBox(height: 15),
            SearchForm(searchController: controller.searchController),
            const SizedBox(height: 15),
            Text(
              "Data Pasien",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.filteredPatients.length,
                  itemBuilder: (context, index) {
                    final data = controller.filteredPatients[index];
                    return CardDataPasien(
                      name: data.name,
                      onDelete: () => controller.deletePatient(data.id),
                      onTap: () => Get.toNamed(
                        AppRoutes.DETAIL_PATIENT,
                        arguments: data,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () {
          Get.toNamed(AppRoutes.ADD_PATIENT);
        },
      ),
    );
  }
}
