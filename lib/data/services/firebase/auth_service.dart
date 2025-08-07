import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diario_bordo_flutter/data/models/user_model.dart';
import 'package:diario_bordo_flutter/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _repo = AuthRepository();

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user != null) {
      final userModel = UserModel(
        id: user.uid,
        name: name,
        email: email,
        city: null,
        photoUrl: null,
        createdAt: Timestamp.now(),
      );

      await _repo.createUser(userModel);
    }

    return credential;
  }

  Future<void> login({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (!doc.exists) {
      final userModel = UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        city: null,
        photoUrl: user.photoURL,
        createdAt: Timestamp.now(),
      );

      await AuthRepository().createUser(userModel);
    }
  }
}
