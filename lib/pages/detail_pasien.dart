import 'package:flutter/material.dart';
import 'package:odontogram/components/odontogram.dart';
import 'package:odontogram/components/pasien_model.dart';
import 'package:odontogram/pages/pemeriksaan_baru.dart';

class DetailPasien extends StatefulWidget {
  final Pasien pasien;

  const DetailPasien({Key? key, required this.pasien}) : super(key: key);

  @override
  State<DetailPasien> createState() => _DetailPasienState();
}

class _DetailPasienState extends State<DetailPasien> {
  late Pasien _pasien;

  @override
  void initState() {
    super.initState();
    _pasien = widget.pasien;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pasien"),
        backgroundColor: Colors.blue[900],
      ),
      body: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            CardDetailPasien(pasien: _pasien),
            const SizedBox(height: 20),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Odontogram(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PemeriksaanBaru(),
                          ),
                        );
                      },
                      child: const Text("Buat Pemeriksaan"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardDetailPasien extends StatelessWidget {
  final Pasien pasien;

  const CardDetailPasien({Key? key, required this.pasien}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3,
            offset: Offset(0, 0.5),
          ),
        ],
      ),
      child: ListTile(
        title: Text(pasien.nama),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Jenis kelamin: ${pasien.jenisKelamin}"),
            Text("NIK: ${pasien.nik}"),
            Text(
                "Tempat tanggal lahir: ${pasien.tempatLahir}, ${pasien.tanggalLahir}"),
            Text(
                "Pemeriksaan terakhir: ${pasien.tanggalPemeriksaan ?? 'Belum ada pemeriksaan'}"),
          ],
        ),
      ),
    );
  }
}
