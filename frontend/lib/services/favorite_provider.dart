import 'package:flutter/material.dart';
import 'favorite_service.dart';

class FavoriteProvider with ChangeNotifier {
  List<int> _favoriteIds = [];

  List<int> get favoriteIds => _favoriteIds;

  Future<void> fetchFavorites() async {
    final ids = await FavoriteService.getFavoriteIds();
    _favoriteIds = ids;
    notifyListeners();
  }

  bool isFavorite(int productId) => _favoriteIds.contains(productId);

  Future<void> addFavorite(int productId) async {
    await FavoriteService.addFavorite(productId);
    _favoriteIds.add(productId);
    notifyListeners();
  }

  Future<void> removeFavorite(int productId) async {
    await FavoriteService.removeFavorite(productId);
    _favoriteIds.remove(productId);
    notifyListeners();
  }
}