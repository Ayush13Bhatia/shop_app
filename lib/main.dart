import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart' as firebase_core;

import '../screens/auth_screen.dart';
import '../providers/auth.dart';
import '../screens/add_product_scree.dart';
import '../screens/edit_product_screen.dart';
import '../screens/user_product_screen.dart';
import '../screens/order_screen.dart';
import '../providers/order.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';
// import '../screens/products_overview_screen.dart';
import '../screens/product_details_screen.dart';
import '../providers/products.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        )
      ],
      child: MaterialApp(
        title: "Shop App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: "Lato",
        ),
        home: AuthScreen(),
        routes: {
          ProductDetailsScree.routename: (context) => ProductDetailsScree(),
          CartScreen.routeName: (context) => CartScreen(),
          OrderScreen.routeName: (context) => OrderScreen(),
          UserProductScreen.routeName: (context) => UserProductScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
          AddProductScreen.routeName: (context) => AddProductScreen(),
        },
      ),
    );
  }
}
