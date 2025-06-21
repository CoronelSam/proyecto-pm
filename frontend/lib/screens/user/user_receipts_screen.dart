import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/user_session.dart';
import 'receipt_screen.dart';

class UserReceiptsScreen extends StatefulWidget {
  const UserReceiptsScreen({super.key});

  @override
  State<UserReceiptsScreen> createState() => _UserReceiptsScreenState();
}

class _UserReceiptsScreenState extends State<UserReceiptsScreen> {
  late Future<List<dynamic>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchUserOrders();
  }

  Future<List<dynamic>> fetchUserOrders() async {
    final userId = UserSession().userId;
    final url = Uri.parse('http://localhost:3001/api/v1/orders/user/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Ordenes')),
      body: FutureBuilder<List<dynamic>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes órdenes aún'));
          }
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final createdAt = order['created_at'] ?? order['createdAt'] ?? '';
              final dateTime = DateTime.tryParse(createdAt) ?? DateTime.now();
              final formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
              return ListTile(
                title: Text('Recibo #${order['id']}'),
                subtitle: Text(formattedDate),
                trailing: Text('L${order['total']}'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ReceiptScreen(order: order),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}