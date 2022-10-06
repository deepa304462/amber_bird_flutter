import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/onboarding-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/category-row.dart';
import 'package:amber_bird/ui/widget/deal-row.dart';
import 'package:amber_bird/ui/widget/image-slider.dart';
import 'package:amber_bird/ui/widget/multi-product-row.dart';
import 'package:amber_bird/ui/widget/search-widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class MainPage extends StatefulWidget {
//   MainPage({Key? key}) : super(key: key);

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
class MainPage extends StatelessWidget {
  final OnBoardingController onBoardingController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             onBoardingController.onboardingData.value.pageWiseConfig != null ? ImageSlider(
              onBoardingController
                  .onboardingData.value.pageWiseConfig!.coverImages!,
              MediaQuery.of(context).size.width,
              isImagePath: false,
              height: 180,
            ):const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: CategoryRow(),
            ),
            DealRow(dealName.FLASH),
            DealRow(dealName.SALES),
            MultiProductRow(multiProductName.COMBO),
            MultiProductRow(multiProductName.BUNDLE),
            MultiProductRow(multiProductName.COLLECTION)
          ],
        ),
      ),
    );
  }
}
