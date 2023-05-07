import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Models/Product.dart';
import 'package:flutter_complete_guide/Provider/Products_Provider.dart';
import 'package:flutter_complete_guide/Screens/Add_Product.dart';
import 'package:provider/provider.dart';

class ManageItemWidget extends StatelessWidget {
  final Product item;
  ManageItemWidget({this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            Colors.yellow.withOpacity(0.2),
            Theme.of(context).primaryColor.withOpacity(0.2),
          ],
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.imageUrl),
        ),
        title: Text(item.title),
        trailing: LayoutBuilder(
          builder: (p0, p1) {
            return Container(
              width: p1.maxWidth * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AddProduct.routeName,
                        arguments: item,
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).errorColor,
                    ),
                    onPressed: () async {
                      try {
                        await Provider.of<ProductsProvider>(context,
                                listen: false)
                            .deleteProduct(item.id);
                      } catch (error) {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Something went wrong!"),
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
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
