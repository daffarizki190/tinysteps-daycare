import 'dart:convert';
import 'package:http/http.dart' as http;
import 'tracker_model.dart';

class TrackerService {
  static const String _baseUrl =
      'https://6a3be797e4a07f202e1627be.mockapi.io/tracker';
  Future<List<TrackerModel>> fetchTrackerData() async {
    try {
      final url = Uri.parse(_baseUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => TrackerModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Gagal mengambil data tracker. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching tracker data: $e');
    }
  }
}
