import 'package:flutter/material.dart';
import 'tracker_model.dart';
import 'tracker_service.dart';

/// ChangeNotifier untuk mengelola state data Daily Tracker.
/// Sesuai materi Pertemuan 5 — State Management dengan Provider.
///
/// Alur kerja:
/// fetchTrackerFromAPI() → isLoading = true → notifyListeners()
/// → TrackerService.fetchTrackerData() → data/error updated
/// → notifyListeners() → Consumer rebuild UI + trigger animasi membal
class TrackerProvider extends ChangeNotifier {
  final TrackerService _trackerService = TrackerService();

  List<TrackerModel> _trackerData = [];
  bool _isLoading = false;
  String? _trackerError;
  bool _hasTrackerFetched = false;

  // Getters untuk diakses oleh Consumer di UI
  List<TrackerModel> get trackerData => _trackerData;
  bool get isLoading => _isLoading;
  String? get trackerError => _trackerError;
  bool get hasTrackerFetched => _hasTrackerFetched;

  /// Fungsi async untuk mengambil data tracker dari API internet.
  /// Menggunakan TrackerService yang sudah ada (Pertemuan 8).
  /// Memanggil notifyListeners() setelah state berubah agar
  /// Consumer di UI otomatis membangun ulang widget.
  Future<void> fetchTrackerFromAPI() async {
    // Jangan fetch ulang jika sudah pernah berhasil
    if (_hasTrackerFetched) return;

    _isLoading = true;
    _trackerError = null;
    notifyListeners(); // Beritahu UI untuk menampilkan loading screen

    try {
      final data = await _trackerService.fetchTrackerData();
      _trackerData = data;
      _isLoading = false;
      _hasTrackerFetched = true;

      // KUNCI UTAMA: Update state dan bangun ulang UI secara efisien
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _trackerError = e.toString();
      notifyListeners();
    }
  }

  /// Fungsi untuk memaksa fetch ulang data (misalnya saat user tap "Coba Lagi")
  Future<void> refreshTracker() async {
    _hasTrackerFetched = false;
    await fetchTrackerFromAPI();
  }
}
