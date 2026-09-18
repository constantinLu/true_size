import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';

/// Owns the bottom-navigation state and the "add group" action for the shell.
class RootViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  int _index = 0;
  int get index => _index;

  void setIndex(int value) {
    if (value == _index) return;
    _index = value;
    notifyListeners();
  }

  /// The center "+" creates a new group (e.g. Shoes, Jeans, Lingerie).
  /// Individual measurements are then added from inside a group's detail.
  Future<void> addGroup() async {
    await _navigationService.navigateToAddGroupFormView();
  }
}
