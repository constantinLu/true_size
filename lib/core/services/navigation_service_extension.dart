import 'package:stacked_services/stacked_services.dart';
import '../../app/app.locator.dart';

extension NavigationServiceExtensions on NavigationService {
  Future<dynamic> navigateToStartupView() async {
    return navigateTo('/');
  }

  Future<dynamic> navigateToLoginView() async {
    return navigateTo('/login');
  }

  Future<dynamic> navigateToHomeView() async {
    return navigateTo('/home');
  }

  Future<dynamic> navigateToMeasurementDetailView({required String measurementId}) async {
    return navigateTo('/measurement', arguments: {'measurementId': measurementId});
  }

  Future<dynamic> replaceWithHomeView() async {
    return clearStackAndShow('/home');
  }

  Future<dynamic> replaceWithLoginView() async {
    return clearStackAndShow('/login');
  }
}