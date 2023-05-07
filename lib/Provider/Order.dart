import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/Models/Delete_Error.dart';
import './Cart.dart';
import 'package:http/http.dart' as http;

class myorder {
  final String id;
  final num amount;
  final List<CartItem> products;
  final DateTime dateTime;
  myorder({
    this.id,
    this.amount,
    this.dateTime,
    this.products,
  });
}

class Order with ChangeNotifier {
  Map<String, myorder> _ordersList = {};
  Map<String, myorder> get ordersList {
    return Map.from(_ordersList);
  }

  String tokeAuth;
  String _userId;

  set userId(String value) {
    _userId = value;
  }

  set authToken(String value) {
    tokeAuth = value;
  }

  void addOrder(List<CartItem> products, double total) async {
// class CartItem {
//   final String id;
//   final String title;
//   final num price;
//   final int quantity;
    var currentTime = DateTime.now();
    var url = Uri.parse(
        "https://shop-74aef-default-rtdb.firebaseio.com/Orders.json?auth=${tokeAuth}");

    try {
      var orderBody = {
        "creatorId": _userId,
        "amount": total,
        "products": json.encode(
          products.map(
            (e) {
              return {
                "id": e.id,
                "price": e.price.toString(),
                "quantity": e.quantity.toString(),
                "title": e.title,
              };
            },
          ).toList(),
        ),
        "dateTime": currentTime.toIso8601String(),
      };
      var respond = await http.post(url, body: json.encode(orderBody));
      _ordersList[currentTime.toString()] = myorder(
        id: json.decode(respond.body)["name"],
        amount: total,
        products: products,
        dateTime: currentTime,
      );
      print("#########Respond is ");
      print(json.decode(respond.statusCode.toString()));
      notifyListeners();
    } catch (error) {
      print("#########error is ");
      print("____________" + error);
      throw HttpException("error");
    }
  }

  void confirmOrder(String index) async {
    var url = Uri.parse(
        "https://shop-74aef-default-rtdb.firebaseio.com/Orders/${index}.json?auth=${tokeAuth}");
    try {
      http.delete(url);
    } catch (e) {
      print(e);
      throw e;
    }

    _ordersList.remove(index);
    notifyListeners();
  }

  void fetchAndUpdate() async {
    var url = Uri.parse(
        "https://shop-74aef-default-rtdb.firebaseio.com/Orders.json?auth=${tokeAuth}&" +
            'orderBy="creatorId"&equalTo="$_userId"');
    var respond =
        json.decode((await http.get(url)).body) as Map<String, dynamic>;
    var fetchedOrders = Map();
    print(respond);
    if (respond != null) {
      respond.forEach((key, value) {
        print(key);
        fetchedOrders.putIfAbsent(
            key as String,
            () => myorder(
                  amount: value["amount"],
                  dateTime: DateTime.parse(value["dateTime"]),
                  products: (json.decode(value["products"]) as List<dynamic>)
                      .map((e) {
                    return CartItem(
                        id: e["id"],
                        price: num.parse(e["price"]),
                        quantity: int.parse(e["quantity"]),
                        title: e["title"]);
                  }).toList(),
                ));

        notifyListeners();
        return;

        // return key;
      });
      _ordersList = {};
      fetchedOrders != null
          ? fetchedOrders.forEach((key, value) {
              _ordersList[key] = value;
            })
          : null;
      // _ordersList = fetchedOrders;
    }
    notifyListeners();
  }
}
