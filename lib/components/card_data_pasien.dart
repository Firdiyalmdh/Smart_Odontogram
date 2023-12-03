import 'package:flutter/material.dart';

class CardDataPasien extends StatelessWidget {
  final String name;
  final void Function() onDelete;
  final void Function() onTap;
  const CardDataPasien(
      {super.key,
      required this.name,
      required this.onDelete,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/card_background.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
