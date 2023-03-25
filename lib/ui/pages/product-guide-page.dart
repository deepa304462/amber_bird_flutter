import 'package:amber_bird/controller/product-guide-page-controller.dart';
import 'package:amber_bird/data/product_guide/product_guide.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/ui/widget/product-guide-chapter.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../widget/loading-with-logo.dart';

class ProductGuidePage extends StatelessWidget {
  final String productGuideId;
  late ProductGuidePageController productGuidePageController;
  ProductGuidePage(this.productGuideId, {Key? key}) : super(key: key) {
    productGuidePageController = ControllerGenerator.create(
        ProductGuidePageController(),
        tag: 'productGuidePageController');
    productGuidePageController.setPrductGuideId(this.productGuideId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return productGuidePageController.isLoading.isTrue
            ? const Center(
                child: LoadingWithLogo(),
              )
            : Scaffold(
                body: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: true,
                      pinned: true,
                      iconTheme: IconThemeData(color: AppColors.primeColor),
                      floating: false,
                      backwardsCompatibility: true,
                      excludeHeaderSemantics: true,
                      expandedHeight: 300.0,
                      stretch: false,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        collapseMode: CollapseMode.pin,
                        titlePadding: const EdgeInsets.all(0),
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              productGuidePageController.productGuide.value
                                  .subject!.defaultText!.text!,
                              style: TextStyles.titleFont.copyWith(color: AppColors.primeColor),
                            ),
                          ),
                        ),
                        background: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50.0),
                              child: ImageSlider(
                                  productGuidePageController
                                      .productGuide.value.images!,
                                  MediaQuery.of(context).size.width,
                                  disableTap: true,
                                  fit: BoxFit.fitWidth),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 35.0, left: 8, right: 8),
                              child: Card(
                                color: Colors.grey.withOpacity(.6),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    productGuidePageController.productGuide
                                        .value.description!.defaultText!.text!,
                                    style: TextStyles.titleFont,
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return _chapters(context,
                              productGuidePageController.productGuide.value);
                        },
                        childCount: 1,
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget _chapters(BuildContext context, ProductGuide value) {
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: Column(
        children: value.chapters!.map((e) => ProductGuideChapter(e)).toList(),
      ),
    );
  }
}
