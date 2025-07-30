import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../enums/unit.dart';
import '../utils/icon_helper.dart';
import 'brand.dart';

class Measurement {
  final String id;
  final String icon;
  final String name;
  final String value;
  final Unit unit;
  final Brand? brand; //fk
  final String? customBrand;
  final String? notes;
  final String groupId; //fk
  final DateTime createdAt;

  Measurement({
    required this.id,
    required this.icon,
    required this.name,
    required this.value,
    required this.unit,
    this.brand,
    this.customBrand,
    this.notes,
    required this.groupId,
    required this.createdAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
      'value': value,
      'unit': unit.name, // Store enum as string
      'brand': brand?.toFirestore(), // Store brand object if exists
      'customBrand': customBrand,
      'notes': notes,
      'groupId': groupId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory Measurement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Measurement(
      id: doc.id,
      icon: data['icon'] ?? 'straighten',
      name: data['name'] ?? '',
      value: data['value'] ?? '0',
      unit: Unit.values.firstWhere(
        (u) => u.name == data['unit'],
        orElse: () => Unit.cm,
      ),
      brand: data['brand'] != null
          ? Brand.fromMap(data['brand'] as Map<String, dynamic>)
          : null,
      customBrand: data['customBrand'],
      notes: data['notes'],
      groupId: data['groupId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Create from Map (useful for nested data)
  factory Measurement.fromMap(Map<String, dynamic> data, String id) {
    return Measurement(
      id: id,
      icon: data['icon'] ?? 'straighten',
      name: data['name'] ?? '',
      value: data['value'] ?? '0',
      unit: Unit.values.firstWhere(
        (u) => u.name == data['unit'],
        orElse: () => Unit.cm,
      ),
      brand: data['brand'] != null
          ? Brand.fromMap(data['brand'] as Map<String, dynamic>)
          : null,
      customBrand: data['customBrand'],
      notes: data['notes'],
      groupId: data['groupId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert to Map (useful for batch operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
      'value': value,
      'unit': unit.name,
      'brand': brand?.toMap(),
      'customBrand': customBrand,
      'notes': notes,
      'groupId': groupId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Copy with method for creating modified instances
  Measurement copyWith({
    String? id,
    String? icon,
    String? name,
    String? value,
    Unit? unit,
    Brand? brand,
    String? customBrand,
    String? notes,
    String? groupId,
    DateTime? createdAt,
  }) {
    return Measurement(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      brand: brand ?? this.brand,
      customBrand: customBrand ?? this.customBrand,
      notes: notes ?? this.notes,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert icon string to actual Flutter icon
  IconData get iconData {
    return MeasurementIconHelper.getIcon(icon);
  }

  // Get the brand name (either from Brand object or custom string)
  String get brandName {
    if (brand != null) {
      return brand!.name;
    } else if (customBrand != null && customBrand!.isNotEmpty) {
      return customBrand!;
    } else {
      return 'Unknown';
    }
  }

  // Check if this measurement uses a custom brand
  bool get hasCustomBrand => customBrand != null && customBrand!.isNotEmpty;

  // Check if this measurement has a global brand
  bool get hasGlobalBrand => brand != null;

  // Format the measurement value with unit
  String get formattedValue {
    return '$value ${unit.name}';
  }

  // Get numeric value (try to parse string value to double)
  double? get numericValue {
    return double.tryParse(value);
  }

  @override
  String toString() {
    return 'Measurement(id: $id, name: $name, value: $value, unit: ${unit.name}, '
        'brand: ${brandName}, groupId: $groupId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Measurement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
