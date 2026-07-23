import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../database/database_helper.dart';

/// AuthProvider — Menangani login, register, dan logout.
/// Menyimpan session menggunakan FlutterSecureStorage.
/// Menampilkan notifikasi lokal saat login/register berhasil.
class AuthProvider extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _userName = 'Parents';
  String get userName => _userName;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // ── Dependencies ───────────────────────────────────────────
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ── Constructor ────────────────────────────────────────────
  AuthProvider() {
    if (!kIsWeb) {
      _initNotifications();
    }
  }

  /// Inisialisasi plugin notifikasi lokal (skip di web)
  Future<void> _initNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initSettings);
  }

  /// Menampilkan notifikasi lokal (skip di web)
  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return; // Tidak didukung sempurna di web tanpa setup
    
    const androidDetails = AndroidNotificationDetails(
      'tinysteps_channel',
      'TinySteps Notifications',
      channelDescription: 'Notifikasi dari aplikasi TinySteps Day Care',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    const details = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  // ── Login ──────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final user = await DatabaseHelper.instance.loginUser(email, password);

      if (user != null) {
        _userName = user['name'] ?? 'Parents';
        _isLoggedIn = true;

        await _secureStorage.write(key: 'session', value: 'logged_in');
        await _secureStorage.write(key: 'user_name', value: _userName);

        _isLoading = false;
        notifyListeners();

        await _showNotification(
          title: 'Login Successful ✅',
          body: 'Welcome back, $_userName!',
        );

        return true;
      }

      _errorMessage = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Database error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Register ───────────────────────────────────────────────
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final id = await DatabaseHelper.instance.registerUser(name, email, password);

      if (id != -1) {
        _isLoading = false;
        notifyListeners();

        await _showNotification(
          title: 'Registration Successful 🎉',
          body: 'Your account has been registered. Please login!',
        );

        return true;
      } else {
        _errorMessage = 'Registration failed. Email might already exist.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Database error. Email might already exist.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Logout ─────────────────────────────────────────────────
  Future<void> logout() async {
    await _secureStorage.delete(key: 'session');
    await _secureStorage.delete(key: 'user_name');
    _isLoggedIn = false;
    _userName = 'Parents';
    notifyListeners();
  }

  // ── Restore Session ────────────────────────────────────────
  Future<void> restoreSession() async {
    final savedName = await _secureStorage.read(key: 'user_name');
    if (savedName != null && savedName.isNotEmpty) {
      _userName = savedName;
      _isLoggedIn = true;
      notifyListeners();
    }
  }
}
