import 'package:amber_bird/controller/appbar-scroll-controller.dart';
import 'package:amber_bird/controller/product-guide-page-controller.dart';
import 'package:amber_bird/data/product_guide/product_guide.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/ui/widget/product-guide-chapter.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
    return Scaffold(
      body: Obx(
        () {
          return productGuidePageController.isLoading.isTrue
              ? const Center(
                  child: LoadingWithLogo(),
                )
              : CustomScrollView(
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
                      leading: IconButton(
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context); 
                            } else {
                              Modular.to.navigate('../../home/main');
                              // Modular.to.pushNamed('/home/main');
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 15,
                            color: Colors.white,
                          )),
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
                              style: TextStyles.titleFont
                                  .copyWith(color: AppColors.primeColor),
                            ),
                          ),
                        ),
                        background: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: ImageSlider(
                              productGuidePageController
                                  .productGuide.value.images!,
                              MediaQuery.of(context).size.width,
                              disableTap: true,
                              fit: BoxFit.fitWidth),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  productGuidePageController.productGuide.value
                                      .description!.defaultText!.text!,
                                  style: TextStyles.titleFont,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: 1,
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
                );
        },
      ),
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
