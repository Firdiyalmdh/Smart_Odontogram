import 'package:odontogram/models/user.dart';

const String USER_COLLECTION = "users";
const String PATIENT_COLLECTION = "patients";
const String MEDICAL_RECORD_COLLECTION = "medical_records";

extension UserExt on User {
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'institute': institute,
    };
  }
}

extension MapExt on Map<String, dynamic> {
  toUser() {
    return User(
      email: this["email"],
      name: this["name"],
      institute: this["institute"],
    );
  }
}
