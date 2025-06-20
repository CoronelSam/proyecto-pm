import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/cart_provider.dart';
import '../../services/favorite_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_style.dart';

class ProductOrderScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductOrderScreen({super.key, required this.product});

  @override
  State<ProductOrderScreen> createState() => _ProductOrderScreenState();
}

class _ProductOrderScreenState extends State<ProductOrderScreen> {
  int _quantity = 1;
  String? _selectedSize;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final productId = product['id'];
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFavorite = productId != null && favoriteProvider.isFavorite(productId);

    double getPrice() {
      final sizes = product['sizes'];
      final hasSizes = sizes != null && (sizes['pequeño'] != null || sizes['grande'] != null);

      if (hasSizes && _selectedSize != null) {
        final priceValue = sizes[_selectedSize];
        if (priceValue is num) {
          return priceValue.toDouble();
        } else if (priceValue is String) {
          return double.tryParse(priceValue) ?? 0.0;
        }
        return 0.0;
      }
      final priceValue = product['price'];
      if (priceValue is num) {
        return priceValue.toDouble();
      } else if (priceValue is String) {
        return double.tryParse(priceValue) ?? 0.0;
      }
      return 0.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? '', style: AppTextStyle.sectionTitle),
        backgroundColor: AppColors.primaryBackground,
        iconTheme: const IconThemeData(color: AppColors.sectionTitle),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: productId == null
                ? null
                : () async {
                    if (isFavorite) {
                      await favoriteProvider.removeFavorite(productId);
                    } else {
                      await favoriteProvider.addFavorite(productId);
                    }
                  },
          ),
        ],
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product['image_url'] != null && (product['image_url']?.toString().isNotEmpty ?? false))
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(product['image_url'], height: 160),
                ),
              ),
            const SizedBox(height: 16),
            Text(product['description'] ?? '', style: AppTextStyle.body),
            const SizedBox(height: 16),
            if (product['sizes'] != null && (product['sizes']['pequeño'] != null || product['sizes']['grande'] != null))
              DropdownButtonFormField<String>(
                value: _selectedSize,
                items: [
                  if (product['sizes']['pequeño'] != null)
                    const DropdownMenuItem(value: 'pequeño', child: Text('Pequeño')),
                  if (product['sizes']['grande'] != null)
                    const DropdownMenuItem(value: 'grande', child: Text('Grande')),
                ],
                onChanged: (val) => setState(() => _selectedSize = val),
                decoration: const InputDecoration(labelText: 'Tamaño'),
                validator: (val) => val == null ? 'Seleccione un tamaño' : null,
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                ),
                Text('$_quantity', style: AppTextStyle.title),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Total: \$${(getPrice() * _quantity).toStringAsFixed(2)}',
              style: AppTextStyle.productPrice.copyWith(fontSize: 22),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.productPrice,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (product['sizes'] != null && (product['sizes']['pequeño'] != null || product['sizes']['grande'] != null) && _selectedSize == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Seleccione un tamaño')),
                    );
                    return;
                  }
                  Provider.of<CartProvider>(context, listen: false).addToCart(
                    product,
                    _quantity,
                    size: product['sizes'] != null && (product['sizes']['pequeño'] != null || product['sizes']['grande'] != null) ? _selectedSize : null,
                    price: getPrice(),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Producto agregado al carrito')),
                  );
                  Navigator.of(context).pop();
                },
                label: const Text('Agregar al carrito', style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}