import 'package:flutter/material.dart';
import 'package:odontogram/pages/klasifikasi.dart';

class EditOdontogram extends StatefulWidget {
  final String initialValue;

  const EditOdontogram({Key? key, required this.initialValue})
      : super(key: key);

  @override
  State<EditOdontogram> createState() => _EditOdontogramState();
}

class _EditOdontogramState extends State<EditOdontogram> {
  late String KondisiGigiDropDown;

  @override
  void initState() {
    super.initState();
    KondisiGigiDropDown = widget.initialValue;
  }

  // Fungsi untuk kembali ke halaman sebelumnya dengan mengirim pembaruan kondisi gigi
  void _goBackWithResult() {
    Navigator.pop(context, KondisiGigiDropDown);
  }

  // Fungsi untuk menutup EditOdontogram dan kembali ke halaman sebelumnya
  void _closeEditOdontogram() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Odontogram"),
        backgroundColor: Colors.blue[900],
      ),
      body: WillPopScope(
        // Akan dipanggil ketika tombol back di perangkat ditekan
        onWillPop: () async {
          // Tandai bahwa tombol back di perangkat ditekan
          _closeEditOdontogram();
          return false; // Tidak melakukan pop secara otomatis
        },
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Kondisi Gigi"),
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
                    value: KondisiGigiDropDown,
                    items: const [
                      DropdownMenuItem(
                          child: Text(
                            "  Normal",
                            style: TextStyle(fontSize: 14),
                          ),
                          value: "Normal"),
                      DropdownMenuItem(
                          child: Text(
                            "  Karies",
                            style: TextStyle(fontSize: 14),
                          ),
                          value: "Karies"),
                      DropdownMenuItem(
                          child: Text(
                            "  Tumpatan",
                            style: TextStyle(fontSize: 14),
                          ),
                          value: "Tumpatan"),
                      DropdownMenuItem(
                          child: Text(
                            "  Sisa Akar",
                            style: TextStyle(fontSize: 14),
                          ),
                          value: "Sisa Akar"),
                      DropdownMenuItem(
                          child: Text(
                            "  Impaksi",
                            style: TextStyle(fontSize: 14),
                          ),
                          value: "Impaksi"),
                    ],
                    onChanged: (value) {
                      setState(() {
                        KondisiGigiDropDown = value.toString();
                      });
                    },
                  ),
                ),
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
                        _goBackWithResult();
                        _closeEditOdontogram(); // Menutup EditOdontogram
                      },
                      child: Text("Simpan"),
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
}
