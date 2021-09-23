import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './cart.dart';

class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem>? products;
  final DateTime? dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  CollectionReference ordersItems =
      FirebaseFirestore.instance.collection('OrdersItems');

  List<OrderItem> _orders = [];
  final String? authToken;
  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndOrders() async {
    FirebaseFirestore.instance
        .collection("OrdersItems")
        .snapshots()
        .listen((snapshot) {
      List<OrderItem> _loadedOrders = [];
      snapshot.docs.forEach((documents) {
        // print(documents.data());
        _loadedOrders.add(
          OrderItem(
            id: documents.id,
            amount: documents.data()['amount'],
            dateTime: DateTime.parse(documents['dateTime']),
            products: (documents['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    title: item['title'],
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = _loadedOrders.reversed.toList();
      print(_loadedOrders);
      print(_orders);

      notifyListeners();
    });
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
          // id: timestamp.toString(),
          amount: total,
          dateTime: timestamp,
          products: cartProduct,
        ));
    // print(response.id);
    notifyListeners();
  }
}
