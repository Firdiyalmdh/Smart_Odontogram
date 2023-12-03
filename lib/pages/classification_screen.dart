import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({Key? key}) : super(key: key);

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  File? _selectedImage;
  bool _isCardVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Klasifikasi"),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Column(
          children: [
            if (_selectedImage == null)
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 400,
                    height: 100,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/no_image.png'),
                      fit: BoxFit.fitHeight,
                    )),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                    child: Column(children: [
                      Text(
                        "Unggah Gambar",
                      ),
                    ]),
                    onPressed: () {
                      _pickImageFromGallery();
                    },
                  ),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                width: 300,
                height: 200,
                fit: BoxFit.fill,
              ),
            const SizedBox(
              height: 20,
            ),
            if (_selectedImage != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _restartImage();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        )),
                    child: const Text(
                      "Restart",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isCardVisible = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                    child: const Text(
                      "Klasifikasi",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            if (_isCardVisible) // Tampil Card jika _isCardVisible adalah true
              CardKlasifikasi(),
          ],
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnImage == null) return;
    setState(() {
      _selectedImage = File(returnImage.path);
    });
  }

  void _restartImage() {
    setState(() {
      _selectedImage = null;
      _isCardVisible = false;
    });
  }
}

class CardKlasifikasi extends StatelessWidget {
  const CardKlasifikasi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Jenis Gigi:",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                "Kondisi Gigi:",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          )),
    );
  }
}
