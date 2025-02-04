import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class CartService {
  static const String baseUrl = 'https://petsup.online/api';
  static const int DELIVERY_CHARGE = 1500; // Fixed delivery charge

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<CartItem>> getCartItems() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No auth token found');

      final response = await http.get(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> cartItems = jsonResponse['cart_items'] ?? [];
        return cartItems.map((item) => CartItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load cart: $e');
    }
  }

  Future<void> addToCart(String productId, int quantity) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No auth token found');

      final response = await http.post(
        Uri.parse('$baseUrl/cart/add'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to add item to cart');
      }
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  Future<void> updateCartItem(String productId, int quantity) async {
    try {
      if (quantity < 1) {
        await removeFromCart(productId);
        return;
      }

      final token = await _getToken();
      if (token == null) throw Exception('No auth token found');

      final response = await http.post(
        Uri.parse('$baseUrl/cart/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update cart item');
      }
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No auth token found');

      final response = await http.post(
        Uri.parse('$baseUrl/cart/remove'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'product_id': productId,
        }),
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to remove item from cart');
      }
    } catch (e) {
      throw Exception('Failed to remove item: $e');
    }
  }

  Future<Map<String, int>> getCartTotals() async {
    try {
      final items = await getCartItems();
      final subtotal = items.fold<int>(0, (sum, item) => sum + (item.price * item.quantity));
      return {
        'subtotal': subtotal,
        'delivery': DELIVERY_CHARGE,
        'total': subtotal + DELIVERY_CHARGE,
      };
    } catch (e) {
      throw Exception('Failed to calculate cart total: $e');
    }
  }
}