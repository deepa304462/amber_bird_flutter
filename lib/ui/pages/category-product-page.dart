import 'package:amber_bird/controller/category-product-page-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryProductPage extends StatelessWidget {
  final String id;
  const CategoryProductPage(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryProductPageController(id), tag: id);
    return Container();
  }
}
