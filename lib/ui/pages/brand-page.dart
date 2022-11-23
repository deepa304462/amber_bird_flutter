import 'package:amber_bird/controller/brand-product-page-controller.dart';
import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandProductPage extends StatelessWidget {
  final String id;
  const BrandProductPage(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandProductPageController(id), tag: id);
    return Obx(() => controller.isLoading.value
        ? const Center(child: LinearProgressIndicator())
        : ListView(
            children: [
              brandInfo(controller.brand, context),
              productList(controller.productList, context)
            ],
          ));
  }

  Widget brandInfo(Rx<Brand> brand, BuildContext context) {
    return Card(
        child: ListTile(
      leading: ImageBox(
        brand.value.logoId!,
        width: 100,
        height: 100,
      ),
      title: Text(
        brand.value.name!,
        style: TextStyles.titleLargeBold,
      ),
      subtitle: Text(
        brand.value.description!.defaultText!.text!,
        style: TextStyles.bodyFontBold,
      ),
    ));
  }

  productList(RxList<ProductSummary> productList, BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: productList
          .map((product) => SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ProductCard(product, product.id, 'BRAND', null, null),
              )))
          .toList(),
    );
  }
}
