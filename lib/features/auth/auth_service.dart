import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl =
      'https://6a3be797e4a07f202e1627be.mockapi.io/user';
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final url = Uri.parse(_baseUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        for (final user in users) {
          if (user['email'] == email && user['password'] == password) {
            return user as Map<String, dynamic>;
          }
        }
        return null;
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke server: $e');
    }
  }
}
