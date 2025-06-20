import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/user_session.dart';

class FavoriteService {
  static Future<List<int>> getFavoriteIds() async {
    final userId = UserSession().userId;
    if (userId == null) return [];
    final url = Uri.parse('http://localhost:3001/api/v1/user-favorites/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((prod) => prod['id'] as int).toList();
    }
    return [];
  }

  static Future<void> addFavorite(int productId) async {
    final userId = UserSession().userId;
    if (userId == null) return;
    final url = Uri.parse('http://localhost:3001/api/v1/user-favorites');
    await http.post(url, body: jsonEncode({'userId': userId, 'productId': productId}), headers: {'Content-Type': 'application/json'});
  }

  static Future<void> removeFavorite(int productId) async {
    final userId = UserSession().userId;
    if (userId == null) return;
    final url = Uri.parse('http://localhost:3001/api/v1/user-favorites');
    await http.delete(url, body: jsonEncode({'userId': userId, 'productId': productId}), headers: {'Content-Type': 'application/json'});
  }
}