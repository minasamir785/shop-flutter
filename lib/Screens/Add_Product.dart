import 'package:flutter/material.dart';

import 'package:flutter_complete_guide/Models/Product.dart';
import 'package:flutter_complete_guide/Provider/Products_Provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_loader/easy_loader.dart';

class AddProduct extends StatefulWidget {
  static const routeName = "/Add-Product";

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var _initializing = true;
  var _priceFouce = FocusNode();
  var _discriptionFouce = FocusNode();
  var _imageUrlFouce = FocusNode();
  var imgUrl = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var tempProduct = Product(
    description: "",
    id: null,
    imageUrl: "",
    price: 0,
    title: "",
  );
  var _loading = false;
  @override
  void initState() {
    _imageUrlFouce.addListener(updateUrl);
    super.initState();
  }

  void updateUrl() {
    setState(() {});
  }

  @override
  void dispose() {
    imgUrl.removeListener(() {});
    _imageUrlFouce.dispose();
    _priceFouce.dispose();
    _discriptionFouce.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_initializing) {
      final _item = ModalRoute.of(context).settings.arguments as Product;
      if (_item != null) {
        tempProduct = Product(
          description: _item.description,
          id: _item.id,
          imageUrl: _item.imageUrl,
          price: _item.price,
          title: _item.title,
        );
        imgUrl.text = _item.imageUrl;
      } else {
        tempProduct = Product(
          description: "",
          id: null,
          imageUrl: "",
          price: 0,
          title: "",
        );
      }
      _initializing = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final myProductsProvider = Provider.of<ProductsProvider>(context);
    //
    Future<void> saveFormData() async {
      print(!_formKey.currentState.validate());
      if (!_formKey.currentState.validate()) {
        return;
      }
      setState(() {
        _loading = true;
      });

      _formKey.currentState.save();
      try {
        await myProductsProvider.addProduct(tempProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Something went wrong!"),
            content: Text(error.toString()),
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
      } finally {
        Navigator.of(context).pop();
      }
    }

    ;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Product"),
        actions: [
          IconButton(
            onPressed: (() {
              saveFormData();
            }),
            icon: Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue:
                            tempProduct.title != "" ? tempProduct.title : null,
                        decoration: InputDecoration(
                          label: Text("Title"),
                        ),
                        // keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFouce);
                        },
                        onSaved: (newValue) {
                          tempProduct = Product(
                            description: tempProduct.description,
                            id: tempProduct.id,
                            imageUrl: tempProduct.imageUrl,
                            price: tempProduct.price,
                            title: newValue,
                            isFavourite: tempProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Description";
                          }
                          if (value.length > 15) {
                            return "Please Enter at Most 15 Character";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: tempProduct.price != 0
                            ? tempProduct.price.toString()
                            : null,
                        decoration: InputDecoration(
                          label: Text("Price"),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFouce,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_discriptionFouce);
                        },
                        onSaved: (newValue) {
                          tempProduct = Product(
                            description: tempProduct.description,
                            id: tempProduct.id,
                            imageUrl: tempProduct.imageUrl,
                            price: num.parse(newValue),
                            title: tempProduct.title,
                            isFavourite: tempProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Description";
                          }

                          if (num.tryParse(value) == null) {
                            return "Please Enter a valid Price";
                          }
                          if (num.parse(value) < 10) {
                            return "The Price should be at Least \$ 10";
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: tempProduct.description != ""
                            ? tempProduct.description
                            : null,
                        decoration: InputDecoration(
                          label: Text("Description"),
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _discriptionFouce,
                        onSaved: (newValue) {
                          tempProduct = Product(
                            description: newValue,
                            id: tempProduct.id,
                            imageUrl: tempProduct.imageUrl,
                            price: tempProduct.price,
                            title: tempProduct.title,
                            isFavourite: tempProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Description";
                          }
                          if (value.length < 20) {
                            return "Please Enter at  least 20 Character";
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: imgUrl.text.isEmpty
                                ? Center(
                                    child: Text("Input A Url Please!"),
                                  )
                                : Image.network(
                                    imgUrl.text,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Text('Your error widget...');
                                    },
                                  ),
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.35,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                label: Text("Image Url"),
                              ),
                              controller: imgUrl,
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFouce,
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSaved: (newValue) {
                                tempProduct = Product(
                                  description: tempProduct.description,
                                  id: tempProduct.id,
                                  imageUrl: newValue,
                                  price: tempProduct.price,
                                  title: tempProduct.title,
                                  isFavourite: tempProduct.isFavourite,
                                );
                              },
                              onFieldSubmitted: (value) {
                                saveFormData();
                              },
                              validator: (value) {
                                var urlPattern =
                                    r"(http(s?):)([/|.|\w|\s|-])*\.";
                                var result =
                                    new RegExp(urlPattern, caseSensitive: false)
                                        .firstMatch(value);
                                if (value.isEmpty) {
                                  return "Please Enter Url";
                                }
                                if (result == null) {
                                  return "Please Enter a Valid Url";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
