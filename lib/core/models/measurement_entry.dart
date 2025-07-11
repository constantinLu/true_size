import 'package:cloud_firestore/cloud_firestore.dart';
import 'measurement_item.dart';
class MeasurementEntry {
  final String id;
  final String userId;
  final String title;
  final String category;
  final String icon;
  final List<MeasurementItem> measurements;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  MeasurementEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.icon,
    required this.measurements,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MeasurementEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MeasurementEntry(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      icon: data['icon'] ?? '',
      measurements: (data['measurements'] as List<dynamic>? ?? [])
          .map((item) => MeasurementItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'category': category,
      'icon': icon,
      'measurements': measurements.map((item) => item.toJson()).toList(),
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  MeasurementEntry copyWith({
    String? id,
    String? userId,
    String? title,
    String? category,
    String? icon,
    List<MeasurementItem>? measurements,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MeasurementEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      measurements: measurements ?? this.measurements,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}