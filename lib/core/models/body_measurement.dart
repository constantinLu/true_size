import 'package:cloud_firestore/cloud_firestore.dart';

/// A single recorded snapshot of a body measurement: a [value] on a [date].
class BodyEntry {
  const BodyEntry({required this.value, required this.date});
  final double value;
  final DateTime date;

  Map<String, dynamic> toMap() => {'value': value, 'date': Timestamp.fromDate(date)};

  factory BodyEntry.fromMap(Map<String, dynamic> map) {
    final ts = map['date'];
    return BodyEntry(
      value: (map['value'] as num?)?.toDouble() ?? 0,
      date: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }
}

/// The recorded history for a single body part (one Firestore doc per user +
/// part). [entries] are kept newest-first; [latest] is the current value.
class BodyMeasurement {
  BodyMeasurement({required this.partKey, required this.entries});

  final String partKey;
  final List<BodyEntry> entries;

  BodyEntry? get latest => entries.isEmpty ? null : entries.first;

  Map<String, dynamic> toFirestore(String userId) => {
        'userId': userId,
        'part': partKey,
        'entries': entries.map((e) => e.toMap()).toList(),
      };

  factory BodyMeasurement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final raw = data['entries'];
    final entries = <BodyEntry>[
      if (raw is List)
        for (final e in raw)
          if (e is Map) BodyEntry.fromMap(Map<String, dynamic>.from(e)),
    ]..sort((a, b) => b.date.compareTo(a.date));
    return BodyMeasurement(partKey: (data['part'] ?? '').toString(), entries: entries);
  }
}
