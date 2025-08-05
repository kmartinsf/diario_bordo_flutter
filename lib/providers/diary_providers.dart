import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/diary_repository.dart';

final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  return DiaryRepository();
});
