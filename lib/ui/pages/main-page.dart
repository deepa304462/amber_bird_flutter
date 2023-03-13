import 'package:amber_bird/controller/onboarding-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/category-row.dart';
import 'package:amber_bird/ui/widget/deal-row.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/ui/widget/multi-product-row.dart';
import 'package:amber_bird/ui/widget/product-guide-row.dart';
import 'package:amber_bird/ui/widget/scoin-product-row.dart';
import 'package:amber_bird/ui/widget/shimmer-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  final OnBoardingController onBoardingController = Get.find();

  @override
  Widget build(BuildContext context) {
    onBoardingController.addInternetConnectivity(context);
    onBoardingController.firebaseRemoteConfigListenerAdd(context);
    return Container(
      color: AppColors.backgroundGrey,
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
            DealRow(dealName.ONLY_COIN_DEAL.name),
            DealRow(dealName.EXCLUSIVE_DEAL.name),
            ScoinProductRow(),
            MultiProductRow(multiProductName.COMBO.name),
            MultiProductRow(multiProductName.BUNDLE.name),
            const ProductGuideRow(),
          ],
        ),
      ),
    );
  }
}
