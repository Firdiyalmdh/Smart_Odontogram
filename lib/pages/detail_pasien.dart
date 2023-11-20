import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:odontogram/pages/edit_odontogram.dart';

class DetailPasien extends StatefulWidget {
  const DetailPasien({super.key});

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
          //margin: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal(),
                      ],
                    ),
                    Row(
                      children: [
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal(),
                        GigiNormal(),
                      ],
                    ),
                    Row(
                      children: [
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal(),
                        GigiNormal(),
                      ],
                    ),
                    Row(
                      children: [
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal1(),
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal(),
                        GigiNormal(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //Image(image: AssetImage('assets/odontogram.jpeg')),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditOdontogram()));
                    },
                    child: Text("Edit Odontogram"),
                  ),
                )),
              ],
            )
          ]),
        ));
  }
}

class GigiNormal extends StatelessWidget {
  const GigiNormal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Image.asset('assets/normal.png'), onPressed: () {});
  }
}

class GigiNormal1 extends StatelessWidget {
  const GigiNormal1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/normal1.png'),
      onPressed: () {},
    );
  }
}

class CardDetailPasien extends StatelessWidget {
  const CardDetailPasien({
    super.key,
  });

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
            )
          ]),
      // child: ListView.builder(
      //   itemCount: listsData.length,
      //   itemBuilder: (context, index) {
      //     red
      //   },
      // )
      // child: ListTile(
      //   title: Text("Nama pasien"),
      //   subtitle: Column(
      //     children: [
      //       Text("Jenis kelamin"),
      //       Text("NIK"),
      //       Text("Tempat tanggal lahir"),
      //       Text("Pemeriksaan terakhir"),
      //     ],
      //   ),
      // ),
    );
  }
}
