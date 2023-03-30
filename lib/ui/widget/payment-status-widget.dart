import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/data/payment/payment.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class PaymentStatusWidget extends StatelessWidget {
  late CartController cartController;
  final id;

  PaymentStatusWidget(this.id, String paymentId) {
    cartController =
        ControllerGenerator.create(CartController(), tag: 'cartController');
    cartController.paymentData.value = Payment(id: paymentId);
    cartController.paymentStatusCheck();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Obx(() {
      // print(cartController.paymentData.value!.status);
      if (cartController.paymentData.value != null &&
          cartController.paymentData.value!.status == 'OPEN') {
        return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
                'Your Payment is ${cartController.paymentData.value!.status}'));
      } else if (cartController.paymentData.value!.status == 'paid') {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Container(
                //   height: 170,
                //   // padding: EdgeInsets.all(35),
                //   decoration: BoxDecoration(
                //     color: AppColors.primeColor,
                //     shape: BoxShape.circle,
                //   ),
                //   child:
                Lottie.asset(
                  'assets/10470-confirm.json',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                // ),
                SizedBox(height: screenHeight * 0.1),
                Text(
                  "Thank You!",
                  style: TextStyle(
                    color: AppColors.primeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 36,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Payment is ${cartController.paymentData.value!.status}",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                const Text(
                  "You can check order status and invoice from order inside profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkOrange,
                      textStyle:
                          TextStyles.body.copyWith(color: AppColors.white)),
                  onPressed: () async {
                    Modular.to.navigate('/home/order-detail',
                        arguments: {'id': id, 'navigateTo': 'HOME'});
                  },
                  child: Text(
                    "Check Order",
                    style: TextStyles.body.copyWith(color: AppColors.white),
                  ),
                ),

                SizedBox(height: screenHeight * 0.06),
                // Flexible(
                //   child: HomeButton(
                //     title: 'Home',
                //     onTap: () {},
                //   ),
                // ),
              ],
            ),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.1),
                Text(
                  "Thank You!",
                  style: TextStyle(
                    color: AppColors.primeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 36,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  "Payment is ${cartController.paymentData.value!.status}",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                const Text(
                  "You will be redirected to the home page shortly\nor click here to return to home page",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                // Flexible(
                //   child: HomeButton(
                //     title: 'Home',
                //     onTap: () {},
                //   ),
                // ),
              ],
            ),
          ),
        );
      }
    });
  }
}
