import 'package:amber_bird/controller/onboarding-controller.dart';
import 'package:amber_bird/controller/product-tag-controller.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/back-stock-budget.dart';
import 'package:amber_bird/ui/widget/category-row.dart';
import 'package:amber_bird/ui/widget/cent-product-widget.dart';
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
import 'package:word_cloud/word_cloud_data.dart';
import 'package:word_cloud/word_cloud_shape.dart';
import 'package:word_cloud/word_cloud_tap.dart';
import 'package:word_cloud/word_cloud_tap_view.dart';
import 'package:word_cloud/word_cloud_view.dart';

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
            CentProductWidget(),
            DealRow(dealName.ONLY_COIN_DEAL.name),
            DealRow(dealName.EXCLUSIVE_DEAL.name),
            MultiProductRow(multiProductName.COMBO.name),
            ScoinProductRow(),
            MultiProductRow(multiProductName.BUNDLE.name),
            TagsProductColumn(),
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
            MyHomePage(),
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
}

class MyHomePage extends StatelessWidget {
  //example data list
  List<Map> word_list = [
    {'word': 'Apple', 'value': 100},
    {'word': 'Samsung', 'value': 60},
    {'word': 'Intel', 'value': 55},
    {'word': 'Tesla', 'value': 50},
    {'word': 'AMD', 'value': 40},
    {'word': 'Google', 'value': 35},
    {'word': 'Qualcom', 'value': 31},
    {'word': 'Netflix', 'value': 27},
    {'word': 'Meta', 'value': 27},
    {'word': 'Amazon', 'value': 26},
    {'word': 'Nvidia', 'value': 25},
    {'word': 'Microsoft', 'value': 25},
    {'word': 'TSMC', 'value': 24},
    {'word': 'PayPal', 'value': 24},
    {'word': 'AT&T', 'value': 24},
    {'word': 'Oracle', 'value': 23},
    {'word': 'Unity', 'value': 23},
    {'word': 'Roblox', 'value': 23},
    {'word': 'Lucid', 'value': 22},
    {'word': 'Naver', 'value': 20},
    {'word': 'Kakao', 'value': 18},
    {'word': 'NC Soft', 'value': 18},
    {'word': 'LG', 'value': 16},
    {'word': 'Hyundai', 'value': 16},
    {'word': 'KIA', 'value': 16},
    {'word': 'twitter', 'value': 16},
    {'word': 'Tencent', 'value': 15},
    {'word': 'Alibaba', 'value': 15},
    {'word': 'LG', 'value': 16},
    {'word': 'Hyundai', 'value': 16},
    {'word': 'KIA', 'value': 16},
    {'word': 'twitter', 'value': 16},
    {'word': 'Tencent', 'value': 15},
    {'word': 'Alibaba', 'value': 15},
    {'word': 'Disney', 'value': 14},
    {'word': 'Spotify', 'value': 14},
    {'word': 'Udemy', 'value': 13},
    {'word': 'Quizlet', 'value': 13},
    {'word': 'Visa', 'value': 12},
    {'word': 'Lucid', 'value': 22},
    {'word': 'Naver', 'value': 20},
    {'word': 'Hyundai', 'value': 16},
    {'word': 'KIA', 'value': 16},
    {'word': 'twitter', 'value': 16},
    {'word': 'Tencent', 'value': 15},
    {'word': 'Alibaba', 'value': 15},
    {'word': 'Disney', 'value': 14},
    {'word': 'Spotify', 'value': 14},
    {'word': 'Visa', 'value': 12},
    {'word': 'Microsoft', 'value': 10},
    {'word': 'TSMC', 'value': 10},
    {'word': 'PayPal', 'value': 24},
    {'word': 'AT&T', 'value': 10},
    {'word': 'Oracle', 'value': 10},
    {'word': 'Unity', 'value': 10},
    {'word': 'Roblox', 'value': 10},
    {'word': 'Lucid', 'value': 10},
    {'word': 'Naver', 'value': 10},
    {'word': 'Kakao', 'value': 18},
    {'word': 'NC Soft', 'value': 18},
    {'word': 'LG', 'value': 16},
    {'word': 'Hyundai', 'value': 16},
    {'word': 'KIA', 'value': 16},
    {'word': 'twitter', 'value': 16},
    {'word': 'Tencent', 'value': 10},
    {'word': 'Alibaba', 'value': 10},
    {'word': 'Disney', 'value': 14},
    {'word': 'Spotify', 'value': 14},
    {'word': 'Udemy', 'value': 13},
    {'word': 'NC Soft', 'value': 12},
    {'word': 'LG', 'value': 16},
    {'word': 'Hyundai', 'value': 10},
    {'word': 'KIA', 'value': 16},
  ];
  int count = 0;
  String wordstring = '';

  @override
  Widget build(BuildContext context) {
    WordCloudData wcdata = WordCloudData(data: word_list);
    WordCloudTap wordtaps = WordCloudTap();

    //WordCloudTap Setting
    // for (int i = 0; i < word_list.length; i++) {
    //   void tap() {
    //     // setState(() {
    //     count += 1;
    //     wordstring = word_list[i]['word'];
    //     // });
    //   }

    //   wordtaps.addWordtap(word_list[i]['word'], tap);
    // }

    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Clicked Word : ${wordstring}',
              style: TextStyle(fontSize: 20),
            ),
            Text('Clicked Count : ${count}', style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // WordCloudTapView(
                //   data: wcdata,
                //   wordtap: wordtaps,
                //   mapcolor: Color.fromARGB(255, 174, 183, 235),
                //   mapwidth: 500,
                //   mapheight: 500,
                //   fontWeight: FontWeight.bold,
                //   shape: WordCloudCircle(radius: 250),
                //   colorlist: [
                //     Colors.black,
                //     Colors.redAccent,
                //     Colors.indigoAccent
                //   ],
                // ),
                SizedBox(
                  height: 15,
                  width: 30,
                ),
                WordCloudView(
                  data: wcdata,
                  mapcolor: Color.fromARGB(255, 174, 183, 235),
                  mapwidth: 500,
                  mapheight: 500,
                  fontWeight: FontWeight.bold,
                  colorlist: [
                    Colors.black,
                    Colors.redAccent,
                    Colors.indigoAccent
                  ],
                ),
              ],
            ),
          ]),
    );
  }
}
