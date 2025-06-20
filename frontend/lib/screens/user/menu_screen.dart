import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/app_colors.dart';
import '../../utils/text_style.dart';
import '../../models/product.dart';
import '../../components/product_card.dart';
import '../../utils/user_session.dart';
import 'package:frontend/screens/user/product_order_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Product> allProducts = [];
  List<Product> favoriteProducts = [];
  bool isLoading = true;
  bool isLoadingFavorites = true;
  late String userName;

  @override
  void initState() {
    super.initState();
    userName = UserSession().userName ?? "Usuario";
    fetchProducts();
    fetchFavorites();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/api/v1/products'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          allProducts = data.map((e) => Product.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchFavorites() async {
    final userId = UserSession().userId;
    if (userId == null) {
      setState(() {
        favoriteProducts = [];
        isLoadingFavorites = false;
      });
      return;
    }
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/api/v1/user-favorites/$userId'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          favoriteProducts = data.map((e) => Product.fromJson(e)).toList();
          isLoadingFavorites = false;
        });
      } else {
        setState(() {
          favoriteProducts = [];
          isLoadingFavorites = false;
        });
      }
    } catch (e) {
      setState(() {
        favoriteProducts = [];
        isLoadingFavorites = false;
      });
    }
  }

  List<Product> get newProducts => allProducts.where((p) => p.isNew).toList();
  Future<void> navigateToProductOrderScreen(dynamic product) async {
    final updated = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductOrderScreen(product: product.toJson()),
      ),
    );
    if (updated == true) {
      fetchFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo superior
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Hola, $userName 👋🏻",
                style: AppTextStyle.greeting,
              ),
            ),

            const SizedBox(height: 30),
            sectionTitle("🆕 Productos Nuevos"),
            const SizedBox(height: 12),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : newProducts.isEmpty
                    ? const Center(child: Text("No hay productos nuevos"))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: newProducts.length,
                        itemBuilder: (context, index) {
                          final product = newProducts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: GestureDetector(
                              onTap: () => navigateToProductOrderScreen(product),
                              child: ProductCard(product: product.toJson()),
                            ),
                          );
                        },
                      ),

            const SizedBox(height: 30),
            sectionTitle("⭐ Favoritos"),
            const SizedBox(height: 12),
            isLoadingFavorites
                ? const Center(child: CircularProgressIndicator())
                : favoriteProducts.isEmpty
                    ? const Center(child: Text("No tienes productos favoritos"))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: favoriteProducts.length,
                        itemBuilder: (context, index) {
                          final product = favoriteProducts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: GestureDetector(
                              onTap: () => navigateToProductOrderScreen(product),
                              child: ProductCard(product: product.toJson()),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: AppTextStyle.sectionTitle,
      ),
    );
  }
}
