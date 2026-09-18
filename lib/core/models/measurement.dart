import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../enums/unit.dart';
import '../utils/icon_helper.dart';
import 'brand.dart';
import 'measurement_size.dart';

class Measurement {
  final String id;
  final String icon;
  final String name;

  /// One or more size readings (e.g. a shoe stored as both `42 EU` and
  /// `25.5 cm`). Always contains at least one entry.
  final List<MeasurementSize> sizes;

  final Brand? brand; //fk
  final String? customBrand;
  final String? notes;
  final String groupId; //fk
  final DateTime createdAt;

  Measurement({
    required this.id,
    required this.icon,
    required this.name,
    required this.sizes,
    this.brand,
    this.customBrand,
    this.notes,
    required this.groupId,
    required this.createdAt,
  });

  /// The primary (first) size's value / unit. Kept for callers that only care
  /// about a single reading.
  String get value => sizes.isEmpty ? '' : sizes.first.value;
  Unit get unit => sizes.isEmpty ? Unit.shoeSize : sizes.first.unit;

  /// Reads the sizes list from a stored document, falling back to the legacy
  /// single top-level `value` / `unit` fields for documents written before
  /// multiple sizes were supported.
  static List<MeasurementSize> _parseSizes(Map<String, dynamic> data) {
    final raw = data['sizes'];
    if (raw is List && raw.isNotEmpty) {
      return raw
          .whereType<Map>()
          .map((m) => MeasurementSize.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    }
    // Legacy shape: a single value + unit at the top level.
    return [
      MeasurementSize(
        value: (data['value'] ?? '0').toString(),
        unit: Unit.values.firstWhere(
          (u) => u.name == data['unit'],
          orElse: () => Unit.cm,
        ),
      ),
    ];
  }

  Map<String, dynamic> _sizeFields() => {
        'sizes': sizes.map((s) => s.toMap()).toList(),
        // Mirror the first size into the legacy fields so anything still
        // reading `value` / `unit` keeps working.
        'value': value,
        'unit': unit.name,
      };

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
      ..._sizeFields(),
      'brand': brand?.toFirestore(),
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
      sizes: _parseSizes(data),
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
      sizes: _parseSizes(data),
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
      ..._sizeFields(),
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
    List<MeasurementSize>? sizes,
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
      sizes: sizes ?? this.sizes,
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

  /// All sizes joined for display, e.g. `42 EU · 25.5 cm`.
  String get sizesLabel => sizes.map((s) => s.label).join(' · ');

  // Format the primary measurement value with unit
  String get formattedValue => sizes.isEmpty ? '' : sizes.first.label;

  // Get numeric value of the primary size
  double? get numericValue => sizes.isEmpty ? null : sizes.first.numericValue;

  @override
  String toString() {
    return 'Measurement(id: $id, name: $name, sizes: $sizesLabel, '
        'brand: $brandName, groupId: $groupId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Measurement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
