// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:flutter/foundation.dart' as _i14;
import 'package:flutter/material.dart' as _i13;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i17;
import 'package:true_size/core/models/measurement.dart' as _i16;
import 'package:true_size/services/update_service.dart' as _i15;
import 'package:true_size/ui/views/add_measurement/add_group_form_view.dart'
    as _i8;
import 'package:true_size/ui/views/add_measurement/add_measurement_view.dart'
    as _i9;
import 'package:true_size/ui/views/body_detail/body_part_detail_view.dart'
    as _i11;
import 'package:true_size/ui/views/item_detail/item_detail_view.dart' as _i10;
import 'package:true_size/ui/views/lock/lock_view.dart' as _i4;
import 'package:true_size/ui/views/login/login_view.dart' as _i3;
import 'package:true_size/ui/views/measurement_detail/measurement_detail_view.dart'
    as _i7;
import 'package:true_size/ui/views/profile/profile_view.dart' as _i12;
import 'package:true_size/ui/views/root/root_view.dart' as _i6;
import 'package:true_size/ui/views/startup/startup_view.dart' as _i2;
import 'package:true_size/ui/views/update_required/update_required_view.dart'
    as _i5;

class Routes {
  static const startupView = '/';

  static const loginView = '/login';

  static const lockView = '/lock';

  static const updateRequiredView = '/update-required';

  static const rootView = '/root';

  static const groupDetailView = '/measurement';

  static const addGroupFormView = '/add-group';

  static const addMeasurementView = '/add-measurement';

  static const itemDetailView = '/item';

  static const bodyPartDetailView = '/body-part';

  static const profileView = '/profile';

  static const all = <String>{
    startupView,
    loginView,
    lockView,
    updateRequiredView,
    rootView,
    groupDetailView,
    addGroupFormView,
    addMeasurementView,
    itemDetailView,
    bodyPartDetailView,
    profileView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(Routes.startupView, page: _i2.StartupView),
    _i1.RouteDef(Routes.loginView, page: _i3.LoginView),
    _i1.RouteDef(Routes.lockView, page: _i4.LockView),
    _i1.RouteDef(Routes.updateRequiredView, page: _i5.UpdateRequiredView),
    _i1.RouteDef(Routes.rootView, page: _i6.RootView),
    _i1.RouteDef(Routes.groupDetailView, page: _i7.GroupDetailView),
    _i1.RouteDef(Routes.addGroupFormView, page: _i8.AddGroupFormView),
    _i1.RouteDef(Routes.addMeasurementView, page: _i9.AddMeasurementView),
    _i1.RouteDef(Routes.itemDetailView, page: _i10.ItemDetailView),
    _i1.RouteDef(Routes.bodyPartDetailView, page: _i11.BodyPartDetailView),
    _i1.RouteDef(Routes.profileView, page: _i12.ProfileView),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.StartupView: (data) {
      final args = data.getArgs<StartupViewArguments>(
        orElse: () => const StartupViewArguments(),
      );
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.StartupView(key: args.key),
        settings: data,
      );
    },
    _i3.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.LoginView(key: args.key),
        settings: data,
      );
    },
    _i4.LockView: (data) {
      final args = data.getArgs<LockViewArguments>(
        orElse: () => const LockViewArguments(),
      );
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.LockView(key: args.key),
        settings: data,
      );
    },
    _i5.UpdateRequiredView: (data) {
      final args = data.getArgs<UpdateRequiredViewArguments>(nullOk: false);
      return _i13.MaterialPageRoute<dynamic>(
        builder:
            (context) => _i5.UpdateRequiredView(info: args.info, key: args.key),
        settings: data,
      );
    },
    _i6.RootView: (data) {
      final args = data.getArgs<RootViewArguments>(
        orElse: () => const RootViewArguments(),
      );
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.RootView(key: args.key),
        settings: data,
      );
    },
    _i7.GroupDetailView: (data) {
      final args = data.getArgs<GroupDetailViewArguments>(nullOk: false);
      return _i13.MaterialPageRoute<dynamic>(
        builder:
            (context) => _i7.GroupDetailView(
              key: args.key,
              measurementId: args.measurementId,
            ),
        settings: data,
      );
    },
    _i8.AddGroupFormView: (data) {
      final args = data.getArgs<AddGroupFormViewArguments>(
        orElse: () => const AddGroupFormViewArguments(),
      );
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => _i8.AddGroupFormView(key: args.key),
        settings: data,
      );
    },
    _i9.AddMeasurementView: (data) {
      final args = data.getArgs<AddMeasurementViewArguments>(nullOk: false);
      return _i13.MaterialPageRoute<dynamic>(
        builder:
            (context) => _i9.AddMeasurementView(
              key: args.key,
              groupId: args.groupId,
              existing: args.existing,
            ),
        settings: data,
      );
    },
    _i10.ItemDetailView: (data) {
      final args = data.getArgs<ItemDetailViewArguments>(nullOk: false);
      return _i13.MaterialPageRoute<dynamic>(
        builder:
            (context) => _i10.ItemDetailView(
              key: args.key,
              measurementId: args.measurementId,
            ),
        settings: data,
      );
    },
    _i11.BodyPartDetailView: (data) {
      final args = data.getArgs<BodyPartDetailViewArguments>(nullOk: false);
      return _i13.MaterialPageRoute<dynamic>(
        builder:
            (context) =>
                _i11.BodyPartDetailView(key: args.key, partKey: args.partKey),
        settings: data,
      );
    },
    _i12.ProfileView: (data) {
      final args = data.getArgs<ProfileViewArguments>(
        orElse: () => const ProfileViewArguments(),
      );
      return _i13.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.ProfileView(key: args.key),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class StartupViewArguments {
  const StartupViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant StartupViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LockViewArguments {
  const LockViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LockViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class UpdateRequiredViewArguments {
  const UpdateRequiredViewArguments({required this.info, this.key});

  final _i15.UpdateInfo info;

  final _i14.Key? key;

  @override
  String toString() {
    return '{"info": "$info", "key": "$key"}';
  }

  @override
  bool operator ==(covariant UpdateRequiredViewArguments other) {
    if (identical(this, other)) return true;
    return other.info == info && other.key == key;
  }

  @override
  int get hashCode {
    return info.hashCode ^ key.hashCode;
  }
}

class RootViewArguments {
  const RootViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant RootViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class GroupDetailViewArguments {
  const GroupDetailViewArguments({this.key, required this.measurementId});

  final _i14.Key? key;

  final String measurementId;

  @override
  String toString() {
    return '{"key": "$key", "measurementId": "$measurementId"}';
  }

  @override
  bool operator ==(covariant GroupDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.measurementId == measurementId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ measurementId.hashCode;
  }
}

class AddGroupFormViewArguments {
  const AddGroupFormViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant AddGroupFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AddMeasurementViewArguments {
  const AddMeasurementViewArguments({
    this.key,
    required this.groupId,
    this.existing,
  });

  final _i14.Key? key;

  final String groupId;

  final _i16.Measurement? existing;

  @override
  String toString() {
    return '{"key": "$key", "groupId": "$groupId", "existing": "$existing"}';
  }

  @override
  bool operator ==(covariant AddMeasurementViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.groupId == groupId &&
        other.existing == existing;
  }

  @override
  int get hashCode {
    return key.hashCode ^ groupId.hashCode ^ existing.hashCode;
  }
}

class ItemDetailViewArguments {
  const ItemDetailViewArguments({this.key, required this.measurementId});

  final _i14.Key? key;

  final String measurementId;

  @override
  String toString() {
    return '{"key": "$key", "measurementId": "$measurementId"}';
  }

  @override
  bool operator ==(covariant ItemDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.measurementId == measurementId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ measurementId.hashCode;
  }
}

class BodyPartDetailViewArguments {
  const BodyPartDetailViewArguments({this.key, required this.partKey});

  final _i14.Key? key;

  final String partKey;

  @override
  String toString() {
    return '{"key": "$key", "partKey": "$partKey"}';
  }

  @override
  bool operator ==(covariant BodyPartDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.partKey == partKey;
  }

  @override
  int get hashCode {
    return key.hashCode ^ partKey.hashCode;
  }
}

class ProfileViewArguments {
  const ProfileViewArguments({this.key});

  final _i14.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ProfileViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

extension NavigatorStateExtension on _i17.NavigationService {
  Future<dynamic> navigateToStartupView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.startupView,
      arguments: StartupViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLoginView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLockView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.lockView,
      arguments: LockViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToUpdateRequiredView({
    required _i15.UpdateInfo info,
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.updateRequiredView,
      arguments: UpdateRequiredViewArguments(info: info, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToRootView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.rootView,
      arguments: RootViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToGroupDetailView({
    _i14.Key? key,
    required String measurementId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.groupDetailView,
      arguments: GroupDetailViewArguments(
        key: key,
        measurementId: measurementId,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddGroupFormView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addGroupFormView,
      arguments: AddGroupFormViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddMeasurementView({
    _i14.Key? key,
    required String groupId,
    _i16.Measurement? existing,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.addMeasurementView,
      arguments: AddMeasurementViewArguments(
        key: key,
        groupId: groupId,
        existing: existing,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToItemDetailView({
    _i14.Key? key,
    required String measurementId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.itemDetailView,
      arguments: ItemDetailViewArguments(
        key: key,
        measurementId: measurementId,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToBodyPartDetailView({
    _i14.Key? key,
    required String partKey,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.bodyPartDetailView,
      arguments: BodyPartDetailViewArguments(key: key, partKey: partKey),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToProfileView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.profileView,
      arguments: ProfileViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithStartupView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.startupView,
      arguments: StartupViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLoginView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLockView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.lockView,
      arguments: LockViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithUpdateRequiredView({
    required _i15.UpdateInfo info,
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.updateRequiredView,
      arguments: UpdateRequiredViewArguments(info: info, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithRootView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.rootView,
      arguments: RootViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithGroupDetailView({
    _i14.Key? key,
    required String measurementId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.groupDetailView,
      arguments: GroupDetailViewArguments(
        key: key,
        measurementId: measurementId,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddGroupFormView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addGroupFormView,
      arguments: AddGroupFormViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAddMeasurementView({
    _i14.Key? key,
    required String groupId,
    _i16.Measurement? existing,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.addMeasurementView,
      arguments: AddMeasurementViewArguments(
        key: key,
        groupId: groupId,
        existing: existing,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithItemDetailView({
    _i14.Key? key,
    required String measurementId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.itemDetailView,
      arguments: ItemDetailViewArguments(
        key: key,
        measurementId: measurementId,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithBodyPartDetailView({
    _i14.Key? key,
    required String partKey,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.bodyPartDetailView,
      arguments: BodyPartDetailViewArguments(key: key, partKey: partKey),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithProfileView({
    _i14.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.profileView,
      arguments: ProfileViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
