import 'package:shared_preferences/shared_preferences.dart';

class SharePreference {
  SharePreference(this._preferences);

  final SharedPreferences _preferences;

  String? getString(String key) => _preferences.getString(key);

  Future<bool> setString(String key, String value) =>
      _preferences.setString(key, value);
}
