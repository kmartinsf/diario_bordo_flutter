import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class AuthRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<UserModel> fetchUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return UserModel.fromMap(doc.data()!);
  }

  Future<void> updateUser(String userId, UserModel user) async {
    await _firestore.collection('users').doc(userId).update(user.toMap());
  }

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }
}
