import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_style.dart';
import '../services/cart_provider.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final Function(int, String?, double) onUpdate;
  final VoidCallback onDelete;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    return ListTile(
      leading: product['image_url'] != null
          ? Image.network(product['image_url'], width: 50, height: 50, fit: BoxFit.cover)
          : const Icon(Icons.image_not_supported),
      title: Text(product['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        "Cantidad: ${item.quantity}${item.size != null ? "\nTamaño: ${item.size}" : ""}"
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("L${(item.price * item.quantity).toStringAsFixed(2)}"),
          IconButton(
            icon: const Icon(Icons.edit_note, color: Colors.blue),
            tooltip: "Editar este producto",
            onPressed: () async {
              int newQuantity = item.quantity;
              String? newSize = item.size;
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: AppColors.scaffoldBackground,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text("Editar producto", style: AppTextStyle.sectionTitle),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          initialValue: newQuantity.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Cantidad"),
                          onChanged: (value) {
                            newQuantity = int.tryParse(value) ?? item.quantity;
                          },
                        ),
                        if (product['sizes'] != null && product['sizes'] is Map)
                          DropdownButtonFormField<String>(
                            value: newSize,
                            items: (product['sizes'] as Map<String, dynamic>).keys.map((size) {
                              return DropdownMenuItem(
                                value: size,
                                child: Text(size),
                              );
                            }).toList(),
                            onChanged: (value) {
                              newSize = value;
                            },
                            decoration: const InputDecoration(labelText: "Tamaño"),
                          ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancelar", style: AppTextStyle.body),
                      ),
                      TextButton(
                        onPressed: () {
                          double newPrice = item.price;
                          if (newSize != null && product['sizes'] != null && product['sizes'][newSize] != null) {
                            newPrice = double.tryParse(product['sizes'][newSize].toString()) ?? item.price;
                          }
                          onUpdate(newQuantity, newSize, newPrice);
                          Navigator.of(context).pop();
                        },
                        child: const Text("Guardar", style: AppTextStyle.body),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: "Eliminar este producto",
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}