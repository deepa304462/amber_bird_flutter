import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/data/slider-item.dart';
import 'package:amber_bird/ui/widget/login-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginPageWidget extends StatelessWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _LoginPage();
//   }
// }

// class _LoginPage extends State<LoginPageWidget> {
//   @override
//   void initState() {
//     super.initState();
//   }
final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Builder(
        builder: (context) {
          // final double height = MediaQuery.of(context).size.height;
          // final double width = MediaQuery.of(context).size.width;
          return Stack(
            children: [
              Container(
                child: Lottie.network(
                    'https://cdn2.sbazar.app/4ac75c41-c312-4655-aeab-2c0717f7b07b'),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  child: LoginWidget(),
                ),
              ),
             
            ],
          );
        },
      )),
    );
  }

  SliderItem addSliderItem(String s, String t, String u) {
    return SliderItem(imageUrl: s, desc: u, title: t);
  }
}
