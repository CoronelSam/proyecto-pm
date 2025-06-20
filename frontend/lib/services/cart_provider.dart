import 'package:flutter/material.dart';

class CartItem {
  final Map<String, dynamic> product;
  final int quantity;
  final String? size;
  final double price;

  CartItem({
    required this.product,
    required this.quantity,
    this.size,
    required this.price,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Map<String, dynamic> product, int quantity, {String? size, required double price}) {
    _items.add(CartItem(product: product, quantity: quantity, size: size, price: price));
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void updateItem(CartItem oldItem, int newQuantity, {String? newSize, required double newPrice}) {
    final index = _items.indexOf(oldItem);
    if (index != -1) {
      _items[index] = CartItem(
        product: oldItem.product,
        quantity: newQuantity,
        size: newSize,
        price: newPrice,
      );
      notifyListeners();
    }
  }
}