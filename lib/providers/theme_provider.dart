import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  late Box _settingBox;
  // Initialize with a default value to avoid null errors before Hive loads
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _initHive();
  }

  // Use Hive to store theme settings instead of SharedPreferences
  Future<void> _initHive() async {
    // Check if open to prevent "Box already open" exceptions
    if (Hive.isBoxOpen('settings')) {
      _settingBox = Hive.box('settings');
    } else {
      _settingBox = await Hive.openBox('settings');
    }

    final savedTheme = _settingBox.get('themeMode', defaultValue: 'system');
    _themeMode = _mapStringToThemeMode(savedTheme);
    notifyListeners();
  }

  // Toggle between light and dark mode
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _settingBox.put('themeMode', isDark ? 'dark' : 'light');
    notifyListeners();
  }

  // Set specific theme mode (System, Light, or Dark)
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    String modeString = 'system';
    if (mode == ThemeMode.light) modeString = 'light';
    if (mode == ThemeMode.dark) modeString = 'dark';

    _settingBox.put('themeMode', modeString);
    notifyListeners();
  }

  // Helper to convert saved String back to ThemeMode
  ThemeMode _mapStringToThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
