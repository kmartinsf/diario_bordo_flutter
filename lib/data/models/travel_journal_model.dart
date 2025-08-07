import 'package:cloud_firestore/cloud_firestore.dart';

class TravelJournal {
  final String id;
  final String userId;
  final String location;
  final String title;
  final String description;
  final double rating;
  final String? coverUrl;
  final Timestamp createdAt;

  TravelJournal({
    required this.id,
    required this.userId,
    required this.title,
    required this.location,
    required this.description,
    required this.rating,
    required this.createdAt,
    this.coverUrl,
  });

  factory TravelJournal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TravelJournal(
      id: doc.id,
      userId: data['userId'] ?? '',
      location: data['location'],
      title: data['title'],
      description: data['description'],
      rating: (data['rating'] ?? 0).toDouble(),
      coverUrl: data['coverUrl'],
      createdAt: data['createdAt'] is Timestamp
          ? data['createdAt']
          : Timestamp.now(),
    );
  }
}
