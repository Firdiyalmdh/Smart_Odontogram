import 'package:equatable/equatable.dart';

import 'package:odontogram/models/medical_record.dart';

class Patient extends Equatable {
  final String name;
  final String nik;
  final String gender;
  final String birthPlace;
  final String birthDate;
  final MedicalRecord? lastMedicalExam;

  const Patient({
    required this.name,
    required this.nik,
    required this.gender,
    required this.birthPlace,
    required this.birthDate,
    required this.lastMedicalExam,
  });

  @override
  List<Object?> get props => [
        name,
        nik,
        gender,
        birthPlace,
        birthDate,
        lastMedicalExam,
      ];
}
