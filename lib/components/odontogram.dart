import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
