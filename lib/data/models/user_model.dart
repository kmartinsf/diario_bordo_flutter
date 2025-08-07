import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? city;
  final String? photoUrl;
  final Timestamp createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.city,
    this.photoUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'city': city,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      city: map['city'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  UserModel copyWith({String? name, String? city, String? photoUrl}) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      city: city ?? this.city,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
    );
  }
}
