import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Cart.dart';
import 'package:shop_app/providers/product.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    // this.id,
    // this.title,
    // this.imageUrl,
  }) : super(key: key);
  // final String? id;
  // final String? title;
  // final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScree.routename,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl!,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite! ? Icons.favorite : Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                product.toggleFavoriteStatus();
              },
            ),
          ),
          title: Text(
            product.title!,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.additem(product.id!, product.price!, product.title!);
            },
          ),
        ),
      ),
    );
  }
}
