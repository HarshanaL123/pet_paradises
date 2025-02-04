import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://petsup.online/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

// In ApiService class
Future<Map<String, dynamic>> register(
    String firstName, 
    String lastName, 
    String email, 
    String password
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        
        // Save token if provided in response
        if (responseData['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', responseData['token']);
        }
        
        return responseData;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  Future<List<dynamic>> fetchProducts(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/products?category=$category'));

    if (response.statusCode == 200) {
      // Assuming the API returns a map with a key 'data' that contains the product list
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['data'] != null) {
        return responseBody['data']; // Return the list of products
      } else {
        throw Exception('No products found');
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

}
