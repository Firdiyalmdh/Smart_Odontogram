import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:odontogram/components/list_gigi/gigi11.dart';
import 'package:odontogram/components/list_gigi/gigi12.dart';
import 'package:odontogram/components/list_gigi/gigi13.dart';
import 'package:odontogram/components/list_gigi/gigi14.dart';
import 'package:odontogram/components/list_gigi/gigi15.dart';
import 'package:odontogram/components/list_gigi/gigi16.dart';
import 'package:odontogram/components/list_gigi/gigi17.dart';
import 'package:odontogram/components/list_gigi/gigi18.dart';
import 'package:odontogram/components/list_gigi/gigi21.dart';
import 'package:odontogram/components/list_gigi/gigi22.dart';
import 'package:odontogram/components/list_gigi/gigi23.dart';
import 'package:odontogram/components/list_gigi/gigi24.dart';
import 'package:odontogram/components/list_gigi/gigi25.dart';
import 'package:odontogram/components/list_gigi/gigi26.dart';
import 'package:odontogram/components/list_gigi/gigi27.dart';
import 'package:odontogram/components/list_gigi/gigi28.dart';
import 'package:odontogram/components/list_gigi/gigi31.dart';
import 'package:odontogram/components/list_gigi/gigi32.dart';
import 'package:odontogram/components/list_gigi/gigi33.dart';
import 'package:odontogram/components/list_gigi/gigi34.dart';
import 'package:odontogram/components/list_gigi/gigi35.dart';
import 'package:odontogram/components/list_gigi/gigi36.dart';
import 'package:odontogram/components/list_gigi/gigi37.dart';
import 'package:odontogram/components/list_gigi/gigi38.dart';
import 'package:odontogram/components/list_gigi/gigi41.dart';
import 'package:odontogram/components/list_gigi/gigi42.dart';
import 'package:odontogram/components/list_gigi/gigi43.dart';
import 'package:odontogram/components/list_gigi/gigi44.dart';
import 'package:odontogram/components/list_gigi/gigi45.dart';
import 'package:odontogram/components/list_gigi/gigi46.dart';
import 'package:odontogram/components/list_gigi/gigi47.dart';
import 'package:odontogram/components/list_gigi/gigi48.dart';

class Odontogram extends StatelessWidget {
  const Odontogram({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
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
            Premolar1_KiriAtas(number: 24),
            Premolar2_KiriAtas(number: 25),
            Molar1_KiriAtas(number: 26),
            Molar2_KiriAtas(number: 27),
            Molar3_KiriAtas(number: 28),
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
            //kanan bawah
            Molar3_KananBawah(number: 48),
            Molar2_KananBawah(number: 47),
            Molar1_KananBawah(number: 46),
            Premolar2_KananBawah(number: 45),
            Premolar1_KananBawah(number: 44),
            Caninus_KananBawah(number: 43),
            Insisiv2_KananBawah(number: 42),
            Insisiv1_KananBawah(number: 41),

            //kiri bawah
            Insisiv1_KiriBawah(number: 31),
            Insisiv2_KiriBawah(number: 32),
            Caninus_KiriBawah(number: 33),
            Premolar1_KiriBawah(number: 34),
            Premolar2_KiriBawah(number: 35),
            Molar1_KiriBawah(number: 36),
            Molar2_KiriBawah(number: 37),
            Molar3_KiriBawah(number: 38),
          ],
        ),
      ],
    );
  }
}

// Gigi nomor 18-11

class GigiNormal extends StatelessWidget {
  final int number;

  const GigiNormal({
    Key? key,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$number'),
        IconButton(
          padding: EdgeInsets.zero,
          icon: Image.asset('assets/normal.png'),
          onPressed: () {},
        ),
      ],
    );
  }
}

class GigiNormal1 extends StatelessWidget {
  final int number;

  const GigiNormal1({
    Key? key,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$number'),
        IconButton(
          padding: EdgeInsets.zero,
          icon: Image.asset('assets/normal1.png'),
          onPressed: () {},
        ),
      ],
    );
  }
}
