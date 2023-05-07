import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Models/Product.dart';
import 'package:http/http.dart';

import '../Provider/Products_Provider.dart';
import '../Widgets/ItemWidget.dart';

import 'package:provider/provider.dart';

enum OptionsFilter {
  All,
  Favorites,
}

class OverViewProducts extends StatefulWidget {
  final isfavourite;

  OverViewProducts({this.isfavourite});

  @override
  State<OverViewProducts> createState() => _OverViewProductsState();
}

class _OverViewProductsState extends State<OverViewProducts> {
  var _isLoading = false;
  var _init = true;

  Future<void> _getdata(bool check) async {
    if (check) {
      try {
        _isLoading = true;

        await Provider.of<ProductsProvider>(context, listen: false)
            .fetchProducts()
            .then((value) {
          _isLoading = false;
        });
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Something went wrong!"),
            content: Text("Check Your Inertent Connection and Try again"),
            actions: [
              ElevatedButton(
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
                child: Text("Ok"),
              ),
            ],
          ),
        );
      }
      check = false;
    }
  }

  @override
  void didChangeDependencies() async {
    if (_init) {
      _getdata(_init);
      print("Finishedd");
      _init = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var myProductsList = Provider.of<ProductsProvider>(context);

    var itemsList = widget.isfavourite
        ? myProductsList.favouriteList
        : myProductsList.productsList;

    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              setState(() {
                var tempcheck = true;
                _getdata(tempcheck);
              });
            },
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaQueryHeight * 0.01,
                      ),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisExtent: 300,
                        maxCrossAxisExtent: 350,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: itemsList[index],
                          child: ItemWidget(),
                        );
                      },
                      itemCount: itemsList.length),
                ),
              ],
            ),
          );
  }
}
