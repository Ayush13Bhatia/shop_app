import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

import '../providers/order.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),
      ),
      drawer: AppDrawers(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: ListView.builder(
            itemCount: ordersData.orders.length,
            itemBuilder: (context, index) => OrderItem(
                  order: ordersData.orders[index],
                )),
      ),
    );
  }
}
