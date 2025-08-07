import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:diario_bordo_flutter/data/repositories/travel_journal_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TravelJournalService {
  final TravelJournalRepository _repository;

  TravelJournalService(this._repository);

  Future<void> createJournal({
    required String userId,
    required String location,
    required String title,
    required String description,
    required double rating,
    File? imageFile,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    final journalCollection = firestore
        .collection('users')
        .doc(userId)
        .collection('journals');

    final docRef = journalCollection.doc();
    String? coverUrl;

    if (imageFile != null) {
      final imageRef = storage.ref('users/$userId/journals/${docRef.id}.jpg');
      await imageRef.putFile(imageFile);
      coverUrl = await imageRef.getDownloadURL();
    }

    final journal = TravelJournal(
      id: docRef.id,
      location: location,
      title: title,
      description: description,
      rating: rating,
      createdAt: Timestamp.fromDate(DateTime.now()),
      coverUrl: coverUrl,
      userId: userId,
    );

    await docRef.set({
      'id': journal.id,
      'location': journal.location,
      'title': journal.title,
      'description': journal.description,
      'rating': journal.rating,
      'createdAt': journal.createdAt,
      'coverUrl': journal.coverUrl,
      'userId': journal.userId,
    });
  }

  Future<List<TravelJournal>> getAllJournals() {
    return _repository.fetchJournals();
  }

  Future<void> updateJournal(TravelJournal journal, {File? newImage}) {
    return _repository.updateJournal(journal, newImage: newImage);
  }

  Future<void> deleteJournal(String id) {
    return _repository.deleteJournal(id);
  }
}
