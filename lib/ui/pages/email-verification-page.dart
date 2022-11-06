import 'package:amber_bird/controller/user-verification-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailVerificationPage extends StatelessWidget {
  final String email;
  final String code;
  const EmailVerificationPage(this.email, this.code, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserVerificationController userVerificationController =
        Get.put(UserVerificationController(email, code), tag: code);
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [Text(email), Text(code)],
          ),
        ),
      ),
    );
  }
}
