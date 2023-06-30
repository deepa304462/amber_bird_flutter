import 'package:flutter/material.dart';

class ShowcaseKey {
  ShowcaseKey({
    required this.key,
    required this.desc,
    required this.title,
    required this.titleTextStyle,
    required this.descTextStyle,
    dynamic targetPadding,
    dynamic tooltipBackgroundColor,
    dynamic textColor,
    dynamic child,
    dynamic targetShapeBorder,
  });

  GlobalKey key;
  String desc;
  String title;
  TextStyle titleTextStyle;
  TextStyle descTextStyle;
  dynamic targetPadding;
  dynamic tooltipBackgroundColor;
  dynamic textColor;
  dynamic child;
  dynamic targetShapeBorder;
}
