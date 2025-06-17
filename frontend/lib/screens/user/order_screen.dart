import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/app_colors.dart';
import '../../utils/text_style.dart';
import '../../components/category_navbar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedIndex = 0;

  final List<String> _tabs = [
    'Bebidas Calientes',
    'Bebidas Heladas',
    'Comidas',
    'Postres',
  ];

  List<dynamic> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    final response = await http.get(Uri.parse('http://localhost:3001/api/v1/products'));
    if (response.statusCode == 200) {
      setState(() {
        _products = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  List<dynamic> get _filteredProducts {
    final category = _tabs[_selectedIndex].toLowerCase();
    return _products.where((p) => (p['category'] ?? '').toLowerCase() == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        title: Text('Ordenar', style: AppTextStyle.title),
      ),
      body: Column(
        children: [
          CategoryNavbar(
            selectedIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? Center(child: Text('No hay productos en esta categoría', style: AppTextStyle.body))
                    : ListView.builder(
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: product['image_url'] != null && product['image_url'].toString().isNotEmpty
                                        ? Image.network(
                                            product['image_url'],
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 80),
                                          )
                                        : Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image, size: 40, color: Colors.white),
                                          ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(product['name'] ?? '', style: AppTextStyle.title),
                                        const SizedBox(height: 8),
                                        Builder(
                                          builder: (_) {
                                            dynamic sizes = product['sizes'];
                                            if (sizes is String && sizes.isNotEmpty) {
                                              try {
                                                sizes = jsonDecode(sizes);
                                              } catch (_) {
                                                sizes = null;
                                              }
                                            }
                                            if (sizes != null && sizes is Map) {
                                              final tienePequeno = sizes['pequeño'] != null;
                                              final tieneGrande = sizes['grande'] != null;
                                              if (tienePequeno || tieneGrande) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    if (tienePequeno)
                                                      Text('Pequeño: \$${sizes['pequeño']}', style: AppTextStyle.body.copyWith(color: AppColors.productPrice)),
                                                    if (tieneGrande)
                                                      Text('Grande: \$${sizes['grande']}', style: AppTextStyle.body.copyWith(color: AppColors.productPrice)),
                                                  ],
                                                );
                                              }
                                            }
                                            return Text('Precio: \$${product['price']}', style: AppTextStyle.body.copyWith(color: AppColors.productPrice));
                                          },
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          product['available'] == true ? 'Disponible' : 'No disponible',
                                          style: AppTextStyle.body.copyWith(
                                            color: product['available'] == true ? Colors.green : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}