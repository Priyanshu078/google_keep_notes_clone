import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static SharedPreferences? instance;
  static String? imageUrl;
  static String? name;
  static String? email;

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
    imageUrl = instance!.getString("imageUrl");
    name = instance!.getString("name");
    email = instance!.getString("email");
    return ((imageUrl != null) && (name != null) && (email != null));
  }

  static Future<void> clearData() async {
    await instance!.remove("imageUrl");
    imageUrl = null;
    await instance!.remove("name");
    name = null;
    await instance!.remove("email");
    email = null;
  }

  static Future<void> setCredentials(
      String name, String email, String imageUrl) async {
    await instance!.setString("name", name);
    await instance!.setString("email", email);
    await instance!.setString("imageUrl", imageUrl);
  }
}
