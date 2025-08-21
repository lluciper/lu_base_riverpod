import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'local_storage_key.dart';

final secureStorageProvider = Provider<SecureStorage>(
  (ref) => throw UnimplementedError('secureStorageProvider must be overridden'),
);

/// LocalAuthStorage centralizes all auth-related token persistence.
class SecureStorage {
  const SecureStorage(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  Future<String?> getString(String key) => _secureStorage.read(key: key);

  Future<bool> setString(String key, String value) async {
    bool isOk = false;
    await _secureStorage
        .write(key: key, value: value)
        .onError((error, stackTrace) {
          isOk = false;
        })
        .then((value) {
          isOk = true;
        });
    return isOk;
  }

  Future<bool> saveAccessToken(String token) =>
      setString(LocalStorageKey.accessToken, token);

  Future<String?> getAccessToken() => getString(LocalStorageKey.accessToken);

  Future<bool> clearAccessToken() async {
    await setString(LocalStorageKey.accessToken, '');
    return true;
  }
}
