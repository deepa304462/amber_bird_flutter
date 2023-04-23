import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/onboarding-controller.dart';
import 'package:amber_bird/data/slider-item.dart';
import 'package:amber_bird/ui/widget/coming-soon-widget.dart';
import 'package:amber_bird/ui/widget/login-widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageWidget extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final OnBoardingController onBoardingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (context) {
            return onBoardingController.isLaunched.value
                ? LoginWidget()
                : ComingSoonWidget();
          },
        ),
      ),
    );
  }

  SliderItem addSliderItem(String s, String t, String u) {
    return SliderItem(imageUrl: s, desc: u, title: t);
  }
}
