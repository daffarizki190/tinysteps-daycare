import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/utils.dart';

/// ChangeNotifier untuk mengelola state autentikasi pengguna.
/// Sesuai materi Pertemuan 5 — State Management dengan Provider.
///
/// Menggantikan logika login yang sebelumnya tersebar di _LoginPageState
/// dan main.dart. Semua state login dipusatkan di sini.
class LoginProvider extends ChangeNotifier {
  static const String _baseUrl =
      'https://6a3be797e4a07f202e1627be.mockapi.io/user';

  String _userName = '';
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isLoggedIn = false;

  // Getters untuk diakses oleh Consumer di UI
  String get userName => _userName;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  /// Inisialisasi dari SharedPreferences saat app pertama kali dibuka.
  /// Dipanggil di main() sebelum runApp().
  Future<void> initFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedUserName = prefs.getString('userName');
    if (savedUserName != null && savedUserName.isNotEmpty) {
      _userName = savedUserName;
      _isLoggedIn = true;
    }
    // Tidak perlu notifyListeners() karena dipanggil sebelum widget tree dibangun
  }

  /// Fungsi login — menangani validasi, panggilan API, dan penyimpanan session.
  /// Memanggil notifyListeners() setelah setiap perubahan state.
  Future<bool> login(String email, String password) async {
    // Shortcut login untuk testing (sesuai kode asli)
    if (email == 'test' && password == 'test') {
      _errorMessage = '';
      _userName = 'Test User';
      _isLoggedIn = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', 'Test User');

      notifyListeners();
      return true;
    }

    // Validasi input
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email and password cannot be empty';
      notifyListeners();
      return false;
    } else if (!AppUtils.isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return false;
    } else if (!AppUtils.isValidPassword(password)) {
      _errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // UI menampilkan loading indicator

    try {
      final url = Uri.parse('$_baseUrl?email=$email&password=$password');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);

        if (users.isNotEmpty) {
          _userName = users[0]['name'] ?? 'Parent';
          _isLoggedIn = true;
          _isLoading = false;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userName', _userName);

          notifyListeners();
          return true;
        } else {
          _isLoading = false;
          _errorMessage = 'Invalid email or password';
          notifyListeners();
          return false;
        }
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Gagal terhubung ke internet: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout — hapus session dari SharedPreferences dan reset state.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');

    _userName = '';
    _isLoggedIn = false;
    _errorMessage = '';
    notifyListeners();
  }

  /// Reset error message (misalnya saat user mulai mengetik ulang)
  void clearError() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }
}
