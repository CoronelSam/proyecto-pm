class Product {
  final String image;
  final String title;
  final double price;
  final DateTime createdAt;

  Product({
    required this.image,
    required this.title,
    required this.price,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      image: json['image_url'] ?? '',
      title: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  bool get isNew {
    final now = DateTime.now();
    return now.difference(createdAt).inDays <= 7;
  }
}