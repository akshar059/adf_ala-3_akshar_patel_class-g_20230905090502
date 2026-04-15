import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const key = "isDark";

  static Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<void> setTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}
