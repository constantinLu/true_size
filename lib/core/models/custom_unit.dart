import 'package:cloud_firestore/cloud_firestore.dart';

/// A user-defined unit, stored per-user in the `units` Firestore collection.
/// Built-in units live in the [Unit] enum; these are the ones the user adds
/// themselves from the unit picker (name + short symbol, no conversion).
class CustomUnit {
  const CustomUnit({
    required this.id,
    required this.name,
    required this.symbol,
    required this.userId,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String symbol;
  final String userId;
  final DateTime createdAt;

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'symbol': symbol,
        'userId': userId,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory CustomUnit.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? const {};
    return CustomUnit(
      id: doc.id,
      name: (data['name'] ?? '').toString(),
      symbol: (data['symbol'] ?? '').toString(),
      userId: (data['userId'] ?? '').toString(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
