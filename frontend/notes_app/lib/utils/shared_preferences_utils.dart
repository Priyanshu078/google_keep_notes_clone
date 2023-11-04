import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static SharedPreferences? instance;

  static Future<void> initialize() async {
    instance = await SharedPreferences.getInstance();
  }

  static Future<void> setThemeIndex({required int themeIndex}) async {
    await instance!.setInt("theme", themeIndex);
  }

  static int? getThemeIndex() {
    return instance!.getInt("theme");
  }

  static bool checkForCredentials() {
    return false;
  }

  static Future<void> setCredentials() async {}
}
