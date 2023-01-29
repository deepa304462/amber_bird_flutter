import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/data/slider-item.dart';
import 'package:amber_bird/ui/widget/login-widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageWidget extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (context) {
            return LoginWidget();
            // Stack(
            //   children: [
            //     Container(
            //       child: Lottie.network(
            //           'https://cdn2.sbazar.app/4ac75c41-c312-4655-aeab-2c0717f7b07b'),
            //     ),
            //     Align(
            //       alignment: Alignment.bottomCenter,
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 12.0, vertical: 10),
            //         child: LoginWidget(),
            //       ),
            //     ),
            //   ],
            // );
          },
        ),
      ),
    );
  }

  SliderItem addSliderItem(String s, String t, String u) {
    return SliderItem(imageUrl: s, desc: u, title: t);
  }
}
