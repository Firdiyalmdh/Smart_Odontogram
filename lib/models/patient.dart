import 'package:equatable/equatable.dart';

class Patient extends Equatable {
  final String id;
  final String name;
  final String nik;
  final String gender;
  final String birthPlace;
  final String birthDate;
  final String? lastCheckupDate;

  const Patient({
    required this.id,
    required this.name,
    required this.nik,
    required this.gender,
    required this.birthPlace,
    required this.birthDate,
    required this.lastCheckupDate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        nik,
        gender,
        birthPlace,
        birthDate,
        lastCheckupDate,
      ];
}
