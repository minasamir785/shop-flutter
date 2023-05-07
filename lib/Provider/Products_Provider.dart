import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Models/Delete_Error.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Models/Product.dart';

class ProductsProvider with ChangeNotifier {
  var _productsList = <Product>[
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

  String tokeAuth;
  String _userId;
  set authToken(String value) {
    tokeAuth = value;
  }

  set userId(String value) {
    _userId = value;
  }

  List<Product> get favouriteList {
    return _productsList.where((element) => element.isFavourite).toList();
  }

  List<Product> get productsList {
    return [..._productsList];
  }

  Future<void> fetchProducts() async {
    var url = Uri.parse(
        "https://shop-74aef-default-rtdb.firebaseio.com/Products.json?auth=${tokeAuth}&" +
            'orderBy="creatorId"&equalTo="$_userId"');
    var urlFav = Uri.parse(
        "https://shop-74aef-default-rtdb.firebaseio.com/FavState/${_userId}.json?auth=${tokeAuth}");
    try {
      var respond = await http.get(url);
      var respondFav = json.decode((await http.get(urlFav)).body);
      print(respondFav);
      var extracted = json.decode(respond.body) as Map<String, dynamic>;
      List<Product> fetchedProducts = [];
      print(extracted);
      extracted.forEach((key, value) {
        fetchedProducts.add(
          Product(
            description: value["description"],
            id: key,
            imageUrl: value["imageUrl"],
            price: value["price"],
            title: value["title"],
            isFavourite: respondFav == null ? false : respondFav[key] ?? false,
          ),
        );
      });
      _productsList = fetchedProducts;
      notifyListeners();
      // return fetchedProducts;
    } catch (error) {
      print("error");
      print(error);
      throw error;
    }
  }

  void addFavourite(String id) async {
    var _temp = _productsList.indexWhere((element) => element.id == id);
    try {
      final url = Uri.parse(
          "https://shop-74aef-default-rtdb.firebaseio.com/FavState/${_userId}.json?auth=${tokeAuth}");
      var respond = await http.patch(
        url,
        body: json.encode(
          {id: !_productsList[_temp].isFavourite},
        ),
      );

      if (((json.decode(respond.body) as Map))[id] == null) {
        throw "error";
      }
      _productsList[_temp].addFavourite();
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addProduct(Product value) async {
    if (value.id != null) {
      // http
      try {
        final url = Uri.parse(
            "https://shop-74aef-default-rtdb.firebaseio.com/Products/${value.id}.json?auth=${tokeAuth}");
        await http
            .patch(
          url,
          body: json.encode(
            {
              "title": value.title,
              "price": value.price,
              "description": value.description,
              "imageUrl": value.imageUrl,
            },
          ),
        )
            .then((respond) {
          //local
          print(value.id);
          print(json.decode(respond.body));
          var _temp =
              _productsList.indexWhere((element) => element.id == value.id);

          _productsList[_temp] = value;
        });
        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    } else {
      try {
        final url = Uri.parse(
            "https://shop-74aef-default-rtdb.firebaseio.com/Products.json?auth=${tokeAuth}");
        var respond = await http.post(url,
            body: json.encode({
              "creatorId": _userId,
              "title": value.title,
              "price": value.price,
              "description": value.description,
              "imageUrl": value.imageUrl,
              "isFavourite": value.isFavourite,
            }));

        var temp = Product(
          id: json.decode(respond.body)["name"],
          description: value.description,
          price: value.price,
          imageUrl: value.imageUrl,
          title: value.title,
        );
        _productsList.add(temp);
        for (var e in _productsList) {
          print(e.id);
          print(e.description);

          print(e.price);
          print(e.imageUrl);
          print(e.title);
        }

        notifyListeners();
      } catch (error) {
        print(error);
        throw error;
      }
    }
  }

  void deleteProduct(String id) async {
    try {
      final url = Uri.parse(
          "https://shop-74aef-default-rtdb.firebaseio.com/Products/${id}.json?auth=${tokeAuth}");
      await http.delete(url).then(
        (respond) {
          //local
          if (respond.statusCode >= 400) {
            throw HttpException("Something Went Wrong");
          }
          _productsList.removeWhere((element) => element.id == id);
        },
      );
      notifyListeners();
    } catch (_) {
      print(_);
      throw _;
    }
  }
}
