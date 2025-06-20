import 'package:flutter/material.dart';
import 'package:frontend/screens/user/product_order_screen.dart';
import '../utils/app_colors.dart';
import '../utils/text_style.dart';
import 'dart:convert';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    dynamic sizes = product['sizes'];
    if (sizes is String && sizes.isNotEmpty) {
      try {
        sizes = jsonDecode(sizes);
      } catch (_) {
        sizes = null;
      }
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductOrderScreen(product: product),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        color: AppColors.productCard,
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
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product['name'] ?? '', style: AppTextStyle.title),
                    const SizedBox(height: 8),
                    if (sizes != null && sizes is Map && (sizes['pequeño'] != null || sizes['grande'] != null))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (sizes['pequeño'] != null)
                            Text('Pequeño: \$${sizes['pequeño']}', style: AppTextStyle.body.copyWith(color: AppColors.productPrice)),
                          if (sizes['grande'] != null)
                            Text('Grande: \$${sizes['grande']}', style: AppTextStyle.body.copyWith(color: AppColors.productPrice)),
                        ],
                      )
                    else
                      Text('Precio: \$${product['price']}', style: AppTextStyle.body.copyWith(color: AppColors.productPrice)),
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
      ),
    );
  }
}