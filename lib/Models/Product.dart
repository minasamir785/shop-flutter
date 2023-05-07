import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final num price;
  final String imageUrl;
  bool isFavourite;
  Product({
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    this.isFavourite = false,
    @required this.price,
    @required this.title,
  });

  void addFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
