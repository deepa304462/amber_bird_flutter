import 'package:amber_bird/controller/category-product-page-controller.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryProductPage extends StatelessWidget {
  final String id;
  const CategoryProductPage(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryProductPageController(id), tag: id);
    return Obx(() {
      return controller.isLoading.value
          ? const Center(child: LinearProgressIndicator())
          : ListView(
              children: [
                categoryInfo(controller.category, context),
                productList(controller.productList, context)
              ],
            );
    });
  }

  categoryInfo(Rx<ProductCategory> category, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: ImageBox(
            category.value.logoId!,
            width: 50,
            height: 50,
          ),
          title: Text(
            category.value.name!.defaultText!.text!,
            style: TextStyles.titleLargeBold,
          ),
        ),
      ),
    );
  }

  Widget productList(RxList<ProductSummary> productList, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 8,
        runSpacing: 12,
        children: productList
            .map((product) => SizedBox(
                width: MediaQuery.of(context).size.width * .5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child:
                      ProductCard(product, product.id, 'CATEGORY', null, null),
                )))
            .toList(),
      ),
    );
  }
}
