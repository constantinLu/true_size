import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../services/group_service.dart';

/// Turns any thrown error into a short, friendly sentence safe to show a user -
/// never a raw exception, error code, JSON payload or stack trace.
///
/// Known, already-clean app exceptions keep a tailored message; everything else
/// (Firebase/platform/service errors that embed technical detail) falls back to
/// [fallback], so nothing technical ever reaches the UI.
String cleanErrorMessage(
  Object? error, {
  String fallback = 'Something went wrong. Please try again.',
}) {
  if (error is DuplicateGroupNameException) {
    return 'A group named "${error.name}" already exists.';
  }
  return fallback;
}

/// Shows [message] as a clean error card floating just above the bottom nav bar.
/// Uses the root [ScaffoldMessenger] so it works from anywhere (view models
/// included) without needing a local BuildContext.
void showAppError(String message) {
  // Showing the error card must never itself throw (e.g. no binding/context).
  try {
    final context = StackedService.navigatorKey?.currentContext;
    if (context == null) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2A1E22),
        elevation: 6,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 28),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x33E79AA6)),
        ),
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Color(0xFFE79AA6), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14, height: 1.3),
              ),
            ),
          ],
        ),
      ),
    );
  } catch (_) {
    // No context/binding available - nothing to show.
  }
}

/// Convenience for `catch` blocks: resolves [error] to a clean message (using
/// [fallback] for anything technical) and shows the error card.
void showErrorFor(Object? error, {String? fallback}) {
  showAppError(cleanErrorMessage(error,
      fallback: fallback ?? 'Something went wrong. Please try again.'));
}
