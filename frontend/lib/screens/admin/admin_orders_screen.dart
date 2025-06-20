import 'package:flutter/material.dart';
import '../../services/order_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  late Future<List<dynamic>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = OrderService.fetchAllOrders();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pendiente':
        return Colors.orange;
      case 'En preparación':
        return Colors.blue;
      case 'Entregado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Órdenes')),
      body: FutureBuilder<List<dynamic>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay órdenes'));
          }
          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final user = order['User'];
              final items = order['OrderItems'] as List<dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  title: Text(user != null ? user['name'] ?? 'Cliente' : 'Cliente'),
                  subtitle: Text('Total: \$${order['total']}'),
                  trailing: Text(
                    order['status'] ?? 'Pendiente',
                    style: TextStyle(
                      color: _getStatusColor(order['status'] ?? ''),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: items.map((item) {
                    final product = item['Product'];
                    return ListTile(
                      title: Text(product != null ? product['name'] : 'Producto eliminado'),
                      subtitle: Text(
                        'Cantidad: ${item['quantity']}${item['size'] != null ? '\nTamaño: ${item['size']}' : ''}'
                      ),
                      trailing: Text('\$${item['subtotal']}'),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}