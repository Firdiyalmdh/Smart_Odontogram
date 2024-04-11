import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odontogram/models/tooth.dart';
import 'package:odontogram/service/dto/result.dart';
import 'package:odontogram/service/firebase/firebase_attr.dart';

class ToothService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Result<Stream<List<Tooth>>> getAllToothData(String patientId) {
    try {
      final snapshot = _db
          .collection(PATIENT_COLLECTION)
          .doc(patientId)
          .collection(MEDICAL_RECORD_COLLECTION)
          .snapshots();
      final toothData = snapshot.map(
        (event) => event.docs.map((doc) => doc.data().toTooth(doc.id)).toList(),
      );
      return Result(toothData, null);
    } on Exception catch (err) {
      return Result(null, err);
    }
  }

  Future<Result<void>> saveMedicalRecord(List<Tooth> data, String lastMedRecordDate, String patientId) async {
    try {
      final patientRef = _db
            .collection(PATIENT_COLLECTION)
            .doc(patientId);
      final medRecordRef = patientRef.collection(MEDICAL_RECORD_COLLECTION);
      await _db.runTransaction((trx) async {
        data.forEach((tooth) => trx.set(medRecordRef.doc(tooth.id), tooth.toMap()));
        trx.update(patientRef, { "last_checkup_date": lastMedRecordDate });
      });
      return Result("", null);
    } on Exception catch (err) {
      return Result(null, err);
    }
  }

  Future<Result<void>> editMedicalRecord(Tooth data, String patientId) async {
    try {
      await _db
          .collection(PATIENT_COLLECTION)
          .doc(patientId)
          .collection(MEDICAL_RECORD_COLLECTION)
          .doc(data.id)
          .set(data.toMap(), SetOptions(merge: true));
      return Result("", null);
    } on Exception catch (err) {
      return Result(null, err);
    }
  }
}
