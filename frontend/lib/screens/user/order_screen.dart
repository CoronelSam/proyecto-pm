import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/app_colors.dart';
import '../../utils/text_style.dart';
import '../../components/category_navbar.dart';
import '../../components/product_card.dart';

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
      backgroundColor: AppColors.scaffoldBackground,
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
                          return ProductCard(product: product);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}