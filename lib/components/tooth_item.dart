import 'package:flutter/material.dart';
import 'package:odontogram/models/tooth.dart';

class ToothItem extends StatelessWidget {
  final int id;
  final Tooth? data;
  final void Function() onTap;
  
  const ToothItem({
    super.key,
    required this.id,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$id'),
        IconButton(
          padding: EdgeInsets.zero,
          icon: Image.asset(data?.icon ?? "assets/tooth_empty.png"),
          onPressed: onTap,
        ),
      ],
    );
  }
}
