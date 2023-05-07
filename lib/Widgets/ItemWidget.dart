import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Models/Product.dart';
import 'package:flutter_complete_guide/Provider/Cart.dart';
import 'package:flutter_complete_guide/Provider/Products_Provider.dart';
import 'package:flutter_complete_guide/Screens/ProductDetails.dart';
import 'package:provider/provider.dart';

void moveToDetails(context, myProduct) {
  Navigator.of(context).pushNamed(
    ProductDetails.routeName,
    arguments: {
      "product": myProduct,
    },
  );
}

class ItemWidget extends StatefulWidget {
  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  var waiting = false;
  @override
  Widget build(BuildContext context) {
    final myProduct = Provider.of<Product>(context, listen: false);

    return InkWell(
      onTap: (() => moveToDetails(context, myProduct)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Consumer<Product>(
          builder: (context, value, child) => GridTile(
            footer: GridTileBar(
              leading: waiting
                  ? Container(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                  : IconButton(
                      icon: Icon(
                        (myProduct.isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border),
                        color: Theme.of(context).canvasColor,
                      ),
                      onPressed: () async {
                        try {
                          setState(() {
                            waiting = true;
                          });

                          await Provider.of<ProductsProvider>(context,
                                  listen: false)
                              .addFavourite(value.id);

                          setState(() {
                            waiting = false;
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Something Went wrong Try again!'),
                          ));
                        }
                      },
                    ),
              backgroundColor: Colors.black54,
              title: Text(
                myProduct.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              trailing: Consumer<Cart>(
                builder: (context, cart, child) => IconButton(
                  onPressed: () {
                    cart.addCartItem(
                        myProduct.id, myProduct.title, myProduct.price, 1);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Item added!'),
                        duration: Duration(seconds: 1),
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            cart.reduceItem(myProduct.id);
                          },
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    cart.items.keys.contains(myProduct.id)
                        ? Icons.shopping_cart
                        : Icons.add_shopping_cart_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            child: Hero(
              tag: myProduct.id,
              child: FittedBox(
                child: Image.network(
                  myProduct.imageUrl,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
