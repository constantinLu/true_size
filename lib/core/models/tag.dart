import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Tag {
  final String id;
  final String name;
  final List<String> groupIds;

  Tag({required this.id, required this.name, required this.groupIds});

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {'id': id, 'name': name, 'groupIds': groupIds};
  }

  // Create from Firestore document
  factory Tag.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Tag(
      id: doc.id,
      name: data['name'] ?? '',
      groupIds: List<String>.from(data['groupIds'] ?? []),
    );
  }

  // Create from Map (useful for nested data)
  factory Tag.fromMap(Map<String, dynamic> data) {
    return Tag(
        id: const Uuid().v4().toString(),
        name: data['name'] ?? '',
        groupIds: data['groupIds'] ?? []);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'groupIds': groupIds,
    };
  }

  Tag copyWith({
    String? id,
    String? name,
    List<String>? groupIds,
  }) {
    return Tag(
        id: id ?? this.id,
        name: name ?? this.name,
        groupIds: groupIds ?? this.groupIds);
  }

  @override
  String toString() {
    return 'Tag(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          groupIds == other.groupIds;

  @override
  int get hashCode => Object.hash(id, name, groupIds);
}
