import 'package:flutter/material.dart';

class ShowcaseKey {
  ShowcaseKey({
    required this.key,
    required this.desc,
    required this.title,
  });

  GlobalKey key;
  String desc;
  String title;
}
