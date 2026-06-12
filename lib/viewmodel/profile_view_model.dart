import 'package:flutter/material.dart';
import 'dart:typed_data';

class ProfileViewModel extends ChangeNotifier {
  String _userName = 'Pengguna Muslim';
  String _email = 'user@muslimapp.com';
  String _password = 'password123';
  bool _isDarkMode = false;
  bool _isNotificationEnabled = true;
  Uint8List? _profileImageBytes;

  // Data registrasi yang tersimpan (RAM only)
  String? registeredName;
  String? registeredEmail;
  String? registeredPassword;

  String get userName => _userName;
  String get email => _email;
  String get password => _password;
  bool get isDarkMode => _isDarkMode;
  bool get isNotificationEnabled => _isNotificationEnabled;
  Uint8List? get profileImageBytes => _profileImageBytes;

  void setProfileImage(Uint8List bytes) {
    _profileImageBytes = bytes;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  bool login(String name, String password) {
    if (registeredName != null && registeredName == name && registeredPassword == password) {
      _userName = name;
      _password = password;
      notifyListeners();
      return true;
    }
    return false;
  }

  void register(String name, String email, String password) {
    registeredName = name;
    registeredEmail = email;
    registeredPassword = password;
    
    // Auto populate current state
    _userName = name;
    _email = email;
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
