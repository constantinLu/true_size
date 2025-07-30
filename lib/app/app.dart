import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/auth_service.dart';
import '../services/brand_service.dart';
import '../services/firestore_service.dart';
import '../services/group_service.dart';
import '../services/measurement_service.dart';
import '../services/tag_service.dart';
import '../services/user_service.dart';
import '../ui/views/add_measurement/add_group_form_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/measurement_detail/measurement_detail_view.dart';
import '../ui/views/startup/startup_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, path: '/', initial: true),
    MaterialRoute(page: LoginView, path: '/login'),
    MaterialRoute(page: HomeView, path: '/home'),
    MaterialRoute(page: MeasurementDetailView, path: '/measurement'),
    MaterialRoute(page: AddGroupFormView, path: '/add-group'),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: MeasurementService),
    LazySingleton(classType: GroupService),
    LazySingleton(classType: BrandService),
    LazySingleton(classType: TagService),
    //
    LazySingleton(classType: BottomSheetService)
  ],
  logger: StackedLogger(),
)
class App {}
