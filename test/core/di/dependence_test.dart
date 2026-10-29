import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubaseriverpod/core/index.dart';
import 'package:lubaseriverpod/data/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const storage = FlutterSecureStorage();

  Future<void> init() async {
    final container = await Dependence.initDependence(
      AppFlavorValue.development,
    );
    addTearDown(container.dispose);
  }

  test(
    'first launch of an install clears tokens of a previous install',
    () async {
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({
        LocalStorageKey.accessToken: 'stale',
        LocalStorageKey.refreshToken: 'stale',
      });

      await init();

      expect(await storage.read(key: LocalStorageKey.accessToken), isNull);
      expect(await storage.read(key: LocalStorageKey.refreshToken), isNull);
    },
  );

  test('later launches keep the tokens', () async {
    SharedPreferences.setMockInitialValues({LocalStorageKey.installed: '1'});
    FlutterSecureStorage.setMockInitialValues({
      LocalStorageKey.accessToken: 'valid',
    });

    await init();

    expect(await storage.read(key: LocalStorageKey.accessToken), 'valid');
  });

  test('only development logs in without a backend', () async {
    SharedPreferences.setMockInitialValues({LocalStorageKey.installed: '1'});
    FlutterSecureStorage.setMockInitialValues({});

    for (final (flavor, demo) in [
      (AppFlavorValue.development, true),
      (AppFlavorValue.staging, false),
      (AppFlavorValue.production, false),
    ]) {
      final container = await Dependence.initDependence(flavor);
      addTearDown(container.dispose);
      expect(
        container.read(repositoryProvider).auth is DemoAuthRepository,
        demo,
        reason: '${flavor.appFlavorType}',
      );
    }
  });
}
