import 'package:amber_bird/controller/brand-product-page-controller.dart';
import 'package:amber_bird/data/brand/brand.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandProductPage extends StatelessWidget {
  final String id;
  const BrandProductPage(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandProductPageController(id), tag: id);
    return Obx(() => ListView(
          children: [brandInfo(controller.brand, context)],
        ));
  }

  Widget brandInfo(Rx<Brand> brand, BuildContext context) {
    return Card();
  }
}
