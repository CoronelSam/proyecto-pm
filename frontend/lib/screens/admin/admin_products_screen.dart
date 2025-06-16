import 'package:flutter/material.dart';
import 'package:frontend/utils/app_colors.dart';
import 'package:frontend/utils/text_style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_add_product_screen.dart';
import 'admin_edit_product_screen.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  late Future<List<Map<String, dynamic>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await http.get(Uri.parse('http://localhost:3001/api/v1/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: AppTextStyle.body));
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return Center(child: Text('No hay productos registrados', style: AppTextStyle.body));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                color: AppColors.productCard,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: product['image_url'] != null && product['image_url'].toString().isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product['image_url'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                          ),
                        )
                      : const Icon(Icons.image, size: 40, color: AppColors.sectionTitle),
                  title: Text(product['name'] ?? '', style: AppTextStyle.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product['description'] != null && product['description'].toString().isNotEmpty)
                        Text(product['description'], style: AppTextStyle.body),
                      const SizedBox(height: 4),
                      Text('Categoría: ${product['category'] ?? ''}', style: AppTextStyle.body),
                      Text('Precio: \$${product['price']}', style: AppTextStyle.body.copyWith(color: AppColors.productPrice)),
                      Text(
                        product['available'] == true ? 'Disponible' : 'No disponible',
                        style: AppTextStyle.body.copyWith(
                          color: product['available'] == true ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () async {
                    final updated = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AdminEditProductScreen(product: product),
                      ),
                    );
                    if (updated == true) {
                      setState(() {
                        _productsFuture = fetchProducts();
                      });
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.productPrice,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AdminAddProductScreen()),
          );
          setState(() {
            _productsFuture = fetchProducts(); // Refresca la lista al volver
          });
        },
        tooltip: 'Agregar producto',
        child: const Icon(Icons.add)
      ),
    );
  }
}