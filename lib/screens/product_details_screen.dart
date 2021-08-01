import 'package:flutter/material.dart';

class ProductDetailsScree extends StatelessWidget {
  const ProductDetailsScree({
    Key? key,
  }) : super(key: key);
  static const routename = '/product-details';
  // final String? title;

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
    );
  }
}
