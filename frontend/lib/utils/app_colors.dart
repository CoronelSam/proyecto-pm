import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBackground = Color(0xFFFFE7CB);
  static const Color scaffoldBackground = Color(0xFFFFF9F3);
  static const Color sectionTitle = Color(0xFF5D4037);
  static const Color promo1 = Color(0xFFDAC0A3);
  static const Color promo2 = Color(0xFFE4C9A1);
  static const Color promo3 = Color(0xFFD8B384);
  static const Color productCard = Colors.white;
  static const Color productPrice = Color(0xFF795548); // brown[600]
  static const Color productTitle = Colors.black;
  static const Color greeting = Color(0xFF6D4C41); // brown[800]

  static const LinearGradient instagramGradient = LinearGradient(
    colors: [
      Color(0xFFF58529),
      Color(0xFFDD2A7B), 
      Color(0xFF515BD4), 
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}