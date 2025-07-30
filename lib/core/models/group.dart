import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:true_size/core/models/tag.dart';

import 'measurement.dart';

class Group {
  final String id;
  final String name;
  final String icon;
  final String color;
  final List<Measurement> measurements;
  final List<Tag> tags; //Fks - many to many
  final String userId; //FK
  final DateTime createdAt;
  final DateTime updatedAt;

  Group({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.measurements,
    required this.tags,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'measurementIds':
          measurements.map((measurement) => measurement.id).toList(),
      'tagIds': tags.map((tag) => tag.id).toList(),
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Group.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Group(
      id: doc.id,
      name: data['name'] ?? '',
      icon: data['icon'] ?? 'folder',
      color: data['color'] ?? '#2196F3',
      measurements: [],
      // Empty list - will be populated by service layer
      tags: [],
      // Empty list - will be populated by service layer
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Copy with method for creating modified instances
  Group copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
    List<Measurement>? measurements,
    List<Tag>? tags,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      measurements: measurements ?? this.measurements,
      tags: tags ?? this.tags,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Group(id: $id, name: $name, icon: $icon, color: $color, '
        'measurements: ${measurements.length}, tags: ${tags.length}, userId: $userId, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Group && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
