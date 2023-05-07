import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Models/Product.dart';
import 'package:flutter_complete_guide/Provider/Products_Provider.dart';
import 'package:flutter_complete_guide/Screens/Add_Product.dart';
import 'package:flutter_complete_guide/Widgets/ItemWidget.dart';
import 'package:flutter_complete_guide/Widgets/ManageItemWidget.dart';

import 'package:provider/provider.dart';

const String routename = "/Orders-Screen";

class ManageProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myproducts = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddProduct.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
        title: Text(
          "Manage",
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ManageItemWidget(
            item: myproducts.productsList[index],
          );
        },
        itemCount: myproducts.productsList.length,
      ),
    );
  }
}
