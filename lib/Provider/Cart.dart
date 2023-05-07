import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final num price;
  final int quantity;
  CartItem({
    this.id,
    this.price,
    this.quantity,
    this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  num get totalQuantity {
    return _items.isEmpty
        ? 0
        : _items.values
            .map((e) => e.quantity * e.price)
            .toList()
            .reduce((value, element) => element + value);
  }

  int get itemsCount {
    return _items.isEmpty
        ? 0
        : _items.values
            .map((e) => e.quantity)
            .toList()
            .reduce((value, element) => element + value);
  }

  void addCartItem(String id, String title, num price, int quantity) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (value) => CartItem(
          id: DateTime.now().toString(),
          price: value.price,
          quantity: value.quantity + 1,
          title: value.title,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          quantity: 1,
          title: title,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(id) {
    _items.remove(id);
    notifyListeners();
  }

  void reduceItem(id) {
    _items.update(
      id,
      (value) => CartItem(
        id: DateTime.now().toString(),
        price: value.price,
        quantity: value.quantity - 1,
        title: value.title,
      ),
    );
    if (_items[id].quantity == 0) {
      _items.remove(id);
    }

    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
