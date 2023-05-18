import 'package:amber_bird/controller/product-guide-row-controller.dart';
import 'package:amber_bird/ui/widget/product-guide-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductGuideRow extends StatelessWidget {
  const ProductGuideRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductGuideController productGuideController =
        Get.put(ProductGuideController());
    if (productGuideController.productGuides.isNotEmpty) {
      productGuideController.productGuides.shuffle();
    }
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Obx(
                () => ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: productGuideController.productGuides.value
                      .map((e) => ProductGuideCard(e))
                      .toList(),
                ),
              )),
        ],
      ),
    );
  }
}
