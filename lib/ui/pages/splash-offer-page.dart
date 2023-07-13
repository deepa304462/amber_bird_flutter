import 'dart:convert';

import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/onboarding-controller.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/utils/data-cache-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class SplashOfferPage extends StatelessWidget {
  LiquidController liquidController = LiquidController();
  LocationController locationController = Get.find();
  final OnBoardingController onBoardingController = Get.find();

  // Making list of pages needed to pass in IntroViewsFlutter constructor.
  var colorList = [
    Colors.greenAccent,
    Colors.deepPurpleAccent,
    Colors.pink,
    Colors.greenAccent,
    Colors.deepPurpleAccent,
    Colors.pink
  ];
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Obx(
      () => Stack(children: [
        onBoardingController.onboardingData.value.appIntro != null
            ? LiquidSwipe.builder(
                itemCount: onBoardingController
                    .onboardingData.value.appIntro!.introImages!.length,
                itemBuilder: (context, index) {
                  var data = onBoardingController
                      .onboardingData.value.appIntro!.introImages![index];
                  return Container(
                    width: double.infinity,
                    height: height,
                    color: colorList[index],
                    child: ImageBox(
                      data.imageId!,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                },
                positionSlideIcon: 0.8,
                slideIconWidget: const Icon(Icons.arrow_back_ios),
                onPageChangeCallback: (int lpage) async {
                  if (onBoardingController.onboardingData.value.appIntro!
                                  .introImages!.length -
                              1 ==
                          lpage &&
                      onBoardingController.onboardingData.value.appIntro!
                                  .introImages!.length -
                              1 ==
                          onBoardingController.activePage.value) {
                    var statusOnboarding = {
                      'status': 'true',
                      'time': DateTime.now().toUtc().toString()
                    };
                    SharedData.save(
                        jsonEncode(statusOnboarding), 'onboardingDone');
                    if (locationController.pinCode.value.isNotEmpty &&
                        locationController.pinCode.value != '0') {
                      Modular.to.navigate('/home/main');
                    } else {
                      Modular.to.navigate('/location');
                    }
                  }
                  onBoardingController.activePage.value = lpage;
                },
                waveType: WaveType.circularReveal,
                liquidController: liquidController,
                fullTransitionValue: 880,
                enableSideReveal: true,
                enableLoop: false,
                ignoreUserGestureWhileAnimating: true,
              )
            : const SizedBox(),
        onBoardingController.activePage.value != 0
            ? Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primeColor,
                        textStyle:
                            TextStyles.body.copyWith(color: AppColors.white)),
                    onPressed: () async {
                      liquidController.jumpToPage(
                          page: liquidController.currentPage + 1 >
                                  onBoardingController.onboardingData.value
                                          .appIntro!.introImages!.length -
                                      1
                              ? 0
                              : liquidController.currentPage - 1);
                    },
                    child: Text(
                      "Prev",
                      style: TextStyles.body.copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primeColor,
                  textStyle: TextStyles.body.copyWith(color: AppColors.white)),
              onPressed: () {
                if (onBoardingController.onboardingData.value.appIntro !=
                    null) {
                  if (onBoardingController.onboardingData.value.appIntro!
                              .introImages!.length -
                          1 ==
                      onBoardingController.activePage.value) {
                    var statusOnboarding = {
                      'status': 'true',
                      'time': DateTime.now().toUtc().toString()
                    };
                    SharedData.save(
                        jsonEncode(statusOnboarding), 'onboardingDone');
                    liquidController.animateToPage(
                        page: onBoardingController.onboardingData.value
                                .appIntro!.introImages!.length -
                            1,
                        duration: 700);
                    if (locationController.pinCode.value.isNotEmpty &&
                        locationController.pinCode.value != '0') {
                      Modular.to.navigate('/home/main');
                    } else {
                      Modular.to.navigate('/location');
                    }
                  } else {
                    liquidController.jumpToPage(
                        page: onBoardingController.activePage.value >
                                onBoardingController.onboardingData.value
                                        .appIntro!.introImages!.length -
                                    1
                            ? 0
                            : liquidController.currentPage + 1);
                  }
                }
              },
              child: Text("Next",
                  style: TextStyles.body.copyWith(color: AppColors.white)),
            ),
          ),
        )
      ]),
    );
  }

  pageChangeCallback(int lpage) {
    print(lpage);
  }
}
