import 'package:amber_bird/controller/onboarding-controller.dart';
import 'package:amber_bird/controller/product-tag-controller.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/back-stock-budget.dart';
import 'package:amber_bird/ui/widget/category-row.dart';
import 'package:amber_bird/ui/widget/cent-product-widget.dart';
import 'package:amber_bird/ui/widget/cloud-word.dart';
import 'package:amber_bird/ui/widget/deal-row.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/ui/widget/multi-product-row.dart';
import 'package:amber_bird/ui/widget/product-guide-row.dart';
import 'package:amber_bird/ui/widget/product-tag-row.dart';
import 'package:amber_bird/ui/widget/scoin-product-row.dart';
import 'package:amber_bird/ui/widget/shimmer-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/brand-horizontal-cart.dart';

class MainPage extends StatelessWidget {
  final OnBoardingController onBoardingController = Get.find();
  ProductTagController productTagController = ControllerGenerator.create(
      ProductTagController(),
      tag: 'productTagController');
  RxList<ProductSummary> centProductList = <ProductSummary>[].obs;
  @override
  Widget build(BuildContext context) {
    onBoardingController.addInternetConnectivity(context);
    onBoardingController.firebaseRemoteConfigListenerAdd(context);
    return Container(
      color: AppColors.commonBgColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Obx(
              () => onBoardingController.onboardingData.value.pageWiseConfig !=
                      null
                  ? ImageSlider(
                      onBoardingController
                          .onboardingData.value.pageWiseConfig!.coverImages!,
                      MediaQuery.of(context).size.width,
                      isImagePath: false,
                      height: 160,
                    )
                  : ShimmerWidget(
                      heightOfTheRow: 160,
                      radiusOfcell: 12,
                      widthOfCell: MediaQuery.of(context).size.width),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: AppColors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: CategoryRow(),
              ),
            ),
            DealRow(dealName.FLASH.name),
            DealRow(dealName.SALES.name),
            DealRow(dealName.WEEKLY_DEAL.name),
            DealRow(dealName.SUPER_DEAL.name),
            BrandHorizontalCard(),
            CentProductWidget(),
            DealRow(dealName.ONLY_COIN_DEAL.name),
            DealRow(dealName.EXCLUSIVE_DEAL.name),
            MultiProductRow(multiProductName.COMBO.name),
            ScoinProductRow(),
            MultiProductRow(multiProductName.BUNDLE.name),
            MultiProductRow(multiProductName.COLLECTION.name),
            TagsProductColumn(),
            // CentProductWidget(),
            BackInStockProductWidget(),
            ProductGuideRow(),
            Divider(
              color: AppColors.lightGrey,
              height: 2,
              thickness: 2,
            ),
            WordCloud(),
            Divider(
              color: AppColors.lightGrey,
              height: 2,
              thickness: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget TagsProductColumn() {
    return Obx(() => productTagController.tagsProductsList.isNotEmpty
        ? ListView.builder(
            itemCount: productTagController.tagsProductsList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              var currentKey =
                  productTagController.tagsProductsList.keys.elementAt(index);
              return ProductTagRow(currentKey);
            },
          )
        : const SizedBox());
  }
}
