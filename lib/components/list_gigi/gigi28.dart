import 'package:flutter/material.dart';
import 'package:odontogram/pages/edit_odontogram.dart';

class Molar3_KiriAtas extends StatefulWidget {
  final int number;

  const Molar3_KiriAtas({
    Key? key,
    required this.number,
  }) : super(key: key);

  @override
  _Molar3_KiriAtas createState() => _Molar3_KiriAtas();
}

class _Molar3_KiriAtas extends State<Molar3_KiriAtas> {
  List<String> JenisGigi = ["Molar3"];
  List<String> KondisiGigi = ["Normal"];

  String getIconPath() {
    switch (KondisiGigi[0]) {
      case "Normal":
        return 'assets/normal.png';
      case "Karies":
        return 'assets/karies.png';
      case "Tumpatan":
        return 'assets/tumpatan.png';
      case "Sisa Akar":
        return 'assets/sisa_akar.png';
      case "Impaksi":
        return 'assets/impaksi.png';
      default:
        return 'assets/normal.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${widget.number}'),
        IconButton(
          padding: EdgeInsets.zero,
          icon: Image.asset(getIconPath()),
          onPressed: () {
            _showDialog();
          },
        ),
      ],
    );
  }

  // Fungsi callback untuk menerima pembaruan kondisi gigi
  void updateKondisiGigi(String newKondisi) {
    setState(() {
      KondisiGigi[0] = newKondisi;
    });
  }

  // Fungsi untuk menampilkan AlertDialog
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(JenisGigi[0]),
          content: Text(KondisiGigi[0]),
          actions: [
            TextButton(
              child: Text("Edit"),
              onPressed: () {
                _navigateToEditOdontogram();
              },
            )
          ],
        );
      },
    );
  }

  // Fungsi untuk navigasi ke halaman EditOdontogram
  void _navigateToEditOdontogram() async {
    final newKondisi = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOdontogram(initialValue: KondisiGigi[0]),
      ),
    );

    // Panggil fungsi callback jika ada pembaruan kondisi gigi
    if (newKondisi != null) {
      updateKondisiGigi(newKondisi);
    }
  }
}
