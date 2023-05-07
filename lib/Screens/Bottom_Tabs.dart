import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Provider/auth.dart';
import 'package:flutter_complete_guide/Screens/Manage.dart';
import 'package:flutter_complete_guide/Screens/Orders_Screen.dart';

import 'package:flutter_complete_guide/Screens/Product_OverView.dart';
import 'package:provider/provider.dart';

class BottomTabs extends StatefulWidget {
  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  @override
  int _current = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(
            color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
        selectedItemColor: Theme.of(context).primaryColor,
        showUnselectedLabels: true,
        currentIndex: _current,
        onTap: (value) {
          setState(() {
            _current = value;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopify),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Log Out',
          ),
        ],
      ),
      body: _current == 0
          ? ProductsOverView()
          : (_current == 1
              ? OrderScreen()
              : (_current == 2 ? ManageProducts() : LogOutWidget())),
    );
  }
}

class LogOutWidget extends StatefulWidget {
  const LogOutWidget({Key key}) : super(key: key);

  @override
  State<LogOutWidget> createState() => _LogOutWidgetState();
}

class _LogOutWidgetState extends State<LogOutWidget> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      // Navigator.of(context).pop();
      setState(() {
        Provider.of<Auth>(context, listen: false).logout();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //

    return Container();
  }
}
