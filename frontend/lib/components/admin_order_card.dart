import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final DateFormat dateFormat;
  final String Function(String) getStatusText;
  final Color Function(String) getStatusColor;
  final void Function(String newStatus)? onStatusChanged;

  const AdminOrderCard({
    super.key,
    required this.order,
    required this.dateFormat,
    required this.getStatusText,
    required this.getStatusColor,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final user = order['User'];
    final items = order['OrderItems'] as List<dynamic>;
    final status = order['status'] ?? 'pending';
    final total = order['total'] ?? 0;
    final createdAt = order['created_at'];
    final date = createdAt != null ? DateTime.tryParse(createdAt) : null;

    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          user != null ? user['name'] ?? 'Cliente' : 'Cliente',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total: L${(double.tryParse(total.toString()) ?? 0).toStringAsFixed(2)}'),
            if (date != null)
              Text(
                'Fecha: ${dateFormat.format(date)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onStatusChanged != null)
              DropdownButton<String>(
                value: status,
                items: const [
                  DropdownMenuItem(
                    value: 'pending',
                    child: Text('Pendiente'),
                  ),
                  DropdownMenuItem(
                    value: 'en preparacion',
                    child: Text('En preparación'),
                  ),
                  DropdownMenuItem(
                    value: 'listo',
                    child: Text('Listo'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null && value != status) {
                    onStatusChanged!(value);
                  }
                },
                underline: const SizedBox(),
                icon: const Icon(Icons.edit, size: 18),
                selectedItemBuilder: (context) {
                  return ['pending', 'en preparacion', 'listo'].map((value) {
                    return Text(
                      getStatusText(value),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getStatusColor(value),
                      ),
                    );
                  }).toList();
                },
              ),
          ],
        ),
        children: items.map((item) {
          final product = item['Product'];
          return ListTile(
            leading: const Icon(Icons.fastfood, color: Colors.grey),
            title: Text(product != null ? product['name'] : 'Producto eliminado'),
            subtitle: Text(
              'Cantidad: ${item['quantity']}${item['size'] != null ? '\nTamaño: ${item['size']}' : ''}',
              style: const TextStyle(fontSize: 13),
            ),
            trailing: Text('L${item['subtotal']}'),
          );
        }).toList(),
      ),
    );
  }
}