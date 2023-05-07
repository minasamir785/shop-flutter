import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key key,
    @required this.mediaQueryHeight,
    @required this.isLandscape,
    @required this.mediaQueryWidth,
    @required this.title,
  }) : super(key: key);

  final double mediaQueryHeight;
  final bool isLandscape;
  final double mediaQueryWidth;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaQueryHeight * (isLandscape ? 0.15 : 0.05),
      margin: EdgeInsets.only(
          top: mediaQueryWidth * 0.05, left: mediaQueryWidth * 0.05),
      child: Text(
        this.title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
