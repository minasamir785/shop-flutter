import 'package:flutter/material.dart';

import 'package:flutter_complete_guide/Provider/Cart.dart';
import 'package:flutter_complete_guide/Provider/Order.dart';
import 'package:flutter_complete_guide/Provider/Products_Provider.dart';
import 'package:flutter_complete_guide/Provider/auth.dart';
import 'package:flutter_complete_guide/Screens/Add_Product.dart';
import 'package:flutter_complete_guide/Screens/Bottom_Tabs.dart';
import 'package:flutter_complete_guide/Screens/Cart_Sreen.dart';
import 'package:flutter_complete_guide/Screens/ProductDetails.dart';
import 'package:flutter_complete_guide/Screens/auth_screen.dart';

import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            create: (ctx) => ProductsProvider(),
            update: (ctx, auth, previousProduct) {
              previousProduct.userId = auth.userId;
              return previousProduct..authToken = auth.token;
            }),
        ChangeNotifierProxyProvider<Auth, Order>(
            create: (ctx) => Order(),
            update: (ctx, auth, previousOrder) {
              previousOrder.userId = auth.userId;
              return previousOrder..authToken = auth.token;
            }),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          // primarySwatch: (Color.fromARGB(255, 43, 129, 128)!,
          primaryColor: Color.fromARGB(255, 43, 129, 128),
          colorScheme: ColorScheme.light().copyWith(
            primary: Color.fromARGB(255, 43, 129, 128),
          ),
          appBarTheme: AppBarTheme(
            foregroundColor: Color.fromARGB(255, 43, 129, 128),
            color: Colors.white,
            elevation: 0,
          ),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Color.fromARGB(255, 43, 129, 128),
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
            headline4: TextStyle(
              color: Color.fromARGB(255, 43, 129, 128),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            headline5: TextStyle(
              color: Colors.amber,
              fontSize: 20,
            ),
          ),
        ),
        home: MyHomePage(),
        routes: {
          ProductDetails.routeName: (context) => ProductDetails(),
          CartScreen.routeName: (context) => CartScreen(),
          AddProduct.routeName: (context) => AddProduct(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _loading = false;
  @override
  void initState() {
    setState(() {
      _loading = true;
    });
    Provider.of<Auth>(context, listen: false).tryAutoLogIn();
    setState(() {
      _loading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
        builder: (context, auth, child) => auth.IsAuth
            ? AuthScreen()
            : (_loading
                ? Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : BottomTabs()));
  }
}
