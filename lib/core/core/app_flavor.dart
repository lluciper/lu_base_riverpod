import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_flavor.g.dart';

@riverpod
AppFlavor appFlavor(Ref ref) =>
    AppFlavor(appFlavorType: AppFlavorType.development, baseUrl: '');

enum AppFlavorType { development, production }

class AppFlavor {
  AppFlavor({required this.appFlavorType, required this.baseUrl});

  final AppFlavorType appFlavorType;
  final String baseUrl;
}

class AppFlavorValue {
  static final AppFlavor development = AppFlavor(
    appFlavorType: AppFlavorType.development,
    baseUrl: 'https://ApiConstants.devBaseUrl',
  );

  static final AppFlavor production = AppFlavor(
    appFlavorType: AppFlavorType.production,
    baseUrl: 'https://ApiConstants.prodBaseUrl',
  );
}
