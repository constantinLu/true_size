import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:true_size/app/app.locator.dart';
import 'package:true_size/core/models/user.dart';
import 'package:true_size/services/auth_service.dart';
import 'package:true_size/ui/views/login/login_viewmodel.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockNavigationService extends Mock implements NavigationService {}

class _MockSnackbarService extends Mock implements SnackbarService {}

void main() {
  late _MockAuthService authService;
  late _MockNavigationService navigationService;
  late _MockSnackbarService snackbarService;
  late LoginViewModel viewModel;

  setUp(() {
    locator.reset();

    authService = _MockAuthService();
    navigationService = _MockNavigationService();
    snackbarService = _MockSnackbarService();

    locator.registerSingleton<AuthService>(authService);
    locator.registerSingleton<NavigationService>(navigationService);
    locator.registerSingleton<SnackbarService>(snackbarService);

    viewModel = LoginViewModel();
  });

  tearDown(() async {
    await locator.reset();
  });

  test('navigates to home when Google sign-in succeeds', () async {
    when(() => authService.signInWithGoogle()).thenAnswer((_) async =>
        TrueUser(
          id: 'u1',
          email: 'user@example.com',
          displayName: 'User',
          createdAt: DateTime(2026, 1, 1),
          lastLoginAt: DateTime(2026, 1, 1),
        ));
    when(() => navigationService.navigateTo('/home'))
        .thenAnswer((_) async => true);

    await viewModel.signInWithGoogle();

    verify(() => authService.signInWithGoogle()).called(1);
    verify(() => navigationService.navigateTo('/home')).called(1);
    verifyNever(() => snackbarService.showSnackbar(message: any(named: 'message')));
  });

  test('shows error snackbar when Google sign-in throws', () async {
    when(() => authService.signInWithGoogle()).thenThrow(Exception('fail'));
    when(() => snackbarService.showSnackbar(
          message: any(named: 'message'),
          duration: any(named: 'duration'),
        )).thenReturn(null);

    await viewModel.signInWithGoogle();

    verify(() => authService.signInWithGoogle()).called(1);
    verify(() => snackbarService.showSnackbar(
          message: any(named: 'message'),
          duration: any(named: 'duration'),
        )).called(1);
    verifyNever(() => navigationService.navigateTo('/home'));
  });
}
