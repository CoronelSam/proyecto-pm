import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String email,
    String? name,
    String? phone,
  }) async {
    final url = Uri.parse('http://localhost:3001/api/v1/users/$userId');
    final body = {
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      'email': email,
    };
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> updatePassword({
    required int userId,
    required String password,
  }) async {
    final url = Uri.parse('http://localhost:3001/api/v1/users/$userId/password');
    final body = {'password': password};
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://localhost:3001/api/v1/users/login');
    final body = {
      'email': email,
      'password': password,
    };
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return {
      'statusCode': response.statusCode,
      'body': jsonDecode(response.body),
    };
  }
}