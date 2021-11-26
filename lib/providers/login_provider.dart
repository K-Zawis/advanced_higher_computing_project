import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;
  bool _login = true;
  String _errorMsg = '';
  bool error = false;
  bool error2 = false;

  bool isPasswordValid() {
    return !error;
  }

  void setPasswordValid(bool valid) {
    error = !valid;
    notifyListeners();
  }

  bool isConfirmValid() {
    return !error2;
  }

  void setConfirmValid(bool valid) {
    error2 = !valid;
    notifyListeners();
  }

  bool isPasswordVisible() {
    return _isPasswordVisible;
  }

  void setPasswordVisible() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  bool isConfirmPasswordVisible() {
    return _isPasswordConfirmVisible;
  }

  void setConfirmPasswordVisible() {
    _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
    notifyListeners();
  }

  bool isLogin() {
    return _login;
  }

  void setIsLogin() {
    _login = !_login;
    notifyListeners();
  }

  String errorMessage() {
    return _errorMsg;
  }

  void setErrorMessage(String e) {
    _errorMsg = e;
    notifyListeners();
  }
}

