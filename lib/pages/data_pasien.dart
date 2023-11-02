import 'package:flutter/material.dart';
import 'package:odontogram/pages/tambah_pasien.dart';
import 'detail_pasien.dart';

class DataPasien extends StatefulWidget {
  const DataPasien({super.key});

  @override
  State<DataPasien> createState() => _DataPasienState();
}

class _DataPasienState extends State<DataPasien> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Pasien"),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      hintText: "search"),
                ),
                Column(
                  children: [
                    CardPasien(),
                    CardPasien(),
                    CardPasien(),
                    CardPasien(),
                    CardPasien(),
                    CardPasien(),
                    CardPasien(),
                  ],
                ),
              ],
            )),
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

class CardPasien extends StatelessWidget {
  const CardPasien({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> namaPasien = <String>['Sarah', 'Diva', 'Anto', 'Firdi'];
    final List<String> jenisKelamin = <String>[
      "Perempuan",
      "Perempuan",
      "Laki-laki",
      "Perempuan"
    ];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ListTile(
            title: Text("Nama pasien"),
            subtitle: Text("Jenis kelamin"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetailPasien()));
                },
                child: const Text("Detail"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
