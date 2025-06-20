import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  static Future<List<dynamic>> fetchAllOrders() async {
    final url = Uri.parse('http://localhost:3001/api/v1/orders/admin'); // Ajusta el endpoint si es necesario
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    return [];
  }

  static Future<Map<String, dynamic>?> fetchOrderWithItems(int orderId) async {
    final url = Uri.parse('http://localhost:3001/api/v1/orders/$orderId/items');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}