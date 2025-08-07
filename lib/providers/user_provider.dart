import 'package:diario_bordo_flutter/data/models/user_model.dart';
import 'package:diario_bordo_flutter/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userProvider = FutureProvider<UserModel>((ref) async {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;

  if (user == null) {
    throw Exception('Usuário não logado');
  }

  final repository = ref.read(authRepositoryProvider);
  return repository.fetchUser(user.uid);
});
