import 'package:flutter/material.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  // Simulación de pedidos
  final List<Map<String, String>> orders = const [
    {'cliente': 'Juan Pérez', 'estado': 'Pendiente', 'detalle': '2x Café, 1x Panini'},
    {'cliente': 'Ana López', 'estado': 'En preparación', 'detalle': '1x Té Chai'},
    {'cliente': 'Carlos Ruiz', 'estado': 'Entregado', 'detalle': '1x Chocolate, 2x Galleta'},
  ];

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
      appBar: AppBar(title: const Text('Pedidos Realizados')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(order['cliente']!),
              subtitle: Text(order['detalle']!),
              trailing: Text(
                order['estado']!,
                style: TextStyle(
                  color: _getStatusColor(order['estado']!),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}