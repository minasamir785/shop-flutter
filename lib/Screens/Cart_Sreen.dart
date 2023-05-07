import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Provider/Cart.dart';
import 'package:flutter_complete_guide/Widgets/CartHeader.dart';
import 'package:flutter_complete_guide/Widgets/CartWidget.dart';
import 'package:flutter_complete_guide/Widgets/cartItem.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/Cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Column(
        children: [
          Container(
            child: CartWidget(
              cart: cart,
            ),
          ),
          CartHeader(),
          Expanded(
            child: cart.items.length == 0
                ? Container()
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1 / 0.25,
                        crossAxisCount: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return CartItemWidget(cart.items.values.toList()[index],
                          cart.items.keys.toList()[index]);
                    },
                    itemCount: cart.items.length,
                  ),
          ),
        ],
      ),
    );
  }
}
