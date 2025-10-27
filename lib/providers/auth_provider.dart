import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Signup method
  Future<String?> signUp(String username, String email, String password) async {
    final exists = await _dbHelper.userExists(email);
    if (exists) {
      return "User with this email already exists.";
    }

    final user = User(username: username, email: email, password: password);
    await _dbHelper.insertUser(user);
    _currentUser = user;
    notifyListeners();
    return null; // means success
  }

  // Login method
  Future<User?> login(String email, String password) async {
  final user = await _dbHelper.getUser(email, password);
  if (user != null) {
    _currentUser = user;
    notifyListeners();
  }
  return user; // returns User if login succeeds, null if fails
}

  // Logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
