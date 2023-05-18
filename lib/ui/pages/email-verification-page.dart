import 'package:amber_bird/controller/user-verification-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class EmailVerificationPage extends StatelessWidget {
  final String email;
  final String code;
  const EmailVerificationPage(this.email, this.code, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
     
        Get.put(UserVerificationController(email, code), tag: code);
    return SafeArea(
      child: Scaffold(
        body: Container(
            child: SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Lottie.network(
            'https://assets6.lottiefiles.com/packages/lf20_x62chJ.json',
          ),
        )
            // Column(
            //   children: [Text(email), Text(code)],
            // ),
            ),
      ),
    );
  }
}
