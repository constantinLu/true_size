import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/auth_service.dart';
import '../services/body_service.dart';
import '../services/brand_service.dart';
import '../services/firestore_service.dart';
import '../services/group_service.dart';
import '../services/local_deletion_service.dart';
import '../services/logo_service.dart';
import '../services/measurement_service.dart';
import '../services/search_service.dart';
import '../services/settings_service.dart';
import '../services/tag_service.dart';
import '../services/user_service.dart';
import '../ui/views/add_measurement/add_group_form_view.dart';
import '../ui/views/add_measurement/add_measurement_view.dart';
import '../ui/views/body_detail/body_part_detail_view.dart';
import '../ui/views/item_detail/item_detail_view.dart';
import '../ui/views/lock/lock_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/measurement_detail/measurement_detail_view.dart';
import '../ui/views/profile/profile_view.dart';
import '../ui/views/root/root_view.dart';
import '../ui/views/startup/startup_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, path: '/', initial: true),
    MaterialRoute(page: LoginView, path: '/login'),
    MaterialRoute(page: LockView, path: '/lock'),
    MaterialRoute(page: RootView, path: '/root'),
    MaterialRoute(page: GroupDetailView, path: '/measurement'),
    MaterialRoute(page: AddGroupFormView, path: '/add-group'),
    MaterialRoute(page: AddMeasurementView, path: '/add-measurement'),
    MaterialRoute(page: ItemDetailView, path: '/item'),
    MaterialRoute(page: BodyPartDetailView, path: '/body-part'),
    MaterialRoute(page: ProfileView, path: '/profile'),
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
    LazySingleton(classType: SettingsService),
    LazySingleton(classType: LogoService),
    LazySingleton(classType: SearchService),
    LazySingleton(classType: BodyService),
    LazySingleton(classType: LocalDeletionService),
    //
    LazySingleton(classType: BottomSheetService)
  ],
  logger: StackedLogger(),
)
class App {}
