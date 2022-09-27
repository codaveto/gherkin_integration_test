import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_group_function.dart';
import 'integration_log.dart';

part 'integration_example.dart';
part 'integration_feature.dart';
part 'integration_scenario.dart';
part 'integration_step.dart';
part 'integration_box.dart';
part 'integration_mocks.dart';

/// Used to hold and test a list of [IntegrationFeature].
class IntegrationTest {
  IntegrationTest({
    required String description,
    required List<IntegrationFeature> features,
    TestGroupFunction? setUpEach,
    TestGroupFunction? tearDownEach,
    TestGroupFunction? setUpOnce,
    TestGroupFunction? tearDownOnce,
    IntegrationTestWidgetsFlutterBinding? binding,
  })  : _description = description,
        _features = features,
        _setUpEach = setUpEach,
        _tearDownEach = tearDownEach,
        _setUpOnce = setUpOnce,
        _tearDownOnce = tearDownOnce,
        _binding = binding;

  /// High-level description of the [IntegrationTest] and related [IntegrationFeature]s.
  final String _description;

  /// List of all testable features in your app.
  final List<IntegrationFeature> _features;

  /// Code that will run at the START of each [IntegrationScenario] under this [IntegrationTest]
  /// or at the START of EACH [IntegrationScenario._examples] under this [IntegrationTest].
  final TestGroupFunction? _setUpEach;

  /// Code that will run ONCE at the END of this [IntegrationScenario] under this [IntegrationTest]
  /// or ONCE at the END of EACH [IntegrationScenario._examples] under this [IntegrationTest].
  final TestGroupFunction? _tearDownEach;

  /// Code that will be run ONCE at the START of this [IntegrationTest].
  final TestGroupFunction? _setUpOnce;

  /// Code that will be run ONCE at the END of this [IntegrationTest].
  final TestGroupFunction? _tearDownOnce;

  /// The glue between the widgets layer and the Flutter engine.
  final IntegrationTestWidgetsFlutterBinding? _binding;

  /// Runs all [IntegrationTest._features] test methods.
  void test({IntegrationMocks? mocks}) {
    flutter_test.group(
      _description,
      () {
        final _mocks = mocks ?? IntegrationMocks();
        _setUpAndTeardown(mocks: _mocks);
        for (int nrFeature = 0; nrFeature < _features.length; nrFeature++) {
          _features[nrFeature].test(
            binding: _binding,
            testDescription: _description,
            nrFeature: nrFeature,
          );
        }
      },
    );
  }

  /// Runs any provided [_setUpEach], [_setUpOnce], [_tearDownEach] and [_tearDownOnce] methods.
  void _setUpAndTeardown({
    required IntegrationMocks mocks,
  }) {
    if (_setUpOnce != null) {
      flutter_test.setUpAll(() => _setUpOnce!(mocks));
    }
    if (_tearDownOnce != null) {
      flutter_test.tearDownAll(() => _tearDownOnce!(mocks));
    }
    if (_setUpEach != null) {
      flutter_test.setUp(() => _setUpEach!(mocks));
    }
    if (_tearDownEach != null) {
      flutter_test.tearDown(() => _tearDownEach!(mocks));
    }
  }
}
