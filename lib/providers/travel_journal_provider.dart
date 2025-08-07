import 'dart:io';

import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:diario_bordo_flutter/data/services/firebase/travel_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/travel_journal_repository.dart';

final travelJournalRepositoryProvider = Provider<TravelJournalRepository>((
  ref,
) {
  return TravelJournalRepository();
});

final travelJournalServiceProvider = Provider<TravelJournalService>((ref) {
  final repository = ref.read(travelJournalRepositoryProvider);
  return TravelJournalService(repository);
});

class TravelJournalNotifier
    extends StateNotifier<AsyncValue<List<TravelJournal>>> {
  final TravelJournalRepository _repository;

  TravelJournalNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadJournals();
  }

  Future<void> _loadJournals() async {
    try {
      final journals = await _repository.fetchJournals();
      state = AsyncValue.data(journals);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async => _loadJournals();

  Future<void> addJournal(TravelJournal journal) async {
    await _repository.addJournal(journal);
    await _loadJournals();
  }

  Future<void> updateJournal(TravelJournal journal, {File? newImage}) async {
    await _repository.updateJournal(journal, newImage: newImage);
    await _loadJournals();
  }

  Future<void> deleteJournal(String id) async {
    await _repository.deleteJournal(id);
    await _loadJournals();
  }
}

final travelJournalNotifierProvider =
    StateNotifierProvider<
      TravelJournalNotifier,
      AsyncValue<List<TravelJournal>>
    >((ref) {
      final repository = ref.read(travelJournalRepositoryProvider);
      return TravelJournalNotifier(repository);
    });
