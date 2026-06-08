import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  String _userName = 'Pengguna Muslim';
  String _email = 'user@muslimapp.com';
  String _password = 'password123';
  bool _isDarkMode = false;
  bool _isNotificationEnabled = true;

  String get userName => _userName;
  String get email => _email;
  String get password => _password;
  bool get isDarkMode => _isDarkMode;
  bool get isNotificationEnabled => _isNotificationEnabled;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void toggleNotification(bool value) {
    _isNotificationEnabled = value;
    notifyListeners();
  }

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}
