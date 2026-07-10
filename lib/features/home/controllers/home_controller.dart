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

  Future<void> fetchActivities() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Only take the first 10 for display
        _activities = data.take(10).map((json) => ActivityModel.fromJson(json)).toList();
      } else {
        _errorMessage = 'Failed to load activities. Status code: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'An error occurred while fetching activities.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
