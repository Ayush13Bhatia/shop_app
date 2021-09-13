import 'dart:async';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'product.dart';

// haveenta
// castor oil
// clerify ml(ai)
class Products with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showOnlyFavorite = false;

  List<Product> get items {
    // if (_showOnlyFavorite) {
    //   return _items.where((prod) => prod.isFavorite!).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite!).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoriteOnly() {
  //   _showOnlyFavorite = true;
  // }

  // void show() {
  //   _showOnlyFavorite = false;
  // }

  Future<void> fetchAndSetProducts() async {
    try {
      FirebaseFirestore.instance
          .collection('products')
          .snapshots()
          .listen((snapshot) {
        List<Product> _loadedProducts = [];
        snapshot.docs.forEach((document) {
          _loadedProducts.add(
            Product(
              description: document.data()['description'],
              price: document.data()['price'],
              title: document.data()['title'],
              isFavorite: document.data()['isFavorite'],
              imageUrl: document.data()['imageUrl'],
              id: document.id,
            ),
          );
        });
        // print('*******Ayush*******');
        // print(_loadedProducts);
        _items = _loadedProducts;
        // print(_items);
      });

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      CollectionReference products =
          FirebaseFirestore.instance.collection('products');
      final response = await products.add(<String, dynamic>{
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      });
      print(response.id);
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: response.id,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct);   // at start of the list

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void updatProduct(String id, Product newProduct) {
    final prodIndex = items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('......');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
