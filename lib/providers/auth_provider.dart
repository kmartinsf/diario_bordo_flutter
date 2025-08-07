import 'package:diario_bordo_flutter/data/repositories/auth_repository.dart';
import 'package:diario_bordo_flutter/data/services/firebase/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
