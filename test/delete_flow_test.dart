import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:true_size/app/app.locator.dart';
import 'package:true_size/core/enums/unit.dart';
import 'package:true_size/core/models/measurement.dart';
import 'package:true_size/core/models/measurement_size.dart';
import 'package:true_size/core/models/unit_option.dart';
import 'package:true_size/services/firestore_service.dart';
import 'package:true_size/services/group_service.dart';
import 'package:true_size/services/local_deletion_service.dart';
import 'package:true_size/services/measurement_service.dart';
import 'package:true_size/ui/views/item_detail/item_detail_viewmodel.dart';
import 'package:true_size/ui/views/measurement_detail/measurement_detail_viewmodel.dart';

class _MockFirestore extends Mock implements FirestoreService {}

class _MockMeasurements extends Mock implements MeasurementService {}

class _MockGroups extends Mock implements GroupService {}

class _MockNav extends Mock implements NavigationService {}

Measurement _m(String id, {String groupId = 'g1'}) => Measurement(
      id: id,
      icon: 'ruler',
      name: id,
      sizes: [MeasurementSize(value: '1', unit: UnitOption.fromBuiltin(Unit.cm))],
      groupId: groupId,
      createdAt: DateTime(2020),
    );

/// A navigation call that never resolves - the app's `clearStackAndShow` to the
/// root route behaves like this (its future only completes when root is popped,
/// which never happens). The delete must not depend on it.
Future<dynamic> _neverCompletes() => Completer<dynamic>().future;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockFirestore firestore;
  late _MockMeasurements measurements;
  late _MockGroups groups;
  late _MockNav nav;
  late LocalDeletionService deletions;

  setUp(() {
    locator.reset();
    firestore = _MockFirestore();
    measurements = _MockMeasurements();
    groups = _MockGroups();
    nav = _MockNav();
    deletions = LocalDeletionService();
    locator
      ..registerSingleton<FirestoreService>(firestore)
      ..registerSingleton<MeasurementService>(measurements)
      ..registerSingleton<GroupService>(groups)
      ..registerSingleton<NavigationService>(nav)
      ..registerSingleton<LocalDeletionService>(deletions)
      ..registerSingleton<SnackbarService>(SnackbarService());
  });

  tearDown(() => locator.reset());

  group('Group delete', () {
    test('removes the group and all its measurements from Firestore', () async {
      when(() => nav.clearStackAndShow(any())).thenAnswer((_) async => null);
      when(() => measurements.getByGroupId('g1'))
          .thenAnswer((_) async => [_m('m1'), _m('m2')]);
      when(() => measurements.delete(any())).thenAnswer((_) async {});
      when(() => firestore.deleteGroup(any())).thenAnswer((_) async {});

      await GroupDetailViewModel(groupId: 'g1').deleteGroup();

      verify(() => firestore.deleteGroup('g1')).called(1);
      verify(() => measurements.delete('m1')).called(1);
      verify(() => measurements.delete('m2')).called(1);
      expect(deletions.isGroupHidden('g1'), isTrue);
    });

    test('still deletes from Firestore when navigation never completes '
        '(regression for the optimistic-delete bug)', () async {
      when(() => nav.clearStackAndShow(any())).thenAnswer((_) => _neverCompletes());
      when(() => measurements.getByGroupId('g1')).thenAnswer((_) async => const []);
      when(() => firestore.deleteGroup(any())).thenAnswer((_) async {});

      await GroupDetailViewModel(groupId: 'g1')
          .deleteGroup()
          .timeout(const Duration(seconds: 3));

      verify(() => firestore.deleteGroup('g1')).called(1);
    });

    test('rolls back the optimistic hide when the delete fails', () async {
      when(() => nav.clearStackAndShow(any())).thenAnswer((_) async => null);
      when(() => measurements.getByGroupId('g1')).thenAnswer((_) async => const []);
      when(() => firestore.deleteGroup(any())).thenThrow(Exception('network'));

      await GroupDetailViewModel(groupId: 'g1').deleteGroup();

      expect(deletions.isGroupHidden('g1'), isFalse);
    });
  });

  group('Measurement delete', () {
    test('removes the measurement from Firestore', () async {
      when(() => nav.clearStackAndShow(any())).thenAnswer((_) async => null);
      when(() => measurements.delete(any())).thenAnswer((_) async {});
      when(() => groups.touch(any())).thenAnswer((_) async {});

      await ItemDetailViewModel(measurementId: 'm1').deleteMeasurement(_m('m1'));

      verify(() => measurements.delete('m1')).called(1);
      verify(() => groups.touch('g1')).called(1);
      expect(deletions.isMeasurementHidden('m1'), isTrue);
    });

    test('still deletes when navigation never completes (regression)', () async {
      when(() => nav.clearStackAndShow(any())).thenAnswer((_) => _neverCompletes());
      when(() => measurements.delete(any())).thenAnswer((_) async {});
      when(() => groups.touch(any())).thenAnswer((_) async {});

      await ItemDetailViewModel(measurementId: 'm1')
          .deleteMeasurement(_m('m1'))
          .timeout(const Duration(seconds: 3));

      verify(() => measurements.delete('m1')).called(1);
    });
  });
}
