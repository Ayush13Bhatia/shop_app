import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/order.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Text",
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1!
                                .color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<Order>(context, listen: false).addOrder(
                            cart.items.values.toList(), cart.totalAmount);
                        cart.clear();
                      },
                      child: Text("ORDER NOW"),
                    ),
                  ]),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) => CartItem(
                        id: cart.items.values.toList()[index].id,
                        // key: cart.items.keys.toList()[index] as Key,
                        title: cart.items.values.toList()[index].title,
                        price: cart.items.values.toList()[index].price,
                        quantity: cart.items.values.toList()[index].quantity,
                      ))),
        ],
      ),
    );
  }
}
