import 'package:flutter/material.dart';

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
        title: const Text("Edit Odontogram"),
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Kondisi Gigi"),
              ),
              const SizedBox(height: 5),
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
                          value: "Normal",
                          child: Text(
                            "  Normal",
                            style: TextStyle(fontSize: 14),
                          )),
                      DropdownMenuItem(
                          value: "Karies",
                          child: Text(
                            "  Karies",
                            style: TextStyle(fontSize: 14),
                          )),
                      DropdownMenuItem(
                          value: "Tumpatan",
                          child: Text(
                            "  Tumpatan",
                            style: TextStyle(fontSize: 14),
                          )),
                      DropdownMenuItem(
                          value: "Sisa Akar",
                          child: Text(
                            "  Sisa Akar",
                            style: TextStyle(fontSize: 14),
                          )),
                      DropdownMenuItem(
                          value: "Impaksi",
                          child: Text(
                            "  Impaksi",
                            style: TextStyle(fontSize: 14),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        KondisiGigiDropDown = value.toString();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
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
                        _closeEditOdontogram();
                      },
                      child: const Text("Simpan"),
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
