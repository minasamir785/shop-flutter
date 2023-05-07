// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Provider/Cart.dart';
import 'package:flutter_complete_guide/Provider/Order.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 5,
        // vertical: 5,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 195, 255).withOpacity(0.2),
            Color.fromARGB(255, 255, 255, 28).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: ChildWidget(cart: cart),
    );
  }
}

class ChildWidget extends StatefulWidget {
  const ChildWidget({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<ChildWidget> createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total",
          style: Theme.of(context).textTheme.headline6,
        ),
        Spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.all(15),
          child: Text(
            "\$${widget.cart.totalQuantity.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 43, 129, 128),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        _loading
            ? Container(
                margin: EdgeInsets.all(20),
                child: CircularProgressIndicator(color: Colors.green),
                height: 30,
                width: 30,
              )
            : TextButton(
                onPressed: widget.cart.items.values.toList().length == 0
                    ? null
                    : () async {
                        try {
                          setState(() {
                            _loading = true;
                          });
                          await Provider.of<Order>(context, listen: false)
                              .addOrder(
                            widget.cart.items.values.toList(),
                            double.tryParse(
                                widget.cart.totalQuantity.toStringAsFixed(2)),
                          );
                          widget.cart.clearCart();
                        } catch (e) {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Something Went Wrong"),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text("OK"))
                                  ],
                                );
                              });
                        }
                        setState(() {
                          _loading = false;
                        });
                      },
                child: Text(
                  "Order Now",
                  style: widget.cart.items.values.toList().length == 0
                      ? Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Colors.grey)
                      : Theme.of(context).textTheme.headline4,
                ),
              ),
      ],
    );
  }
}
