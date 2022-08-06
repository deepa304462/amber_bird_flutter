// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  SharedData._();

  static Future<void> save(String data, String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<String> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key) ?? '{}';
    return value;
  }

  static void removeAppConfig() {
    remove('appConfig');
  }
}
