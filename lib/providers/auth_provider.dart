import 'package:flutter/material.dart';
import '../core/models/user_type.dart';

class AuthProvider extends ChangeNotifier {
  UserType _selectedUserType = UserType.none;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _email = '';
  String _password = '';
  String _name = '';
  String _phone = '';
  String? _error;

  UserType get selectedUserType => _selectedUserType;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get email => _email;
  String get password => _password;
  String get name => _name;
  String get phone => _phone;
  String? get error => _error;

  void setUserType(UserType userType) {
    _selectedUserType = userType;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  void setName(String name) {
    _name = name;
  }

  void setPhone(String phone) {
    _phone = phone;
  }

  Future<bool> login() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (_email.isNotEmpty && _password.isNotEmpty) {
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (_selectedUserType == UserType.doctor) {
        // For doctors we need email, password, name, and phone
        if (_email.isNotEmpty &&
            _password.isNotEmpty &&
            _name.isNotEmpty &&
            _phone.isNotEmpty) {
          _isLoggedIn = true;
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _error = 'Please fill all the required fields';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else if (_selectedUserType == UserType.patient) {
        // For patients we need name and phone
        if (_name.isNotEmpty && _phone.isNotEmpty) {
          _isLoggedIn = true;
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _error = 'Please fill all the required fields';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _error = 'Please select a user type';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (email.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Please enter your email';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOTP(String otp) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (otp.length == 4) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Please enter valid OTP';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _isLoggedIn = false;
    _selectedUserType = UserType.none;
    _email = '';
    _password = '';
    _name = '';
    _phone = '';
    notifyListeners();
  }
}
