import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/text_style.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
                "Hola 👋🏻",
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
                  "Bienvenidos a Sabores de mi casa",
                  style: AppTextStyle.banner,
                ),
              ),
            ),

            const SizedBox(height: 30),
            sectionTitle("🆕 Productos Nuevos"),

            // Productos nuevos
            const SizedBox(height: 12),
            SizedBox(
              height: 210,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                children: const [
                  ProductCard(
                    image: 'https://s3.ppllstatics.com/diariovasco/www/multimedia/2024/11/13/espresso-RrCckvN0LEAFk54KAQQPcXM-1200x840@Diario%20Vasco.jpg',
                    title: "Café Espresso",
                    price: "\$2.50",
                  ),
                  ProductCard(
                    image: 'https://carorocco.com/wp-content/uploads/2021/03/Te-Chai-Latte-VERTICAL.jpg',
                    title: "Té Chai Latte",
                    price: "\$3.20",
                  ),
                  ProductCard(
                    image: 'https://comedera.com/wp-content/uploads/sites/9/2022/09/chocolate-caliente-venezolano.jpg?w=500&h=500&crop=1',
                    title: "Chocolate Caliente",
                    price: "\$2.80",
                  ),
                ],
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

class ProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: AppColors.productCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              image,
              height: 100,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          // Texto
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.productTitle),
                const SizedBox(height: 6),
                Text(price, style: AppTextStyle.productPrice),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  final String title;
  final String description;
  final Color bgColor;
  final String emoji;

  const PromoCard({
    super.key,
    required this.title,
    required this.description,
    required this.bgColor,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.promoTitle),
                const SizedBox(height: 6),
                Text(description, style: AppTextStyle.promoDesc),
              ],
            ),
          )
        ],
      ),
    );
  }
}
