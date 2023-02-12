import 'dart:developer';

import 'package:amber_bird/controller/auth-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/scoin-product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/ui/element/i-text-box.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/image-picker.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class ScoinCheckoutWidget extends StatelessWidget {
  final Controller stateController = Get.find();
  final AuthController authController = Get.put(AuthController());
  final CartController cartController = Get.find();
  final ScoinProductController scoinProductController = Get.find();

  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                  onPressed: () {
                    Modular.to.navigate('../home/main');
                  },
                  icon: const Icon(Icons.arrow_back)),
              Text('Scoin Product')
            ]),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Id: ${cartController.scoinOrderData.value!.id}'),
                  Text('Id: ${cartController.scoinOrderData.value!.payment!.totalSCoins}'),
                  TextButton(onPressed: ()=>{}, child: Text('Payment'))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  isLoadingCallback(bool val) {
    isLoading.value = val;
  }
}
