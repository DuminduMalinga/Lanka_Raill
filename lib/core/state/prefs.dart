import 'package:shared_preferences/shared_preferences.dart';

/// On-device storage for user settings (language, theme, toggles, home
/// station). Loaded once in `main`; when it isn't (widget tests), reads fall
/// back to defaults and writes are ignored.
abstract final class Prefs {
  static SharedPreferences? _instance;

  static Future<void> init() async {
    try {
      _instance = await SharedPreferences.getInstance();
    } catch (_) {
      _instance = null;
    }
  }

  static String? getString(String key) => _instance?.getString(key);
  static bool? getBool(String key) => _instance?.getBool(key);
  static int? getInt(String key) => _instance?.getInt(key);

  static void setString(String key, String value) =>
      _instance?.setString(key, value);
  static void setBool(String key, bool value) => _instance?.setBool(key, value);
  static void setInt(String key, int value) => _instance?.setInt(key, value);
  static void remove(String key) => _instance?.remove(key);

  /// Whether the user has finished onboarding (signed in or chose guest), so
  /// later launches go straight to Home.
  static bool get onboarded => getBool('pref.onboarded') ?? false;
  static void markOnboarded() => setBool('pref.onboarded', true);
}
