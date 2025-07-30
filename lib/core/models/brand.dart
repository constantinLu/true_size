import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Brand {
  final String id;
  final String name;
  final String? logo;
  final String? website;
  final String? createdBy;
  final int usageCount;
  final DateTime createdAt;

  Brand({
    required this.id,
    required this.name,
    this.logo,
    this.website,
    this.createdBy,
    this.usageCount = 0,
    required this.createdAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'website': website,
      'createdBy': createdBy,
      'usageCount': usageCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory Brand.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Brand(
      id: doc.id,
      name: data['name'] ?? '',
      logo: data['logo'],
      website: data['website'],
      createdBy: data['createdBy'],
      usageCount: data['usageCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Create from Map (useful for nested data)
  factory Brand.fromMap(Map<String, dynamic> data, [String? id]) {
    return Brand(
      id: id ?? const Uuid().v4().toString(),
      name: data['name'] ?? '',
      logo: data['logo'],
      website: data['website'],
      createdBy: data['createdBy'],
      usageCount: data['usageCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert to Map (useful for batch operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'website': website,
      'createdBy': createdBy,
      'usageCount': usageCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Copy with method for creating modified instances
  Brand copyWith({
    String? id,
    String? name,
    String? logo,
    String? website,
    String? createdBy,
    int? usageCount,
    DateTime? createdAt,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      website: website ?? this.website,
      createdBy: createdBy ?? this.createdBy,
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Brand(id: $id, name: $name, logo: $logo, website: $website, '
        'createdBy: $createdBy, usageCount: $usageCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Brand && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
