import 'package:flutter/material.dart';
import 'package:proflight/service/auth/auth_service.dart';

class RegisterScreenModel extends ChangeNotifier {
  String _email = "";
  String _password = "";
  String _name = "";
  String _board = "";
  String _company = "";
  double _totalHours = 0;
  double _totalHours1 = 0;
  double _totalHours2 = 0;

  String? _errorMessage;

  int _step = 0;

  final AuthService _authService;

  RegisterScreenModel(this._authService);

  int get step => _step;
  String? get errorMessage => _errorMessage;

  void setEmail(String value) => _email = value;
  void setPassword(String value) => _password = value;
  void setName(String value) => _name = value;
  void setCompany(String value) => _company = value;
  void setBoard(String value) => _board = value;
  void setTotalHours(String value) => _totalHours = double.parse(value);
  void setTotalHours1(String value) => _totalHours1 = double.parse(value);
  void setTotalHours2(String value) => _totalHours2 = double.parse(value);

  void stepIncrement() {
    if (_step < 2) _step++;
    notifyListeners();
  }

  void stepDecrement() {
    if (step > 0) _step--;
    notifyListeners();
  }

  void setStep(int value) {
    _step = value;
    notifyListeners();
  }

  bool allowRegister() => _step >= 2;

  Future<bool> registerUser() async {
    _errorMessage = null;

    try {
      final user = await _authService.signUp(_email, _password);

      if (user == null) {
        _errorMessage = "Ошибка регистрации";
        notifyListeners();
        return false;
      }

      return true; // успех
    } catch (e) {
      _errorMessage = e.toString(); // тут можно мапить в красивый текст
      notifyListeners();
      return false;
    }
  }
}
