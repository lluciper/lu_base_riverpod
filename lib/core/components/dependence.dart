import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/index.dart';
import '../index.dart';

var injector = ProviderContainer();

class Dependence {
  static Future<ProviderContainer> initDependence(AppFlavor appFlavor) async {
    final appLifecycle = AppLifecycle();

    final sharedPreference = SharePreference(
      await SharedPreferences.getInstance(),
    );

    final dioClient = DioClient(
      Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        ),
      )..interceptors.addAll([DioInterceptor(), LogInterceptor()]),
      baseUrl: appFlavor.baseUrl,
    );

    final secureStorage = SecureStorage(const FlutterSecureStorage());

    // ignore: join_return_with_assignment
    return ProviderContainer(
      overrides: [
        appFlavorProvider.overrideWithValue(appFlavor),

        appLifecycleProvider.overrideWithValue(appLifecycle),

        repositoryProvider.overrideWithValue(
          Repository(Services(dioClient, sharedPreference, secureStorage)),
        ),
        secureStorageProvider.overrideWithValue(secureStorage),
      ],
    );
  }
}
