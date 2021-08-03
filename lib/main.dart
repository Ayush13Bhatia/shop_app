import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/products_overview_screen.dart';
import '../screens/product_details_screen.dart';
import 'providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Products(),
      child: MaterialApp(
        title: "Shop App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: "Lato",
        ),
        home: ProductverViewScreen(),
        routes: {
          ProductDetailsScree.routename: (context) => ProductDetailsScree(),
        },
      ),
    );
  }
}
