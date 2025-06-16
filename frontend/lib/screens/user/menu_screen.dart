import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/app_colors.dart';
import '../../utils/text_style.dart';
import '../../models/product.dart';
import '../../components/product_card.dart';
import '../../components/promo_card.dart';
import '../../utils/user_session.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Product> allProducts = [];
  bool isLoading = true;
  late String userName;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    userName = UserSession().userName ?? "Usuario";
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

  List<Product> get newProducts =>
      allProducts.where((p) => p.isNew).toList();

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

            // Banner de bienvenida
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.brown.shade300, Colors.brown.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: const Center(
                child: Text(
                  "Bienvenido a Sabores de mi casa",
                  style: AppTextStyle.banner,
                ),
              ),
            ),

            const SizedBox(height: 30),
            sectionTitle("🆕 Productos Nuevos"),

            // Productos nuevos dinámicos
            const SizedBox(height: 12),
            SizedBox(
              height: 210,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : newProducts.isEmpty
                      ? const Center(child: Text("No hay productos nuevos"))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 20),
                          itemCount: newProducts.length,
                          itemBuilder: (context, index) {
                            final product = newProducts[index];
                            return ProductCard(
                              image: product.image,
                              title: product.title,
                              price: "\$${product.price.toStringAsFixed(2)}",
                            );
                          },
                        ),
            ),

            const SizedBox(height: 30),
            sectionTitle("🎉 Promociones"),

            // Promociones
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: const [
                  PromoCard(
                    title: "2x1 Frappuccino",
                    description: "Solo este fin de semana",
                    bgColor: AppColors.promo1,
                    emoji: "🥤",
                  ),
                  SizedBox(height: 16),
                  PromoCard(
                    title: "Combo Café + Galleta",
                    description: "Por solo \$3.50",
                    bgColor: AppColors.promo2,
                    emoji: "☕🍪",
                  ),
                  SizedBox(height: 16),
                  PromoCard(
                    title: "Descuento en Panini",
                    description: "20% off hasta el viernes",
                    bgColor: AppColors.promo3,
                    emoji: "🥪",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
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
