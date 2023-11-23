import 'package:flutter/material.dart';
import 'pasien_model.dart';

class PasienProvider extends ChangeNotifier {
  List<Pasien> _daftarPasien = [];
  List<Pasien> _filteredPasien = [];

  List<Pasien> get daftarPasien =>
      _filteredPasien.isNotEmpty ? _filteredPasien : _daftarPasien;

  void tambahPasien(Pasien pasien) {
    _daftarPasien.add(pasien);
    notifyListeners();
  }

  void searchPasien(String query) {
    _filteredPasien.clear();
    if (query.isEmpty) {
      _filteredPasien.addAll(_daftarPasien);
    } else {
      _filteredPasien.addAll(_daftarPasien.where(
        (pasien) => pasien.nama.toLowerCase().contains(query.toLowerCase()),
      ));
    }
    notifyListeners();
  }
}
