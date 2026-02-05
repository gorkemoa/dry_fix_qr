import 'package:shared_preferences/shared_preferences.dart';

class StorageManager {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  static Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Auth specific
  static const String _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    await setString(_tokenKey, token);
  }

  static String? getToken() {
    return getString(_tokenKey);
  }

  static Future<void> deleteToken() async {
    await remove(_tokenKey);
  }
}
