import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Models/Product.dart';
import 'package:flutter_complete_guide/UnUsed/TitleWidget.dart';

class CustomPage extends StatelessWidget {
  const CustomPage({
    Key key,
    @required this.title,
    @required this.myWidget,
    @required this.mediaQueryHeight,
    @required this.isLandscape,
    @required this.mediaQueryWidth,
    @required this.customAppBar,
  }) : super(key: key);
  final String title;
  final List<Widget> myWidget;
  final double mediaQueryHeight;
  final bool isLandscape;
  final double mediaQueryWidth;
  final List<Widget> customAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: mediaQueryHeight * 0.03,
          ),
          Row(
            children: [...customAppBar],
          ),
          ...myWidget,
        ],
      ),
    );
  }
}
