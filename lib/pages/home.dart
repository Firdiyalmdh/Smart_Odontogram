import 'package:flutter/material.dart';
import 'package:odontogram/pages/detail_pasien.dart';
import 'package:odontogram/pages/tambah_pasien.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _DataPasienState();
}

class _DataPasienState extends State<Home> {
  List<String> NamaPasien = [
    "Alim Shafiyyur Rahman",
    "Arroyan Dylan Alfarizqi",
    "Bari Abul Jalil",
    "Bilal Hafizh Athaillah",
    "Chairil Mihran Ghazzal",
    "Kamil Nufail Zafran",
    "Muhammad Zaky Fawwaz",
    "Siti Amina",
    "Muhammad Abrisam Izadin",
    "Muhammad Dzakiandra Hasan",
    "Muhammad Fattah Ibrahim",
    "Amina Salwa",
    "Dina Yasirah",
    "Hana Azzahra",
    "Laila Amalia"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Pasien"),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    hintText: "search"),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (BuildContext, index) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: InkWell(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/card_background.png"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                NamaPasien[index],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPasien()));
                        },
                      ));
                },
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TambahPasien()));
        },
      ),
    );
  }
}
