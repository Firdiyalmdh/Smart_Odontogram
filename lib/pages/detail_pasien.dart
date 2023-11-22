import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:odontogram/components/odontogram.dart';
import 'package:odontogram/components/odontogram/gigi11.dart';
import 'package:odontogram/components/odontogram/gigi12.dart';
import 'package:odontogram/components/odontogram/gigi13.dart';
import 'package:odontogram/components/odontogram/gigi14.dart';
import 'package:odontogram/components/odontogram/gigi15.dart';
import 'package:odontogram/components/odontogram/gigi16.dart';
import 'package:odontogram/components/odontogram/gigi18.dart';
import 'package:odontogram/components/odontogram/gigi17.dart';
import 'package:odontogram/components/odontogram/gigi21.dart';
import 'package:odontogram/components/odontogram/gigi22.dart';
import 'package:odontogram/components/odontogram/gigi23.dart';
import 'package:odontogram/pages/pemeriksaan_baru.dart';

class DetailPasien extends StatefulWidget {
  const DetailPasien({Key? key}) : super(key: key);

  @override
  State<DetailPasien> createState() => _DetailPasienState();
}

class _DetailPasienState extends State<DetailPasien> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Pasien"),
        backgroundColor: Colors.blue[900],
      ),
      body: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            CardDetailPasien(),
            SizedBox(height: 20),
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        //gigi kanan atas 18-11
                        Molar3_KananAtas(number: 18),
                        Molar2_KananAtas(number: 17),
                        Molar1_KananAtas(number: 16),
                        Premolar2_KananAtas(number: 15),
                        Premolar1_KananAtas(number: 14),
                        Caninus_KananAtas(number: 13),
                        Insisiv2_KananAtas(number: 12),
                        Insisiv1_KananAtas(number: 11),

                        //gigi kiri atas 21-28
                        Insisiv1_KiriAtas(number: 21),
                        Insisiv2_KiriAtas(number: 22),
                        Caninus_KiriAtas(number: 23),
                        GigiNormal(number: 24),
                        GigiNormal(number: 25),
                        GigiNormal(number: 26),
                        GigiNormal(number: 27),
                        GigiNormal(number: 28),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        GigiNormal(number: 55),
                        GigiNormal(number: 54),
                        GigiNormal1(number: 53),
                        GigiNormal1(number: 52),
                        GigiNormal1(number: 51),
                        GigiNormal1(number: 61),
                        GigiNormal1(number: 62),
                        GigiNormal1(number: 63),
                        GigiNormal(number: 64),
                        GigiNormal(number: 65),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        GigiNormal(number: 85),
                        GigiNormal(number: 84),
                        GigiNormal1(number: 83),
                        GigiNormal1(number: 82),
                        GigiNormal1(number: 81),
                        GigiNormal1(number: 71),
                        GigiNormal1(number: 72),
                        GigiNormal1(number: 73),
                        GigiNormal(number: 74),
                        GigiNormal(number: 74),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        GigiNormal(number: 48),
                        GigiNormal(number: 47),
                        GigiNormal(number: 46),
                        GigiNormal(number: 45),
                        GigiNormal(number: 44),
                        GigiNormal1(number: 43),
                        GigiNormal1(number: 42),
                        GigiNormal1(number: 41),
                        GigiNormal1(number: 31),
                        GigiNormal1(number: 32),
                        GigiNormal1(number: 33),
                        GigiNormal(number: 34),
                        GigiNormal(number: 35),
                        GigiNormal(number: 36),
                        GigiNormal(number: 37),
                        GigiNormal(number: 38),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
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
                            builder: (context) => PemeriksaanBaru(),
                          ),
                        );
                      },
                      child: Text("Buat Pemeriksaan"),
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
  const CardDetailPasien({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<List<String>> listsData = [
      ['Firdiyanti'],
      ['Perempuan'],
      ['25262744003020001'],
      ['Mojokerto, 4 Maret 2023'],
      ['10 November 2023'],
    ];
    return Container(
      margin: const EdgeInsets.all(15),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3,
            offset: Offset(0, 0.5),
          ),
        ],
      ),
      child: ListTile(
        title: Text("Nama pasien: ${listsData[0][0]}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Jenis kelamin: ${listsData[1][0]}"),
            Text("NIK: ${listsData[2][0]}"),
            Text("Tempat tanggal lahir: ${listsData[3][0]}"),
            Text("Pemeriksaan terakhir: ${listsData[4][0]}"),
          ],
        ),
      ),
    );
  }
}
