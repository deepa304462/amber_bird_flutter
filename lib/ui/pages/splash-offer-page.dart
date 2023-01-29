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
  var colorList = [Colors.greenAccent, Colors.deepPurpleAccent, Colors.pink];
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
                    SharedData.save('true', 'onboardingDone');
                    if (await locationController.getLocation()) {
                      Modular.to.navigate('/home/main');
                    } else {
                      Modular.to.navigate('/location');
                    }
                  }
                  onBoardingController.activePage.value = lpage;
                },
                waveType: WaveType.liquidReveal,
                liquidController: liquidController,
                fullTransitionValue: 880,
                enableSideReveal: true,
                enableLoop: false,
                ignoreUserGestureWhileAnimating: true,
              )
            : const SizedBox(),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkOrange,
                  textStyle: TextStyles.bodyWhite),
              onPressed: () async {
                SharedData.save('true', 'onboardingDone');
                if (onBoardingController.onboardingData.value.appIntro !=
                    null) {
                  liquidController.animateToPage(
                      page: onBoardingController.onboardingData.value.appIntro!
                              .introImages!.length -
                          1,
                      duration: 700);
                  if (await locationController.getLocation()) {
                    Modular.to.navigate('/home/main');
                  } else {
                    Modular.to.navigate('/location');
                  }
                }
              },
              child: Text(
                "Skip to End",
                style: TextStyles.bodyWhite,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkOrange,
                  textStyle: TextStyles.bodyWhite),
              onPressed: () {
                if (onBoardingController.onboardingData.value.appIntro !=
                    null) {
                  liquidController.jumpToPage(
                      page: liquidController.currentPage + 1 >
                              onBoardingController.onboardingData.value
                                      .appIntro!.introImages!.length -
                                  1
                          ? 0
                          : liquidController.currentPage + 1);
                }
              },
              child: Text("Next", style: TextStyles.bodyWhite),
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
