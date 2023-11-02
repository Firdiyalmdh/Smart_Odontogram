import 'package:flutter/material.dart';

class EditOdontogram extends StatefulWidget {
  const EditOdontogram({super.key});

  @override
  State<EditOdontogram> createState() => _EditOdontogramState();
}

class _EditOdontogramState extends State<EditOdontogram> {
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Odontogram"),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Tanggal Pemeriksaan:"),
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
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                      onPressed: () {},
                      child: Text("Mulai Klasifikasi")),
                ),
              ],
            )
          ],
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
