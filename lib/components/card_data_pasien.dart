import 'package:flutter/material.dart';
import 'package:odontogram/components/pasien_provider.dart';
import 'package:odontogram/pages/detail_patient_screen.dart';
import 'package:provider/provider.dart';

class CardDataPasien extends StatelessWidget {
  const CardDataPasien({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<PasienProvider>(
        builder: (context, pasienProvider, child) {
          return ListView.builder(
            itemCount: pasienProvider.daftarPasien.length,
            itemBuilder: (BuildContext, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: InkWell(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
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
                            pasienProvider.daftarPasien[index].nama,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPatientScreen(),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
