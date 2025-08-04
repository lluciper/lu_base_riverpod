import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/index.dart';
import 'utils/index.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      injector = await Dependence.initDependence(AppFlavorValue.development);
      runApp(
        UncontrolledProviderScope(
          container: injector,
          child: App(appFlavor: AppFlavorValue.development),
        ),
      );
    },
    (error, stackTrace) {
      LoggerHelper.error('$error', stackTrace: stackTrace);
    },
  );
}