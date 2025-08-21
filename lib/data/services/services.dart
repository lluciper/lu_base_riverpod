// ignore_for_file: unused_field

import 'http_client/dio_client.dart';
import 'local_storage/share_preference.dart';
import 'local_storage/secure_storage.dart';

class Services {
  Services(this.dio, this.sharedPreference, this.secureStorage);

  final DioClient dio;
  final SharePreference sharedPreference;
  final SecureStorage secureStorage;
}
