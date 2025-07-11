// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i7;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i8;
import 'package:true_size/ui/views/add_measurement/add_measurement_view.dart'
    as _i6;
import 'package:true_size/ui/views/home/home_view.dart' as _i4;
import 'package:true_size/ui/views/login/login_view.dart' as _i3;
import 'package:true_size/ui/views/measurement_detail/measurement_detail_view.dart'
    as _i5;
import 'package:true_size/ui/views/startup/startup_view.dart' as _i2;

class Routes {
  static const startupView = '/';

  static const loginView = '/login';

  static const homeView = '/home';

  static const measurementDetailView = '/measurement';

  static const addMeasurementView = '/add-measurement';

  static const all = <String>{
    startupView,
    loginView,
    homeView,
    measurementDetailView,
    addMeasurementView,
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
      Routes.homeView,
      page: _i4.HomeView,
    ),
    _i1.RouteDef(
      Routes.measurementDetailView,
      page: _i5.MeasurementDetailView,
    ),
    _i1.RouteDef(
      Routes.addMeasurementView,
      page: _i6.AddMeasurementView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.StartupView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.StartupView(),
        settings: data,
      );
    },
    _i3.LoginView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.LoginView(),
        settings: data,
      );
    },
    _i4.HomeView: (data) {
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.HomeView(),
        settings: data,
      );
    },
    _i5.MeasurementDetailView: (data) {
      final args = data.getArgs<MeasurementDetailViewArguments>(nullOk: false);
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.MeasurementDetailView(
            key: args.key, measurementId: args.measurementId),
        settings: data,
      );
    },
    _i6.AddMeasurementView: (data) {
      final args = data.getArgs<AddMeasurementViewArguments>(
        orElse: () => const AddMeasurementViewArguments(),
      );
      return _i7.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.AddMeasurementView(
            key: args.key, measurementId: args.measurementId),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class MeasurementDetailViewArguments {
  const MeasurementDetailViewArguments({
    this.key,
    required this.measurementId,
  });

  final _i7.Key? key;

  final String measurementId;

  @override
  String toString() {
    return '{"key": "$key", "measurementId": "$measurementId"}';
  }

  @override
  bool operator ==(covariant MeasurementDetailViewArguments other) {
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
    this.measurementId,
  });

  final _i7.Key? key;

  final String? measurementId;

  @override
  String toString() {
    return '{"key": "$key", "measurementId": "$measurementId"}';
  }

  @override
  bool operator ==(covariant AddMeasurementViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.measurementId == measurementId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ measurementId.hashCode;
  }
}

extension NavigatorStateExtension on _i8.NavigationService {
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

  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMeasurementDetailView({
    _i7.Key? key,
    required String measurementId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.measurementDetailView,
        arguments: MeasurementDetailViewArguments(
            key: key, measurementId: measurementId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddMeasurementView({
    _i7.Key? key,
    String? measurementId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.addMeasurementView,
        arguments:
            AddMeasurementViewArguments(key: key, measurementId: measurementId),
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

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMeasurementDetailView({
    _i7.Key? key,
    required String measurementId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.measurementDetailView,
        arguments: MeasurementDetailViewArguments(
            key: key, measurementId: measurementId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithAddMeasurementView({
    _i7.Key? key,
    String? measurementId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.addMeasurementView,
        arguments:
            AddMeasurementViewArguments(key: key, measurementId: measurementId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
