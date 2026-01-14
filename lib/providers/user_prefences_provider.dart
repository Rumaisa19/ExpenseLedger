import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserPreferencesProvider extends ChangeNotifier {
  // 1. Change late to nullable for safety
  Box? _userBox;

  // Default values
  String _userName = 'John Doe';
  String _userEmail = 'john.doe@example.com';
  bool _notificationsEnabled = true;
  bool _dailyReminders = true;

  // Getters
  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get dailyReminders => _dailyReminders;

  UserPreferencesProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      if (Hive.isBoxOpen('userBox')) {
        _userBox = Hive.box('userBox');
      } else {
        _userBox = await Hive.openBox('userBox');
      }

      // 2. Access box with null-safety
      if (_userBox != null) {
        _userName = _userBox!.get('user_name', defaultValue: 'John Doe');
        _userEmail = _userBox!.get(
          'user_email',
          defaultValue: 'john.doe@example.com',
        );
        _notificationsEnabled = _userBox!.get(
          'notifications_enabled',
          defaultValue: true,
        );
        _dailyReminders = _userBox!.get('daily_reminders', defaultValue: true);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Hive Initialization Error: $e");
    }
  }

  // Helper method to ensure box is ready
  bool _isBoxReady() => _userBox != null && _userBox!.isOpen;

  // Update user profile
  void updateUserProfile(String name, String email) {
    _userName = name;
    _userEmail = email;

    if (_isBoxReady()) {
      _userBox!.put('user_name', name);
      _userBox!.put('user_email', email);
    }
    notifyListeners();
  }

  // Toggle notifications
  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    if (_isBoxReady()) {
      _userBox!.put('notifications_enabled', value);
    }
    notifyListeners();
  }

  // Toggle daily reminders
  void toggleDailyReminders(bool value) {
    _dailyReminders = value;
    if (_isBoxReady()) {
      _userBox!.put('daily_reminders', value);
    }
    notifyListeners();
  }

  // Clear all data (for logout)
  Future<void> clearAllData() async {
    // 3. Check if box is ready before clearing
    if (_isBoxReady()) {
      await _userBox!.clear();
    }

    // Reset to defaults in memory
    _userName = 'John Doe';
    _userEmail = 'john.doe@example.com';
    _notificationsEnabled = true;
    _dailyReminders = true;
    notifyListeners();
  }
}
