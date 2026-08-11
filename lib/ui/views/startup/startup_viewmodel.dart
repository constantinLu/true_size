import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:true_size/app/app.router.dart';

import '../../../app/app.locator.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';

class StartupViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();

  Future<void> runStartupLogic() async {
    // Add a small delay for splash screen effect
    await Future.delayed(const Duration(seconds: 2));
    // Check if user is already signed in
    if (_authService.isLoggedIn) {
      await _navigationService.navigateToHomeView();
    } else {
      await _navigationService.navigateToLoginView();
    }
  }

//FORM
// - GROUP
// name - BODY
// icon - User selects an icon . Icon.body how does it saves in db?
// color - Color.BLUE
// measurements - EMPTY for now :))
// tags -> #body, #measurements  //select from the selection else create new
// userId -> set the userId from the currently logged user
// createdAt -> now
// updatedAt -> now

// Measurements: >
// icon - User selects an icon
// name - Biceps
// value - 35
// unit - cm
// Brand? = null (this is optional)
// CustomBrand? == null (this is optional)
// Notes? (optional) (Field for writing some notes)
// groupId = at this time (the id is not known !?)

// icon - User selects an icon
// name - Biceps
// value - 35
// unit - cm
// Brand? = null (this is optional)
// CustomBrand? == null (this is optional)
// Notes? (optional) (Field for writing some notes)
// groupId = at this time (the id is not known !?)
}
