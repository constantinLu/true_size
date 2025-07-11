// lib/core/utils/helpers.dart
import 'package:intl/intl.dart';
import '../enums/measurement_type.dart';

class Helpers {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  static String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static MeasurementType getMeasurementTypeFromCategory(String category) {
    return MeasurementType.fromString(category);
  }

  static String cleanTag(String tag) {
    // Remove special characters except # and make lowercase
    String cleaned = tag.toLowerCase().replaceAll(RegExp(r'[^\w#]'), '');

    // Ensure it starts with #
    if (!cleaned.startsWith('#')) {
      cleaned = '#$cleaned';
    }

    return cleaned;
  }

  static List<String> parseTagsFromString(String input) {
    if (input.trim().isEmpty) return [];

    return input
        .split(RegExp(r'[,\s]+'))
        .map((tag) => cleanTag(tag.trim()))
        .where((tag) => tag.length > 1)
        .toSet()
        .toList();
  }

  static String formatMeasurementCount(int count) {
    if (count == 0) return 'No measurements';
    if (count == 1) return '1 measurement';
    return '$count measurements';
  }
}