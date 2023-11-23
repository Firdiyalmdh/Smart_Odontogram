class Pasien {
  final String nama;
  final String nik;
  final String jenisKelamin;
  final String tempatLahir;
  final String tanggalLahir;
  DateTime? tanggalPemeriksaan;

  Pasien({
    required this.nama,
    required this.nik,
    required this.jenisKelamin,
    required this.tempatLahir,
    required this.tanggalLahir,
    this.tanggalPemeriksaan,
  });
}
