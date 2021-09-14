import 'package:flutter/material.dart';
import 'cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem>? products;
  final DateTime? dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  CollectionReference ordersItems =
      FirebaseFirestore.instance.collection('Orders');
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    try {
      FirebaseFirestore.instance
          .collection('Orders')
          .snapshots()
          .listen((snapshot) {});

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final timestamp = DateTime.now();
    final response = await ordersItems.add({
      'amount': total,
      'dateTime': timestamp.toIso8601String(),
      'products': cartProduct
          .map((cp) => {
                'id': cp.id,
                'title': cp.title,
                'quantity': cp.quantity,
                'price': cp.price,
              })
          .toList(),
    });
    _orders.insert(
        0,
        OrderItem(
          id: response.id,
          amount: total,
          dateTime: timestamp,
          products: cartProduct,
        ));
    notifyListeners();
  }
}
