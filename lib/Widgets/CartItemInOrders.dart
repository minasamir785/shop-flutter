import 'package:flutter/material.dart';

import 'package:flutter_complete_guide/Provider/Cart.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CartItemWidgetInOrder extends StatefulWidget {
  CartItem item;
  final String id;
  final bool trans;
  CartItemWidgetInOrder(
    this.item,
    this.id,
    this.trans,
  );

  @override
  State<CartItemWidgetInOrder> createState() => _CartItemWidgetInOrderState();
}

class _CartItemWidgetInOrderState extends State<CartItemWidgetInOrder> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.id),
      movementDuration: Duration(
        seconds: 0,
      ),
      background: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).errorColor,
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.none,
      onDismissed: (direction) {
        setState(() {
          Provider.of<Cart>(context, listen: false).removeItem(this.widget.id);
        });
      },
      child: _ItemWidget(item: widget.item),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Color.fromARGB(255, 255, 255, 28).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: Center(
        child: ListTile(
          leading: Container(
            child: Text(
              item.price.toStringAsFixed(2),
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(200, 43, 129, 128),
              borderRadius: BorderRadius.circular(20),
              // shape: BoxShape.circle,
            ),
          ),
          title: Text(
            item.title,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontSize: 25,
                ),
          ),
          trailing: Text(
            item.quantity.toString(),
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontSize: 25,
                ),
          ),
        ),
      ),
    );
  }
}
