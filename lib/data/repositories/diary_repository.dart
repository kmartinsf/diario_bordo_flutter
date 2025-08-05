import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diario_bordo_flutter/data/models/travel_diary_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DiaryRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _diaries =>
      _firestore.collection('users').doc(_auth.currentUser!.uid).collection('diaries');

  Future<void> addDiary(Diary diary, {File? imageFile}) async {
    final docRef = _diaries.doc();
    String? imageUrl;

    if (imageFile != null) {
      final ref = _storage
          .ref('users/${_auth.currentUser!.uid}/diaries/${docRef.id}.jpg');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    await docRef.set({
      'location': diary.location,
      'title': diary.title,
      'description': diary.description,
      'rating': diary.rating,
      'createdAt': Timestamp.now(),
      'coverUrl': imageUrl,
    });
  }

  Future<List<Diary>> fetchDiaries() async {
    final querySnapshot = await _diaries.orderBy('createdAt', descending: true).get();
    return querySnapshot.docs.map((doc) => Diary.fromFirestore(doc)).toList();
  }

  Future<void> updateDiary(Diary diary, {File? newImage}) async {
    final docRef = _diaries.doc(diary.id);
    String? imageUrl = diary.coverUrl;

    if (newImage != null) {
      final ref = _storage.ref('users/${_auth.currentUser!.uid}/diaries/${diary.id}.jpg');
      await ref.putFile(newImage);
      imageUrl = await ref.getDownloadURL();
    }

    await docRef.update({
      'location': diary.location,
      'title': diary.title,
      'description': diary.description,
      'rating': diary.rating,
      'coverUrl': imageUrl,
    });
  }

  Future<void> deleteDiary(String diaryId) async {
    final docRef = _diaries.doc(diaryId);

    try {
      final ref = _storage.ref('users/${_auth.currentUser!.uid}/diaries/$diaryId.jpg');
      await ref.delete();
    } catch (_) {}

    await docRef.delete();
  }
}
