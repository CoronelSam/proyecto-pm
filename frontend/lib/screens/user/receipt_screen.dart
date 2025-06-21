import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_style.dart';
//import 'tracker_order_screen.dart';

class ReceiptScreen extends StatelessWidget {
  final Map<String, dynamic> order;
  const ReceiptScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderId = order['id']?.toString() ?? '';
    final createdAt = order['created_at'] ?? order['createdAt'] ?? '';
    final dateTime = DateTime.tryParse(createdAt) ?? DateTime.now();
    final formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    final formattedTime = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    final items = order['OrderItems'] ?? order['items'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Recibo #$orderId', style: AppTextStyle.sectionTitle),
        backgroundColor: AppColors.primaryBackground,
        iconTheme: const IconThemeData(color: AppColors.sectionTitle),
        elevation: 0,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado en Card
            Card(
              color: AppColors.primaryBackground,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Recibo #$orderId", style: AppTextStyle.sectionTitle),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(formattedDate, style: AppTextStyle.body),
                            const SizedBox(width: 12),
                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(formattedTime, style: AppTextStyle.body),
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.receipt_long, color: AppColors.sectionTitle, size: 32),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Productos", style: AppTextStyle.title),
            const Divider(thickness: 1.2),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final product = item['Product'] ?? item['product'] ?? {};
                  final name = product['name'] ?? item['name'] ?? 'Producto sin nombre';
                  final quantity = item['quantity'] ?? 1;
                  final size = item['size'];
                  final subtotalRaw = item['subtotal'] ?? 0;
                  final subtotal = double.tryParse(subtotalRaw.toString()) ?? 0.0;
                  return ListTile(
                    leading: const Icon(Icons.shopping_bag, color: AppColors.greeting),
                    title: Text(name, style: AppTextStyle.body),
                    subtitle: size != null ? Text('Tamaño: $size', style: AppTextStyle.body) : null,
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('x$quantity', style: AppTextStyle.body),
                        Text('L${subtotal.toStringAsFixed(2)}', style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        )),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Total a pagar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total a pagar', style: AppTextStyle.title),
                  Text(
                    'L${items.fold<double>(0.0, (double sum, dynamic item) {
                      final size = item['size'];
                      double price = 0.0;
                      if (size is Map && size['price'] != null) {
                        price = double.tryParse(size['price'].toString()) ?? 0.0;
                      } else if (item['subtotal'] != null) {
                        price = double.tryParse(item['subtotal'].toString()) ?? 0.0;
                      }
                      return sum + price;
                    }).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.track_changes),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.productPrice,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => TrackerOrderScreen(orderId: orderId),
                  //   ),
                  // );
                },
                label: const Text('Ver estado de la orden', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

