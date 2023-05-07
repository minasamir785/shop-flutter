import 'package:flutter_complete_guide/Provider/Cart.dart';
import 'package:flutter_complete_guide/Screens/Cart_Sreen.dart';
import 'package:flutter_complete_guide/Widgets/OverViewProducts.dart';
import '../Widgets/badge.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

enum OptionsFilter {
  All,
  Favorites,
}

class ProductsOverView extends StatefulWidget {
  @override
  State<ProductsOverView> createState() => _ProductsOverViewState();
}

class _ProductsOverViewState extends State<ProductsOverView> {
  bool _isfavourite = false;

  @override
  Widget build(BuildContext context) {
    Widget popUpMenuAppBar = PopupMenuButton<OptionsFilter>(
      onSelected: (OptionsFilter value) {
        setState(() {
          if (value == OptionsFilter.Favorites) {
            _isfavourite = true;
          } else {
            _isfavourite = false;
          }
        });
      },
      elevation: 2,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: OptionsFilter.Favorites,
          child: Row(
            children: [
              Icon(Icons.star),
              SizedBox(
                width: 10,
              ),
              Text("Favorites")
            ],
          ),
        ),
        // PopupMenuItem 2
        PopupMenuItem(
          value: OptionsFilter.All,
          child: Row(
            children: [
              Icon(Icons.category),
              SizedBox(
                width: 10,
              ),
              Text("All")
            ],
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          Consumer<Cart>(
            builder: (context, value, child) => myBadge(
              child: IconButton(
                onPressed: (() {
                  Navigator.of(context).pushNamed(
                    CartScreen.routeName,
                  );
                }),
                icon: Icon(Icons.shopping_cart, size: 35),
              ),
              value: value.itemsCount.toString(),
              color: Theme.of(context).errorColor,
            ),
          ),
          popUpMenuAppBar,
        ],
      ),
      body: OverViewProducts(isfavourite: _isfavourite),
    );
  }
}
