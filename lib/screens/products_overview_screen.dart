import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../providers/products.dart';

enum FilterOption {
  Favorite,
  All,
}

class ProductverViewScreen extends StatefulWidget {
  ProductverViewScreen({Key? key}) : super(key: key);

  @override
  _ProductverViewScreenState createState() => _ProductverViewScreenState();
}

class _ProductverViewScreenState extends State<ProductverViewScreen> {
  var _showOnlyFavorite = false;
  var _isInit = true;
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Products>(context, listen: false).fetchAndSetProducts();
    });
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  //   }
  //   _isInit = false;
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOption selectedValue) {
                setState(() {
                  if (selectedValue == FilterOption.Favorite) {
                    _showOnlyFavorite = true;
                  } else {
                    _showOnlyFavorite = false;
                  }
                });
              },
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text("My favorite"),
                        value: FilterOption.Favorite),
                    PopupMenuItem(
                        child: Text("Show All"), value: FilterOption.All),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawers(),
      body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: ProductGrid(showFav: _showOnlyFavorite)),
    );
  }
}
