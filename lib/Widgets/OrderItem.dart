import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Models/Product.dart';

import 'package:flutter_complete_guide/Provider/Cart.dart';
import 'package:flutter_complete_guide/Provider/Order.dart';
import 'package:flutter_complete_guide/Provider/Products_Provider.dart';
import 'package:flutter_complete_guide/Widgets/cartItem.dart';
import 'package:flutter_complete_guide/Widgets/CartItemInOrders.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OrderItemWidget extends StatefulWidget {
  myorder item;
  final String id;
  final int MapId;
  OrderItemWidget({
    this.item,
    this.id,
    this.MapId,
  });

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.id),
      movementDuration: Duration(
        seconds: 0,
      ),
      background: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Icon(
          Icons.shopping_cart_checkout_sharp,
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
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        try {
          await Provider.of<Order>(context, listen: false)
              .confirmOrder(this.widget.id);
        } catch (e) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Something Went Wrong"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"))
              ],
            ),
          );
        }
      },
      child: Column(children: [
        _ItemWidget(item: widget.item, index: widget.MapId),
        SizedBox(
          height: 20,
        )
      ]),
    );
  }
}

class _ItemWidget extends StatefulWidget {
  const _ItemWidget({
    Key key,
    @required this.item,
    @required this.index,
  }) : super(key: key);

  final myorder item;
  final int index;

  @override
  State<_ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<_ItemWidget>
    with SingleTickerProviderStateMixin {
  int get totalOfItem {
    return this
        .widget
        .item
        .products
        .map((e) => e.quantity)
        .toList()
        .reduce((value, element) => value + element);
  }

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(begin: Offset(0, -0.3), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    ));
    _offsetAnimation.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var _showMore = false;
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
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (widget.index + 1).toString(),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 25,
                        ),
                  ),
                  Container(
                    child: Text(
                      "Required  " + "\$" + widget.item.amount.toString(),
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(200, 43, 129, 128),
                      borderRadius: BorderRadius.circular(20),
                      // shape: BoxShape.circle,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "items: " + totalOfItem.toString(),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 25,
                        ),
                  ),
                  IconButton(
                    icon: Icon(Icons.expand_more,
                        color: Theme.of(context).primaryColor),
                    onPressed: () {
                      setState(() {
                        _showMore = !_showMore;
                        print(_showMore);
                        if (_showMore) {
                          _controller.forward();
                        } else {
                          _controller.reverse();
                        }
                      });
                    },
                  ),
                ],
              ),
              if (_showMore)
                ...(this.widget.item.products.map((e) {
                  return SlideTransition(
                      position: _offsetAnimation,
                      child: CartItemWidgetInOrder(e, null, _showMore));
                }).toList())
            ],
          ),
        ),
      ),
    );
  }
}

String idget(String name) {
  var x =
      myproductsList.where((e) => e.title == name).toList() as List<Product>;
  return x[0].id;
}

var myproductsList = <Product>[
  Product(
    id: 'p1',
    title: 'Red Shirt',
    description: 'A red shirt - it is pretty red!',
    price: 29.99,
    imageUrl:
        'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  ),
  Product(
    id: 'p2',
    title: 'Trousers',
    description: 'A nice pair of trousers.',
    price: 59.99,
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  ),
  Product(
    id: 'p3',
    title: 'Yellow Scarf',
    description: 'Warm and cozy - exactly what you need for the winter.',
    price: 19.99,
    imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  ),
  Product(
    id: 'p4',
    title: 'A Pan',
    description: 'Prepare any meal you want.',
    price: 49.99,
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  ),
];
