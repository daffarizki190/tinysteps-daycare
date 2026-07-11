import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  LanguageProvider(String savedLanguage) {
    _currentLanguage = savedLanguage;
  }

  Future<void> setLanguage(String lang) async {
    if (lang != _currentLanguage) {
      _currentLanguage = lang;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', lang);
    }
  }

  void toggleLanguage() {
    setLanguage(_currentLanguage == 'en' ? 'id' : 'en');
  }

  // Simple dictionary mapping
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'Live Camera': 'Live Camera',
      'Daily Tracker': 'Daily Tracker',
      'Photos': 'Photos',
      'Messages': 'Messages',
      'Profile': 'Profile',
      'Home': 'Home',
      'Tracker': 'Tracker',
      'Today': 'Today',
      'Classroom A': 'Classroom A',
      'Classroom B': 'Classroom B',
      'Playground': 'Playground',
      'Ate well': 'Ate well',
      'Hello, Parents!': 'Hello, Parents!',
      'Sign in to stay connected with your little one\'s day.': 'Sign in to stay connected with your little one\'s day.',
      'Email': 'Email',
      'Password': 'Password',
      'Forgot Password?': 'Forgot Password?',
      'Sign In': 'Sign In',
      'OR': 'OR',
      'Login with Biometrics': 'Login with Biometrics',
      'Or sign in with': 'Or sign in with',
      'Don\'t have an account?': 'Don\'t have an account?',
      'Sign Up': 'Sign Up',
      'Welcome back, Sarah! Liam is having a great day.': 'Welcome back, Sarah! Liam is having a great day.',
      'No activities yet.': 'No activities yet.',
    },
    'id': {
      'Live Camera': 'Kamera Langsung',
      'Daily Tracker': 'Pelacak Harian',
      'Photos': 'Foto',
      'Messages': 'Pesan',
      'Profile': 'Profil',
      'Home': 'Beranda',
      'Tracker': 'Pelacak',
      'Today': 'Hari ini',
      'Classroom A': 'Kelas A',
      'Classroom B': 'Kelas B',
      'Playground': 'Taman Bermain',
      'Ate well': 'Makan lahap',
      'Hello, Parents!': 'Halo, Orang Tua!',
      'Sign in to stay connected with your little one\'s day.': 'Masuk untuk tetap terhubung dengan hari si kecil.',
      'Email': 'Email',
      'Password': 'Kata Sandi',
      'Forgot Password?': 'Lupa Kata Sandi?',
      'Sign In': 'Masuk',
      'OR': 'ATAU',
      'Login with Biometrics': 'Masuk dengan Biometrik',
      'Or sign in with': 'Atau masuk dengan',
      'Don\'t have an account?': 'Belum punya akun?',
      'Sign Up': 'Daftar',
      'Welcome back, Sarah! Liam is having a great day.': 'Selamat datang, Sarah! Liam mengalami hari yang menyenangkan.',
      'No activities yet.': 'Belum ada aktivitas.',
    }
  };

  String t(String key) {
    return _translations[_currentLanguage]?[key] ?? key;
  }
}
