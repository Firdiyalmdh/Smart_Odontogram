import 'package:odontogram/models/patient.dart';
import 'package:odontogram/models/tooth.dart';
import 'package:odontogram/models/user.dart';

// COLLECTIONS
const String USER_COLLECTION = "users";
const String PATIENT_COLLECTION = "patients";
const String MEDICAL_RECORD_COLLECTION = "medical_records";

// PROPS
const String EMAIL_PROP = "email";
const String NAME_PROP = "name";
const String INSTITURE_PROP = "institute";
const String NIK_PROP = "nik";
const String GENDER_PROP = "gender";
const String BIRTH_PLACE_PROP = "birth_place";
const String BIRTH_DATE_PROP = "birth_date";
const String LAST_CHECKUP_DATE_PROP = "last_checkup_date";
const String TOOTH_TYPE_PROP = "type";
const String TOOTH_CONDITION_PROP = "condition";
const String IMAGE_PATH = "imagePath";

extension UserExt on User {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      EMAIL_PROP: email,
      NAME_PROP: name,
      INSTITURE_PROP: institute,
    };
  }
}

extension PatientExt on Patient {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      NAME_PROP: name,
      NIK_PROP: nik,
      GENDER_PROP: gender,
      BIRTH_PLACE_PROP: birthPlace,
      BIRTH_DATE_PROP: birthDate,
      LAST_CHECKUP_DATE_PROP: lastCheckupDate
    };
  }
}

extension ToothExt on Tooth {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      IMAGE_PATH: imagePath,
      TOOTH_TYPE_PROP: type.name,
      TOOTH_CONDITION_PROP: condition.name
    };
  }
}

extension MapExt on Map<String, dynamic> {
  User toUser() {
    return User(
      email: this[EMAIL_PROP],
      name: this[NAME_PROP],
      institute: this[INSTITURE_PROP],
    );
  }

  Patient toPatient(String id) {
    return Patient(
      id: id,
      name: this[NAME_PROP],
      nik: this[NIK_PROP],
      gender: this[GENDER_PROP],
      birthPlace: this[BIRTH_PLACE_PROP],
      birthDate: this[BIRTH_DATE_PROP],
      lastCheckupDate: this[LAST_CHECKUP_DATE_PROP],
    );
  }

  Tooth toTooth(String id) {
    return Tooth(
      id: id,
      type: ToothType.values.byName(this[TOOTH_TYPE_PROP]),
      condition: ToothCondition.values.byName(this[TOOTH_CONDITION_PROP]),
      imagePath: this[IMAGE_PATH],
    );
  }
}
