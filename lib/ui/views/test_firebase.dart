// String loadingMessage = 'Initializing...';
//
// Future<void> runStartupLogic() async {
//   try {
//     setBusy(true);
//
//     // Test Firestore connection
//     loadingMessage = 'Connecting to Firestore...';
//     notifyListeners();
//     await addUser();
//     await _testFirestoreConnection();
//
//     // Test services
//     loadingMessage = 'Testing services...';
//     notifyListeners();
//     // await _testServices();
//
//     loadingMessage = 'Ready!';
//     notifyListeners();
//
//     // Wait a moment to show success
//     await Future.delayed(const Duration(seconds: 1));
//
//     // Navigate to home
//     _navigationService.replaceWithHomeView();
//
//   } catch (e) {
//     setError(e);
//   } finally {
//     setBusy(false);
//   }
// }
//
// Future<void> _testFirestoreConnection() async {
//   try {
//     // Simple test to verify Firestore connection
//     await firestore.collection('users').limit(1).get();
//   } catch (e) {
//     throw Exception('Firestore connection failed: $e');
//   }
// }
//
// Future<void> addUser() async {
//   try {
//     // Simple test to verify Firestore connection
//     await _userService.createUser(TrueUser(email: "lunguucatalin@gmail.com", displayName: "Lungu", createdAt: DateTime.now(), lastLoginAt: DateTime.now()));
//   } catch (e) {
//     throw Exception('Firestore connection failed: $e');
//   }
//
//   //step ?
//   Future<void> addTag() async {
//     try {
//       // Simple test to verify Firestore connection
//       await _userService.createUser(
//           TrueUser(email: "lunguucatalin@gmail.com", displayName: "Lungu", createdAt: DateTime.now(), lastLoginAt: DateTime.now()));
//     } catch (e) {
//       throw Exception('Firestore connection failed: $e');
//     }
//   }
//
//   //step ?
//   Future<void> addTag() async {
//     try {
//       // Simple test to verify Firestore connection
//       await _userService.createUser(
//           TrueUser(email: "lunguucatalin@gmail.com", displayName: "Lungu", createdAt: DateTime.now(), lastLoginAt: DateTime.now()));
//     } catch (e) {
//       throw Exception('Firestore connection failed: $e');
//     }
//   }
//
//   //step ?
//   Future<void> addGroup() async {
//     try {
//       // Simple test to verify Firestore connection
//       await _userService.createUser(
//           TrueUser(email: "lunguucatalin@gmail.com", displayName: "Lungu", createdAt: DateTime.now(), lastLoginAt: DateTime.now()));
//     } catch (e) {
//       throw Exception('Firestore connection failed: $e');
//     }
//   }
//
//   Future<void> _testServices() async {
//     try {
//       // Test that services are properly injected and working
//       final userCount = await _userService.getUserCount();
//       print('✅ User service working! Current users: $userCount');
//
//       // You can add more service tests here if needed
//       print('✅ All services initialized successfully!');
//     } catch (e) {
//       throw Exception('Service initialization failed: $e');
//     }
//   }
//
//   Future<void> retrySetup() async {
//     clearErrors();
//     await runStartupLogic();
//   }
// }
