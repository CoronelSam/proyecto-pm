import 'dart:convert';

class Product {
  final String image;
  final String title;
  final double? price;
  final DateTime createdAt;
  final Map<String, dynamic>? sizes;

  Product({
    required this.image,
    required this.title,
    required this.price,
    required this.createdAt,
    this.sizes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? sizes;
    if (json['sizes'] != null) {
      if (json['sizes'] is String) {
        try {
          sizes = Map<String, dynamic>.from(jsonDecode(json['sizes']));
        } catch (_) {
          sizes = null;
        }
      } else if (json['sizes'] is Map) {
        sizes = Map<String, dynamic>.from(json['sizes']);
      }
    }
    return Product(
      image: json['image_url'] ?? '',
      title: json['name'] ?? '',
      price: json['price'] != null && json['price'].toString().isNotEmpty
          ? double.tryParse(json['price'].toString())
          : null,
      createdAt: DateTime.parse(json['created_at']),
      sizes: sizes,
    );
  }

  bool get isNew {
    final now = DateTime.now();
    return now.difference(createdAt).inDays <= 7;
  }

  String get priceText {
    if (sizes != null && sizes!.isNotEmpty) {
      final tienePequeno = sizes!['pequeño'] != null;
      final tieneGrande = sizes!['grande'] != null;
      if (tienePequeno && tieneGrande) {
        return "Pequeño: L${sizes!['pequeño']}  Grande: L${sizes!['grande']}";
      } else if (tienePequeno) {
        return "Pequeño: L${sizes!['pequeño']}";
      } else if (tieneGrande) {
        return "Grande: L${sizes!['grande']}";
      }
    }
    return price != null ? "L${price!.toStringAsFixed(2)}" : "Sin precio";
  }

  get id => null;

  Map<String, dynamic> toJson() => {
        'name': title,
        'image_url': image,
        'price': price,
        'sizes': sizes,
        'available': isNew,
        'created_at': createdAt.toIso8601String(),
      };
}