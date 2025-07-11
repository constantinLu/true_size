import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import '../ui/views/startup/startup_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/measurement_detail/measurement_detail_view.dart';
import '../ui/views/add_measurement/add_measurement_view.dart';
import '../core/services/auth_service.dart';
import '../core/services/firestore_service.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, path: '/', initial: true),
    MaterialRoute(page: LoginView, path: '/login'),
    MaterialRoute(page: HomeView, path: '/home'),
    MaterialRoute(page: MeasurementDetailView, path: '/measurement'),
    MaterialRoute(page: AddMeasurementView, path: '/add-measurement'),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: FirestoreService),
  ],
)
class App {}