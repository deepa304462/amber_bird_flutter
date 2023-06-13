import 'package:amber_bird/controller/onboarding-controller.dart';
import 'package:amber_bird/controller/product-tag-controller.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/category-row.dart';
import 'package:amber_bird/ui/widget/cloud-word.dart';
import 'package:amber_bird/ui/widget/deal-row.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/ui/widget/multi-product-row.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/ui/widget/product-guide-row.dart';
import 'package:amber_bird/ui/widget/scoin-product-row.dart';
import 'package:amber_bird/ui/widget/shimmer-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/brand-horizontal-cart.dart';

class MainPage extends StatelessWidget {
  final OnBoardingController onBoardingController = Get.find();
  final ProductTagController productTagController =
      Get.put(ProductTagController());
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
            DealRow(dealName.ONLY_COIN_DEAL.name),
            DealRow(dealName.EXCLUSIVE_DEAL.name),
            MultiProductRow(multiProductName.COMBO.name),
            MultiProductRow(multiProductName.BUNDLE.name),
            TagsProductColumn(),
            centProducts(),
            const ProductGuideRow(),
            ScoinProductRow(),
            WordCloud()
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

              var title = currentKey.split('_')[1];
              var currentData =
                  productTagController.tagsProductsList[currentKey];

              if (currentData!.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
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
                                ProductSummary productSummary =
                                    currentData[index];
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
            },
          )
        : const SizedBox());
  }

  getSearchProd() async {
    var payload = {'lessThanOneEuroProducts': true};

    var response = await ClientService.searchQuery(
        path: 'product/searchSummary', query: payload, lang: 'en');
    if (response.statusCode == 200) {
      List<ProductSummary> summaryProdList =
          ((response.data as List<dynamic>?)?.map((e) {
                ProductSummary productSummary =
                    ProductSummary.fromMap(e as Map<String, dynamic>);
                var list = productSummary.varients!.where((i) {
                  if (i.price!.offerPrice! < 1.00) {
                    return true;
                  }
                  return false;
                }).toList();
                if (list.length > 0) {
                  productSummary.varient = list[0];
                  productSummary.varients = list;
                  return productSummary;
                } else {
                  return ProductSummary();
                }
              }).toList() ??
              []);

      centProductList.value = summaryProdList;
    }
  }

  Widget centProducts() {
    getSearchProd();
    return Obx(() => centProductList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Cents',
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
                        itemCount: centProductList.length,
                        itemBuilder: (_, index) {
                          ProductSummary productSummary =
                              centProductList[index];
                          return SizedBox(
                            width: 150,
                            child: Stack(
                              children: [
                                ProductCard(
                                    fixedHeight: true,
                                    productSummary,
                                    productSummary.id,
                                    'CENTS',
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
          )
        : const SizedBox());
  }
}
