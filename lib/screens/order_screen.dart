import 'package:flutter/material.dart';
import 'package:http/retry.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  // @override
//   _OrderScreenState createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   var _isLoading = false;
//   Future<void> _refresh(BuildContext context) async {
//     await Provider.of<Orders>(context, listen: false).fetchAndOrders();
//   }

//   @override
//   void initState() {
//     Future.delayed(Duration.zero).then((_) async {
//       setState(() {
//         _isLoading = true;
//       });
//       Provider.of<Orders>(context, listen: false).fetchAndOrders();
//       setState(() {
//         _isLoading = false;
//       });
//     });
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),
      ),
      drawer: AppDrawers(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occurredd!'),
              );
            } else {
              return Consumer<Orders>(
                  builder: (context, ordersData, child) => ListView.builder(
                        itemBuilder: (context, i) => OrderItem(
                          order: ordersData.orders[i],
                        ),
                        itemCount: ordersData.orders.length,
                      ));
            }
          }
        },
      ),
    );
  }
}
