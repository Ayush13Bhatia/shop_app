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
      FirebaseFirestore.instance.collection('Orders');
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    try {
      List<OrderItem> _loadedOrders = [];
      FirebaseFirestore.instance
          .collection('Orders')
          .snapshots()
          .listen((snapshot) {
        snapshot.docs.forEach((orderDocs) {
          // print("********Ayush*******");
          // print(orderDocs.data());
          _loadedOrders.add(
            OrderItem(
              id: orderDocs.id,
              amount: orderDocs.data()['amount'],
              dateTime: DateTime.parse(orderDocs['dateTime']),
              products: (orderDocs.data()['products'] as List<dynamic>)
                  .map((item) => CartItem(
                        id: item['id'],
                        price: item['price'],
                        quantity: item['quantity'],
                        title: item['title'],
                      ))
                  .toList(),
            ),
          );
        });
      });
      _orders = _loadedOrders.reversed.toList();

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
