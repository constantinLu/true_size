// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i9;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i10;
import 'package:true_size/ui/views/add_measurement/add_group_form_view.dart'
    as _i6;
import 'package:true_size/ui/views/add_measurement/add_measurement_view.dart'
    as _i7;
import 'package:true_size/ui/views/login/login_view.dart' as _i3;
import 'package:true_size/ui/views/measurement_detail/measurement_detail_view.dart'
    as _i5;
import 'package:true_size/ui/views/profile/profile_view.dart' as _i8;
import 'package:true_size/ui/views/root/root_view.dart' as _i4;
import 'package:true_size/ui/views/startup/startup_view.dart' as _i2;

class Routes {
  static const startupView = '/';

  static const loginView = '/login';

  static const rootView = '/root';

  static const groupDetailView = '/measurement';

  static const addGroupFormView = '/add-group';

  static const addMeasurementView = '/add-measurement';

  static const profileView = '/profile';

  static const all = <String>{
    startupView,
    loginView,
    rootView,
    groupDetailView,
    addGroupFormView,
    addMeasurementView,
    profileView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.startupView,
      page: _i2.StartupView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i3.LoginView,
    ),
    _i1.RouteDef(
      Routes.rootView,
      page: _i4.RootView,
    ),
    _i1.RouteDef(
      Routes.groupDetailView,
      page: _i5.GroupDetailView,
    ),
    _i1.RouteDef(
      Routes.addGroupFormView,
      page: _i6.AddGroupFormView,
    ),
    _i1.RouteDef(
      Routes.addMeasurementView,
      page: _i7.AddMeasurementView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i8.ProfileView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.StartupView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.StartupView(),
        settings: data,
      );
    },
    _i3.LoginView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.LoginView(),
        settings: data,
      );
    },
    _i4.RootView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.RootView(),
        settings: data,
      );
    },
    _i5.GroupDetailView: (data) {
      final args = data.getArgs<GroupDetailViewArguments>(nullOk: false);
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.GroupDetailView(
            key: args.key, measurementId: args.measurementId),
        settings: data,
      );
    },
    _i6.AddGroupFormView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.AddGroupFormView(),
        settings: data,
      );
    },
    _i7.AddMeasurementView: (data) {
      final args = data.getArgs<AddMeasurementViewArguments>(nullOk: false);
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i7.AddMeasurementView(key: args.key, groupId: args.groupId),
        settings: data,
      );
    },
    _i8.ProfileView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.ProfileView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class GroupDetailViewArguments {
  const GroupDetailViewArguments({
    this.key,
    required this.measurementId,
  });

  final _i9.Key? key;

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

class AddMeasurementViewArguments {
  const AddMeasurementViewArguments({
    this.key,
    required this.groupId,
  });

  final _i9.Key? key;

  final String groupId;

  @override
  String toString() {
    return '{"key": "$key", "groupId": "$groupId"}';
  }

  @override
  bool operator ==(covariant AddMeasurementViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.groupId == groupId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ groupId.hashCode;
  }
}

extension NavigatorStateExtension on _i10.NavigationService {
  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRootView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.rootView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToGroupDetailView({
    _i9.Key? key,
    required String measurementId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.groupDetailView,
        arguments:
            GroupDetailViewArguments(key: key, measurementId: measurementId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddGroupFormView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addGroupFormView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddMeasurementView({
    _i9.Key? key,
    required String groupId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.addMeasurementView,
        arguments: AddMeasurementViewArguments(key: key, groupId: groupId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRootView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.rootView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithGroupDetailView({
    _i9.Key? key,
    required String measurementId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.groupDetailView,
        arguments:
            GroupDetailViewArguments(key: key, measurementId: measurementId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddGroupFormView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.addGroupFormView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddMeasurementView({
    _i9.Key? key,
    required String groupId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.addMeasurementView,
        arguments: AddMeasurementViewArguments(key: key, groupId: groupId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
