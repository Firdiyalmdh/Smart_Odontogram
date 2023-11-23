// tambah_pasien.dart

import 'package:flutter/material.dart';
import 'package:odontogram/components/pasien_model.dart';
import 'package:odontogram/components/pasien_provider.dart';
import 'package:provider/provider.dart';

class TambahPasien extends StatefulWidget {
  const TambahPasien({Key? key}) : super(key: key);

  @override
  _TambahPasienState createState() => _TambahPasienState();
}

class _TambahPasienState extends State<TambahPasien> {
  TextEditingController _namaController = TextEditingController();
  TextEditingController _nikController = TextEditingController();
  TextEditingController _tempatLahirController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  String _selectedDropDown = "Laki-laki";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Pasien"),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Nama Pasien"),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("NIK"),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _nikController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Jenis Kelamin"),
              ),
              SizedBox(height: 5),
              InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 2.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    isExpanded: true,
                    value: _selectedDropDown,
                    items: const [
                      DropdownMenuItem(
                        child: Text(
                          "  Laki-laki",
                          style: TextStyle(fontSize: 14),
                        ),
                        value: "Laki-laki",
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "  Perempuan",
                          style: TextStyle(fontSize: 14),
                        ),
                        value: "Perempuan",
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDropDown = value.toString();
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Tempat Lahir"),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _tempatLahirController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Tanggal Lahir"),
              ),
              SizedBox(height: 5),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () {
                  _selectedDate();
                },
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        Pasien newPasien = Pasien(
                          nama: _namaController.text,
                          nik: _nikController.text,
                          jenisKelamin: _selectedDropDown,
                          tempatLahir: _tempatLahirController.text,
                          tanggalLahir: _dateController.text,
                        );

                        PasienProvider pasienProvider =
                            Provider.of<PasienProvider>(context, listen: false);

                        pasienProvider.tambahPasien(newPasien);

                        Navigator.pop(context);
                      },
                      child: Text("Tambahkan Pasien"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectedDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
