import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginProvider extends ChangeNotifier {
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;
  bool _login = true;
  String _errorMsg = '';

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

