import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Provider/Cart.dart';

class CartHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(
              5,
            ),
            child: Center(
              child: Text(
                "Price",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 18),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(
              5,
            ),
            child: Center(
              child: Text(
                "Name",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 18),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(
              5,
            ),
            child: Center(
              child: Text(
                "Quantity",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
