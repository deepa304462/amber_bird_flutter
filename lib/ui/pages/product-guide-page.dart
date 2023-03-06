import 'package:amber_bird/controller/product-guide-page-controller.dart';
import 'package:amber_bird/data/product_guide/product_guide.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/ui/widget/product-guide-chapter.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class ProductGuidePage extends StatelessWidget {
  final String productGuideId;
  late ProductGuidePageController productGuidePageController;
  ProductGuidePage(this.productGuideId, {Key? key}) : super(key: key) {
    productGuidePageController =
        ControllerGenerator.create(ProductGuidePageController());
    productGuidePageController.setPrductGuideId(this.productGuideId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return productGuidePageController.isLoading.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Stack(
                    children: [
                      ImageSlider(
                          productGuidePageController.productGuide.value.images!,
                          MediaQuery.of(context).size.width,
                          disableTap: true,
                          fit: BoxFit.cover),
                      Center(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.grey.shade100.withOpacity(.8),
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
                      )
                    ],
                  ),
                  Expanded(
                    child: _chapters(
                        context, productGuidePageController.productGuide.value),
                  )
                ],
              );
      },
    );
  }

  Widget _chapters(BuildContext context, ProductGuide value) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: value.chapters!.map((e) => ProductGuideChapter(e)).toList(),
    );
  }
}
