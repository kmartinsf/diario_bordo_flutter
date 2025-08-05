import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/travel_journal_repository.dart';

final travelJournalRepositoryProvider = Provider<TravelJournalRepository>((ref) {
  return TravelJournalRepository();
});
