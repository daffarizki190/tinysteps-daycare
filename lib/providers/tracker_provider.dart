import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../database/database_helper.dart';

/// TrackerProvider — Menangani pengambilan data aktivitas harian
/// dari SQLite secara asinkron.
class TrackerProvider extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────
  List<ActivityModel> _activities = [];
  List<ActivityModel> get activities => _activities;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // ── Fetch Data ─────────────────────────────────────────────
  /// Mengambil data aktivitas dari database SQLite.
  /// Membatasi hasil ke 8 item terbaru.
  Future<void> fetchTrackerFromAPI() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _activities = await DatabaseHelper.instance.getActivities();
    } catch (e) {
      _errorMessage = 'Database error. Pull down to retry.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
