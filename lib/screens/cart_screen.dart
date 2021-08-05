import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Cart.dart';

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
                        '\$${cart.totalAmount}',
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
                      onPressed: () {},
                      child: Text("ORDER NOW"),
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
