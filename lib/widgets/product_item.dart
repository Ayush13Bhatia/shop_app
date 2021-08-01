import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key, this.id, this.title, this.imageUrl})
      : super(key: key);
  final String? id;
  final String? title;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: Image.network(
      imageUrl!,
    ));
  }
}
