import 'package:flutter/material.dart';

class TambahPasien extends StatefulWidget {
  const TambahPasien({super.key});

  @override
  State<TambahPasien> createState() => _TambahPasienState();
}

class _TambahPasienState extends State<TambahPasien> {
  String SelectedDropDown = "Laki-laki";

  TextEditingController _dateController = TextEditingController();

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
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Nama Pasien"),
            ),
            SizedBox(height: 5),
            TextField(
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
                  value: SelectedDropDown,
                  items: const [
                    DropdownMenuItem(
                        child: Text(
                          "  Laki-laki",
                          style: TextStyle(fontSize: 14),
                        ),
                        value: "Laki-laki"),
                    DropdownMenuItem(
                        child: Text(
                          "  Perempuan",
                          style: TextStyle(fontSize: 14),
                        ),
                        value: "Perempuan"),
                  ],
                  onChanged: (value) {
                    setState(() {
                      SelectedDropDown = value.toString();
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
                  prefixIcon: Icon(Icons.calendar_today)),
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
                          borderRadius: BorderRadius.circular(30.0))),
                  onPressed: () {},
                  child: Text("Tambahkan Pasien"),
                )),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Future<void> _selectedDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now().add(Duration(days: 30)));

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
