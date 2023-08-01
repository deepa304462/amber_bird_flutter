import 'package:amber_bird/controller/product-tag-controller.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';

class ProductTagRow extends StatelessWidget {
  final currenttypeName;
  ProductTagController productTagController = ControllerGenerator.create(
      ProductTagController(),
      tag: 'productTagController');
  ProductTagRow(this.currenttypeName, {super.key});

  @override
  Widget build(BuildContext context) {
    var title = currenttypeName.split('_')[1];
    var currentData = productTagController.tagsProductsList[currenttypeName];

    if (currentData!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyles.headingFont,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: currentData.length,
                    itemBuilder: (_, index) {
                      ProductSummary productSummary = currentData[index];
                      return SizedBox(
                        width: 150,
                        child: Stack(
                          children: [
                            ProductCard(
                                fixedHeight: true,
                                productSummary,
                                productSummary.id,
                                'TAGS_PRODUCT',
                                productSummary.varient!.price!,
                                null,
                                null),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
