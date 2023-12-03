import 'package:equatable/equatable.dart';

import 'package:odontogram/models/tooth.dart';

class MedicalRecord extends Equatable {
  final String date;
  final List<Tooth> result;

  const MedicalRecord({
    required this.date,
    required this.result,
  });

  @override
  List<Object?> get props => [date, result];
}
