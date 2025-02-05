import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String baseUrl = 'https://petsup.online/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = await _getToken();
    if (token == null) throw Exception('No auth token found');

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Profile Response: ${response.body}'); // Debug print

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['data'] ?? {}; // Get user data from response
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<void> updateProfile(String name, String email) async {
    final token = await _getToken();
    if (token == null) throw Exception('No auth token found');

    final response = await http.post(
      Uri.parse('$baseUrl/profile/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to update profile');
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final token = await _getToken();
    if (token == null) throw Exception('No auth token found');

    final response = await http.post(
      Uri.parse('$baseUrl/profile/change-password'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to change password');
    }
  }
}