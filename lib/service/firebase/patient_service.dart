import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:odontogram/models/patient.dart';
import 'package:odontogram/service/dto/result.dart';
import 'package:odontogram/service/firebase/firebase_attr.dart';

class PatientService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Result<Stream<List<Patient>>> getAllPatients() {
    try {
      final snapshot = _db.collection(PATIENT_COLLECTION).snapshots();
      final patients = snapshot.map(
        (event) =>
            event.docs.map((doc) => doc.data().toPatient(doc.id)).toList(),
      );
      return Result(patients, null);
    } on Exception catch (err) {
      return Result(null, err);
    }
  }

  Future<Result<void>> addPatient(Patient data) async {
    try {
      await _db.collection(PATIENT_COLLECTION).add(data.toMap());
      return Result("", null);
    } on Exception catch (err) {
      return Result(null, err);
    }
  }

  Future<Result<void>> deletePatien(String id) async {
    try {
      final patientRef = _db.collection(PATIENT_COLLECTION).doc(id);
      final medicalRef = patientRef.collection(MEDICAL_RECORD_COLLECTION);
      final medicalRecords = await medicalRef.get();

      List<Future<void>> deleteJob = [];
      for (QueryDocumentSnapshot doc in medicalRecords.docs) {
        deleteJob.add(medicalRef.doc(doc.id).delete());
      }
      deleteJob.add(patientRef.delete());
      await Future.wait(deleteJob);

      return Result("", null);
    } on Exception catch (err) {
      return Result(null, err);
    }
  }
}
