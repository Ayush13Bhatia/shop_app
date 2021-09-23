import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  bool? isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });
  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite!;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('userFavorites')
          .doc(userId)
          .set({
        "isFavorite": isFavorite,
      });
      print('!!!!!!!Ayush!!!!!!!!');
      print(userId);
      print(id);
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
