import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:odontogram/service/dto/result.dart';
import 'package:odontogram/models/user.dart' as model;
import 'package:odontogram/service/firebase/firebase_attr.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Result<UserCredential>> login({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception("Email dan password tidak boleh kosong");
      }
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Result(cred, null);
    } on Exception catch (err) {
      return Result(null, err);
    }
  }

  Future<Result<model.User>> register({
    required String name,
    required String institute,
    required String email,
    required String password,
  }) async {
    try {
      if (name.isEmpty) {
        throw Exception("Nama tidak boleh kosong");
      } else if (institute.isEmpty) {
        throw Exception("Instansi tidak boleh kosong");
      } else if (email.isEmpty) {
        throw Exception("Email tidak boleh kosong");
      } else if (password.isEmpty) {
        throw Exception("Password tidak boleh kosong");
      }

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      model.User user =
          model.User(email: email, name: name, institute: institute);

      await _db
          .collection(USER_COLLECTION)
          .doc(cred.user!.uid)
          .set(user.toMap());

      return Result(user, null);
    } on Exception catch (err) {
      return Result(null, err);
    }
  }

  Future<Result<model.User>> getUserDetail() async {
    try {
      final snapshot = await _db
          .collection(USER_COLLECTION)
          .doc(_auth.currentUser!.uid)
          .get();
      final user = (snapshot.data() as Map<String, dynamic>).toUser();
      return Result(user, null);
    } on Exception catch (err) {
      return Result(null, err);
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _auth.signOut();
      return Result(null, null);
    } on Exception catch (err) {
      return Result(null, err);
    }
  }

  Stream<User?> userChanges() => _auth.userChanges();
  User? get currentUser => _auth.currentUser;
}
