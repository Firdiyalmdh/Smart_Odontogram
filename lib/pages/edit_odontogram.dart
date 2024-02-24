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
      body: Container()
    );
  }
}
