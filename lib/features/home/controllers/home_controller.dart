import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/activity_model.dart';

class HomeController extends ChangeNotifier {
  List<ActivityModel> _activities = [];
  List<ActivityModel> get activities => _activities;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchActivities({String langCode = 'en'}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (langCode == 'id') {
        _activities = [
          ActivityModel(
            id: 1,
            title: 'Makan sarapan yang enak',
            body: 'Makan pancake dan minum segelas susu. Sangat senang dan energik setelahnya!',
          ),
          ActivityModel(
            id: 2,
            title: 'Waktu bermain pagi',
            body: 'Bermain dengan balok susun dan berbagi mainan dengan teman-teman. Menunjukkan kerja sama yang baik.',
          ),
          ActivityModel(
            id: 3,
            title: 'Sesi Seni & Keterampilan',
            body: 'Melukis gambar matahari dan pepohonan yang indah. Sangat suka mencampur warna-warna tersebut.',
          ),
          ActivityModel(
            id: 4,
            title: 'Waktu makan siang',
            body: 'Menghabiskan semua sayuran dan ayam. Meminta tambahan salad buah.',
          ),
          ActivityModel(
            id: 5,
            title: 'Waktu tidur siang',
            body: 'Tidur dengan nyenyak selama 1,5 jam. Bangun dengan segar dan siap untuk kegiatan sore hari.',
          ),
        ];
      } else {
        _activities = [
          ActivityModel(
            id: 1,
            title: 'Had a great breakfast',
            body: 'Ate pancakes and drank a glass of milk. Was very happy and energetic afterwards!',
          ),
          ActivityModel(
            id: 2,
            title: 'Morning playtime',
            body: 'Played with building blocks and shared toys with friends. Showed great cooperation.',
          ),
          ActivityModel(
            id: 3,
            title: 'Art & Craft session',
            body: 'Painted a beautiful picture of a sun and trees. Loved mixing the colors together.',
          ),
          ActivityModel(
            id: 4,
            title: 'Lunch time',
            body: 'Ate all the vegetables and chicken. Asked for a second serving of fruit salad.',
          ),
          ActivityModel(
            id: 5,
            title: 'Nap time',
            body: 'Slept peacefully for 1.5 hours. Woke up refreshed and ready for the afternoon activities.',
          ),
        ];
      }
    } catch (e) {
      _errorMessage = 'An error occurred while fetching activities.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
