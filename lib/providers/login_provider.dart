import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final _emailControllerLogin = TextEditingController();
  final _emailControllerSignUp = TextEditingController();
  final _passwordControllerLogin = TextEditingController();
  final _passwordControllerSignUp = TextEditingController();
  final _confirmControllerSignUp = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;
  bool _login = true;
  String _errorMsg = '';
  bool valid = true;
  bool valid2 = true;

  TextEditingController emailControllerL() {
    return _emailControllerLogin;
  }
  TextEditingController emailControllerS() {
    return _emailControllerSignUp;
  }
  TextEditingController passwordControllerL() {
    return _passwordControllerLogin;
  }
  TextEditingController passwordControllerS() {
    return _passwordControllerSignUp;
  }
  TextEditingController confirmControllerS() {
    return _confirmControllerSignUp;
  }
  void resetControllers() {
    _emailControllerLogin.clear();
    _emailControllerSignUp.clear();
    _passwordControllerLogin.clear();
    _passwordControllerSignUp.clear();
    _confirmControllerSignUp.clear();
  }

  bool isPasswordValid() {
    return valid;
  }

  void setPasswordValid(bool _valid) {
    valid = _valid;
    notifyListeners();
  }

  bool isConfirmValid() {
    return valid2;
  }

  void setConfirmValid(bool _valid) {
    valid2 = _valid;
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

