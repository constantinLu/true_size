import 'package:flutter/foundation.dart';

/// Holds the current search query shared between the floating top bar and the
/// Groups / Items tabs, so typing in the bar filters whichever tab is visible.
class SearchService extends ChangeNotifier {
  String _query = '';
  String get query => _query;
  bool get isActive => _query.trim().isNotEmpty;

  void setQuery(String value) {
    if (value == _query) return;
    _query = value;
    notifyListeners();
  }

  void clear() => setQuery('');
}
