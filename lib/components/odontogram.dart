import 'package:flutter/material.dart';
import 'package:odontogram/components/tooth_item.dart';
import 'package:odontogram/models/tooth.dart';

class Odontogram extends StatelessWidget {
  final List<Tooth> toothList;
  final void Function(Tooth) onTap;
  const Odontogram({
    super.key, 
    required this.toothList,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (toothList.isEmpty) {
      return const Text("Belum ada data Odontogram");
    }

    List<Widget> firstRow = ToothQuadrant.QUADRANT_I.idList.map((id) {
      final index = toothList.indexWhere((e) => int.parse(e.id) == id);
      return ToothItem(id: id, data: toothList[index], onTap: () { onTap(toothList[index]); });
    }).toList();

    firstRow.addAll(ToothQuadrant.QUADRANT_II.idList.map((id) {
      final index = toothList.indexWhere((e) => int.parse(e.id) == id);
      return ToothItem(id: id, data: toothList[index], onTap: () { onTap(toothList[index]); });
    }).toList());

    List<Widget> secondRow = ToothQuadrant.QUADRANT_III.idList.map((id) {
      final index = toothList.indexWhere((e) => int.parse(e.id) == id);
      return ToothItem(id: id, data: toothList[index], onTap: () { onTap(toothList[index]); });
    }).toList();

    secondRow.addAll(ToothQuadrant.QUADRANT_IV.idList.map((id) {
      final index = toothList.indexWhere((e) => int.parse(e.id) == id);
      return ToothItem(id: id, data: toothList[index], onTap: () { onTap(toothList[index]); });
    }).toList());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(children: firstRow),
        const SizedBox(height: 20),
        const Row(
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
        const SizedBox(height: 20),
        const Row(
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
        const SizedBox(height: 20),
        Row(children: secondRow),
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
