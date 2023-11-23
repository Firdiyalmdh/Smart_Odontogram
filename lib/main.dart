import 'package:flutter/material.dart';
import 'package:odontogram/components/pasien_provider.dart';
import 'package:odontogram/pages/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Smart_Odontogram());
}

class Smart_Odontogram extends StatelessWidget {
  const Smart_Odontogram({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PasienProvider(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
