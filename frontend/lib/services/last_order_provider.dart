import 'package:flutter/material.dart';

class LastOrderProvider with ChangeNotifier {
  Map<String, dynamic>? _lastOrder;

  Map<String, dynamic>? get lastOrder => _lastOrder;

  void setLastOrder(Map<String, dynamic> order) {
    _lastOrder = order;
    notifyListeners();
  }

  void clearLastOrder() {
    _lastOrder = null;
    notifyListeners();
  }
}