import 'package:flutter/material.dart';
import 'package:odontogram/components/appbar.dart';
import 'package:odontogram/components/card_data_pasien.dart';
import 'package:odontogram/components/search_form.dart';
import 'tambah_pasien.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Drg. Nama Lengkap Dokter",
              style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 390,
              height: 175,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/banner.png'),
                fit: BoxFit.cover,
              )),
            ),
            SizedBox(
              height: 15,
            ),
            SearchForm(searchController: _searchController),
            SizedBox(height: 15),
            Text(
              "Data Pasien",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            CardDataPasien(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahPasien()),
          );
        },
      ),
    );
  }
}
