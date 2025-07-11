import 'package:cloud_firestore/cloud_firestore.dart';

class MeasurementItem {
  final String id;
  final String brand;
  final String size;
  final String? notes;
  final DateTime createdAt;

  MeasurementItem({
    required this.id,
    required this.brand,
    required this.size,
    this.notes,
    required this.createdAt,
  });

  factory MeasurementItem.fromJson(Map<String, dynamic> json) {
    return MeasurementItem(
      id: json['id'] ?? '',
      brand: json['brand'] ?? '',
      size: json['size'] ?? '',
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'size': size,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MeasurementItem copyWith({
    String? id,
    String? brand,
    String? size,
    String? notes,
    DateTime? createdAt,
  }) {
    return MeasurementItem(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      size: size ?? this.size,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// lib/core/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
    };
  }
}

