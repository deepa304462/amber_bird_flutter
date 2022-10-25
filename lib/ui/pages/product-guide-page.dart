import 'package:amber_bird/controller/product-guide-page-controller.dart';
import 'package:amber_bird/data/product_guide/product_guide.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/ui/widget/product-guide-chapter.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductGuidePage extends StatelessWidget {
  final String productGuideId;

  ProductGuidePage(this.productGuideId, {Key? key}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    ProductGuidePageController productGuidePageController =
        Get.put(ProductGuidePageController(), tag: productGuideId);
    return Obx(
      () {
        return productGuidePageController.isLoading.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  ImageSlider(
                    productGuidePageController.productGuide.value.images!,
                    MediaQuery.of(context).size.width,
                    disableTap: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                  width: 2, color: AppColors.primeColor)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  productGuidePageController.productGuide.value
                                      .subject!.defaultText!.text!,
                                  style: TextStyles.titleXLargePrimaryBold,
                                ),
                                Text(
                                  productGuidePageController.productGuide.value
                                      .description!.defaultText!.text!,
                                  style: TextStyles.title,
                                  textAlign: TextAlign.justify,
                                )
                              ],
                            ),
                          ),
                        ),
                        _chapters(context,
                            productGuidePageController.productGuide.value)
                      ],
                    ),
                  )
                ],
              );
      },
    );
  }

  Widget _chapters(BuildContext context, ProductGuide value) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: value.chapters!.map((e) => ProductGuideChapter(e)).toList(),
    );
  }
}
