import 'package:amber_bird/controller/onboarding-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class SplashOfferPage extends StatelessWidget {
//   SplashOfferPage({Key? key}) : super(key: key);

//   @override
//   State<SplashOfferPage> createState() => _SplashOfferPageState();
// }

// class _SplashOfferPageState extends State<SplashOfferPage> {
  LiquidController liquidController = LiquidController();

  final OnBoardingController onBoardingController =
      Get.put(OnBoardingController());
  // final CartController cartController = Get.put(CartController());
  // final WishlistController wishlistController = Get.put(WishlistController());

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
                  print(data);
                  return Container(
                    width: double.infinity,
                    height: height,
                    color: colorList[index] ?? Colors.blueAccent,
                    child: Image.network(
                        '${ClientService.cdnUrl}${data.imageId}',
                        fit: BoxFit.fill),
                  );
                },
                positionSlideIcon: 0.8,
                slideIconWidget: Icon(Icons.arrow_back_ios),
                onPageChangeCallback: (int lpage) {
                  if (onBoardingController.onboardingData.value.appIntro!
                                  .introImages!.length -
                              1 ==
                          lpage &&
                      onBoardingController.onboardingData.value.appIntro!
                                  .introImages!.length -
                              1 ==
                          onBoardingController.activePage.value) {
                    Modular.to.navigate('/location');
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
            : SizedBox(),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkOrange,
                  textStyle: TextStyles.bodyWhite),
              onPressed: () {
                if (onBoardingController.onboardingData.value.appIntro !=
                    null) {
                  liquidController.animateToPage(
                      page: onBoardingController.onboardingData.value.appIntro!
                              .introImages!.length -
                          1,
                      duration: 700);
                  Modular.to.navigate('/location');
                }
              },
              child: Text(
                "Skip to End",
                style: TextStyles.bodyWhite,
              ),
              // color: Colors.white.withOpacity(0.01),
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
              // color: Colors.white.withOpacity(0.01),
            ),
          ),
        )
      ]),
    );

    // LiquidSwipe(
    //          pages: pages,
    //          fullTransitionValue: 500,
    //          enableSideReveal: true,
    //        );
    //  Obx(
    //   () =>IntroViewsFlutter(
    //   pages,
    //   showNextButton: true,
    //   showBackButton: true,
    //   onTapDoneButton: () {
    //     // Use Navigator.pushReplacement if you want to dispose the latest route
    //     // so the user will not be able to slide back to the Intro Views.
    //     Modular.to.navigate('/home/main');
    //   },
    //   pageButtonTextStyles: const TextStyle(
    //     color: Colors.white,
    //     fontSize: 18.0,
    //   ),
    // ));
  }

  pageChangeCallback(int lpage) {
    // setState(() {
    //   page = lpage;
    // });
    print(lpage);
  }
}
