// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_style.dart';
import '../../services/cart_provider.dart';
import '../../utils/user_session.dart';
import '../../components/cart_item.dart';
import '../../components/empty_cart.dart';
import '../../components/cart_total_section.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double getTotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  Future<void> _realizarOrden(BuildContext context, CartProvider cartProvider) async {
    final cartItems = cartProvider.items;
    if (cartItems.isEmpty) return;

    final session = UserSession();
    final userId = session.userId;

    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: usuario no autenticado")),
      );
      return;
    }

    final orderItems = cartItems.map((item) => {
      'product_id': item.product['id'],
      'quantity': item.quantity,
      'subtotal': (item.price * item.quantity),
      if (item.size != null) 'size': item.size,
    }).toList();

    final body = {
      'user_id': userId,
      'order_type': 'online',
      'total': getTotal(cartItems),
      'items': orderItems,
    };

    final url = Uri.parse('http://localhost:3001/api/v1/orders');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (!mounted) return;
      if (response.statusCode == 201) {
        cartProvider.clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Orden realizada!")),
        );
        Navigator.of(context).pop();
      } else {
        final resp = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp['error'] ?? 'Error al realizar la orden')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error de conexión")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final total = getTotal(cartItems);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: "Vaciar carrito",
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.scaffoldBackground,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text(
                      "Vaciar carrito",
                      style: AppTextStyle.sectionTitle,
                    ),
                    content: const Text(
                      "¿Estás seguro de que deseas eliminar todos los productos del carrito?",
                      style: AppTextStyle.body,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancelar", style: AppTextStyle.body),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          "Eliminar",
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  cartProvider.clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Carrito vaciado")),
                  );
                }
              },
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? const EmptyCartWidget()
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: cartItems.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) => CartItemTile(
                        item: cartItems[index],
                        onUpdate: (newQuantity, newSize, newPrice) {
                          cartProvider.updateItem(cartItems[index], newQuantity, newSize: newSize, newPrice: newPrice);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Producto actualizado")),
                          );
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.scaffoldBackground,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: const Text("Eliminar producto", style: AppTextStyle.sectionTitle),
                              content: const Text(
                                "¿Eliminar este producto del carrito?",
                                style: AppTextStyle.body,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text("Cancelar", style: AppTextStyle.body),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text(
                                    "Eliminar",
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            cartProvider.removeItem(cartItems[index]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Producto eliminado del carrito")),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CartTotalSection(
                    total: total,
                    onOrderPressed: () => _realizarOrden(context, cartProvider),
                  ),
                ],
              ),
            ),
    );
  }
}