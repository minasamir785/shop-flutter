import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_complete_guide/Models/Product.dart';

import 'package:flutter_complete_guide/UnUsed/TitleWidget.dart';

class ProductDetails extends StatelessWidget {
  // const ProductDetails({Key key}) : super(key: key);
  static const String routeName = "/ProductDetails";
  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final myProduct = (ModalRoute.of(context).settings.arguments
        as Map)["product"] as Product;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // collapsedHeight: mediaQueryHeight * 0.05,
            expandedHeight: mediaQueryHeight * 0.35,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: myProduct.id,
                child: Container(
                  height: mediaQueryHeight * 0.25,
                  child: Image.network(
                    myProduct.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              title: Text(
                myProduct.title,
                style: TextStyle(color: Color.fromARGB(137, 31, 0, 0)),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              margin: const EdgeInsets.all(15),
              child: Text(
                "\$" + myProduct.price.toString(),
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              child: Text(
                myProduct.description,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ]))
        ],
      ),
    );
  }
}
