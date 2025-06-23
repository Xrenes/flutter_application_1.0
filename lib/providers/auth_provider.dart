import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserType { student, teacher }

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  UserType? _userType;
  String? _email;

  bool get isLoggedIn => _isLoggedIn;
  UserType? get userType => _userType;
  String? get email => _email;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userTypeString = prefs.getString('userType');
    _userType = userTypeString == 'student'
        ? UserType.student
        : userTypeString == 'teacher'
        ? UserType.teacher
        : null;
    _email = prefs.getString('email');
    notifyListeners();
  }

  Future<bool> login(String email, String password, UserType userType) async {
    // Validate email domain
    if (!email.endsWith('@diu.edu.bd')) {
      return false;
    }

    // Simple validation - in real app, you'd validate with backend
    if (password.length >= 6) {
      _isLoggedIn = true;
      _userType = userType;
      _email = email;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userType', userType.name);
      await prefs.setString('email', email);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userType = null;
    _email = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userType');
    await prefs.remove('email');

    notifyListeners();
  }
}
