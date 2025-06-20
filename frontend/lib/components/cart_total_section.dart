import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CartTotalSection extends StatelessWidget {
  final double total;
  final VoidCallback onOrderPressed;

  const CartTotalSection({
    super.key,
    required this.total,
    required this.onOrderPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("\$${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greeting,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onOrderPressed,
            child: const Text("Realizar orden", style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}