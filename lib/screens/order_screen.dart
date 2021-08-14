import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),
      ),
      drawer: AppDrawers(),
      body: ListView.builder(
          itemCount: ordersData.orders.length,
          itemBuilder: (context, index) => OrderItem(
                order: ordersData.orders[index],
              )),
    );
  }
}
