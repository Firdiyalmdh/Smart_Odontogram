import 'package:flutter/material.dart';

class Klasifikasi extends StatefulWidget {
  const Klasifikasi({super.key});

  @override
  State<Klasifikasi> createState() => _KlasifikasiState();
}

class _KlasifikasiState extends State<Klasifikasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Klasifikasi"),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(),
    );
  }
}
