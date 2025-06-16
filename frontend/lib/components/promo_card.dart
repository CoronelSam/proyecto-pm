import 'package:flutter/material.dart';
import '../utils/text_style.dart';

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