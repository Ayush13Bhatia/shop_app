import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

import '../providers/order.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  var _isLoading = false;

  Future? _orderFuture;
  Future _optainOrderFuture() async {
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    // make that method call without Future.delayed(Duration.zero).then
    ((_) async {
      setState(() {
        _isLoading = true;
      });
      // _orderFuture = _optainOrderFuture();
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

// Another exception was thrown: setState() or markNeedsBuild() called during build.
// E/flutter (23174): [ERROR:flutter/lib/ui/ui_dart_state.cc(199)] Unhandled Exception: setState() called after dispose(): _OrderButtonState#e1189(lifecycle state: defunct, not mounted)
  // @override
  // void initState() {
  //   _orderFuture = _optainOrderFuture();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

//   Another exception was thrown: setState() or markNeedsBuild() called during build.
// E/flutter ( 7344): [ERROR:flutter/lib/ui/ui_dart_state.cc(199)] Unhandled Exception: setState() called after dispose(): _OrderButtonState#bc368(lifecycle state: defunct, not mounted)
// E/flutter ( 7344): This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
// E/flutter ( 7344): The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
// E/flutter ( 7344): This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().
// E/flutter ( 7344): #0      State.setState.<anonymous closure> (package:flutter/src/widgets/framework.dart:1052:9)
// E/flutter ( 7344): #1      State.setState (package:flutter/src/widgets/framework.dart:1087:6)
// E/flutter ( 7344): #2      _OrderButtonState.build.<anonymous closure> (package:shop_app/screens/cart_screen.dart:99:15)
// E/flutter ( 7344): <asynchronous suspension>
// E/flutter ( 7344):
// W/Firestore( 7344): (23.0.3) [WatchStream]: (7a01351) Stream closed with status: Status{code=INTERNAL, description=Internal error
// W/Firestore( 7344): Rst Stream, cause=null}.

  // @override
  // void didChangeDependencies() {
  //   Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  //   // TODO: implement didChangeDependencies1
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),
      ),
      drawer: AppDrawers(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: ListView.builder(
                itemBuilder: (context, i) => OrderItem(
                  order: ordersData.orders[i],
                ),
                itemCount: ordersData.orders.length,
              ),
            ),
    );

    // FutureBuilder(
    //   future: _orderFuture,
    //   builder: (context, dataSnapshot) {
    //     if (dataSnapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else {
    //       if (dataSnapshot.error != null) {
    //         return Center(
    //           child: Text('An error occured!'),
    //         );
    //       } else {
    //         return Consumer<Orders>(
    //           builder: (context, orderdata, child) => ListView.builder(
    //             itemBuilder: (context, i) => OrderItem(
    //               order: ordersData.orders[i],
    //             ),
    //             itemCount: ordersData.orders.length,
    //           ),
    //         );
    //       }
    //     }
    //   },
    // ),
  }
}
