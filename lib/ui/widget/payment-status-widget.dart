import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentStatusWidget extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
              'Your Payment is ${cartController.paymentData.value!.status}')),
    );
  }
}
