import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
    this.photoUrl = '',
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? photoUrl,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
