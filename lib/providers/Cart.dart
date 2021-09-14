import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String? id;
  final String? title;
  final int? quantity;
  final double? price;
  CartItem({
    this.id,
    this.title,
    this.price,
    this.quantity,
  });
}

class Cart with ChangeNotifier {
  late Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price! * cartItem.quantity!;
    });
    return total;
  }

  void additem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // ...Change Quentity..
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity! + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity! > 1) {
      _items.update(
          productId,
          (exitingCartItem) => CartItem(
                id: exitingCartItem.id,
                title: exitingCartItem.title,
                price: exitingCartItem.price,
                quantity: exitingCartItem.quantity! - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
