import 'package:cloud_firestore/cloud_firestore.dart';

class Diary {
  final String id;
  final String location;
  final String title;
  final String description;
  final double rating;
  final String? coverUrl;
  final Timestamp createdAt;

  Diary({
    required this.id,
    required this.location,
    required this.title,
    required this.description,
    required this.rating,
    required this.createdAt,
    this.coverUrl,
  });

  factory Diary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Diary(
      id: doc.id,
      location: data['location'],
      title: data['title'],
      description: data['description'],
      rating: (data['rating'] ?? 0).toDouble(),
      coverUrl: data['coverUrl'],
      createdAt: data['createdAt'],
    );
  }
}
