import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Widgets/OrderItem.dart';
import '../Provider/Order.dart';
import 'package:provider/provider.dart';

const String routename = "/Orders-Screen";

class OrderScreen extends StatefulWidget {
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _loading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        _loading = true;
      });
      await Provider.of<Order>(context, listen: false).fetchAndUpdate();
      setState(() {
        _loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localOrders = Provider.of<Order>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Orders",
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              // ignore: missing_return
              onRefresh: () async {
                setState(() {
                  _loading = true;
                });
                await Provider.of<Order>(context, listen: false)
                    .fetchAndUpdate();
                setState(() {
                  _loading = false;
                });
              },
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return OrderItemWidget(
                    item: localOrders.ordersList.values.toList()[index],
                    id: localOrders.ordersList.keys.toList()[index],
                    MapId: index,
                  );
                },
                itemCount: localOrders.ordersList.length,
              ),
            ),
    );
  }
}
