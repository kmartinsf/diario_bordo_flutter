import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diario_bordo_flutter/data/models/travel_journal_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TravelJournalRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _journals => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('journals');

Future<void> addJournal(TravelJournal journal) async {
  final docRef = _journals.doc();

  try {
    await docRef.set({
      'userId': _auth.currentUser!.uid,
      'location': journal.location,
      'title': journal.title,
      'description': journal.description,
      'rating': journal.rating,
      'createdAt': journal.createdAt,
      'coverUrl': journal.coverUrl,
    });
  } catch (e) {
    throw Exception('Erro ao criar diário: $e');
  }
}


  Future<List<TravelJournal>> fetchJournals() async {
    final querySnapshot = await _journals
        .orderBy('createdAt', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) => TravelJournal.fromFirestore(doc))
        .toList();
  }

  Future<void> updateJournal(TravelJournal journal, {File? newImage}) async {
    final docRef = _journals.doc(journal.id);
    String? imageUrl = journal.coverUrl;

    if (newImage != null) {
      final ref = _storage.ref(
        'users/${_auth.currentUser!.uid}/journals/${journal.id}.jpg',
      );
      await ref.putFile(newImage);
      imageUrl = await ref.getDownloadURL();
    }

    await docRef.update({
      'location': journal.location,
      'title': journal.title,
      'description': journal.description,
      'rating': journal.rating,
      'coverUrl': imageUrl,
    });
  }

  Future<void> deleteJournal(String journalId) async {
    final docRef = _journals.doc(journalId);

    try {
      final ref = _storage.ref(
        'users/${_auth.currentUser!.uid}/journals/$journalId.jpg',
      );
      await ref.delete();
    } catch (_) {}

    await docRef.delete();
  }
}
