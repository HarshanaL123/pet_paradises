import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutService {
  static const String baseUrl = 'https://petsup.online/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, dynamic>> getCheckoutDetails() async {
    final token = await _getToken();
    if (token == null) throw Exception('No auth token found');

    final response = await http.get(
      Uri.parse('$baseUrl/checkout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load checkout details');
    }
  }

  Future<Map<String, dynamic>> processPayment(Map<String, dynamic> paymentData) async {
    final token = await _getToken();
    if (token == null) throw Exception('No auth token found');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(paymentData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Payment processing failed');
      }
    } catch (e) {
      throw Exception('Payment processing failed: $e');
    }
  }

  Future<void> clearCheckoutForm() async {
    final token = await _getToken();
    if (token == null) throw Exception('No auth token found');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/checkout/clear'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to clear checkout form');
      }
    } catch (e) {
      throw Exception('Failed to clear checkout form: $e');
    }
  }

  Future<Map<String, dynamic>> getCheckoutSuccess() async {
    final token = await _getToken();
    if (token == null) throw Exception('No auth token found');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/checkout/success'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to get success details');
      }
    } catch (e) {
      throw Exception('Failed to get success details: $e');
    }
  }

  Future<bool> validatePaymentData(Map<String, dynamic> paymentData) async {
    if (paymentData['amount'] == null || paymentData['amount'] <= 0) {
      throw Exception('Invalid payment amount');
    }

    if (paymentData['name']?.isEmpty ?? true) {
      throw Exception('Name is required');
    }

    if (paymentData['email']?.isEmpty ?? true) {
      throw Exception('Email is required');
    }

    if (paymentData['phone']?.isEmpty ?? true) {
      throw Exception('Phone number is required');
    }

    if (paymentData['address']?.isEmpty ?? true) {
      throw Exception('Delivery address is required');
    }

    return true;
  }
}