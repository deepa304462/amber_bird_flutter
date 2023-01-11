import 'dart:developer';

import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/ui/widget/deal_product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealRow extends StatelessWidget {
  bool isLoading = false;
  final currentdealName;

  DealRow(this.currentdealName, {super.key});

  @override
  Widget build(BuildContext context) {
    final DealController dealController = Get.put(
        DealController(currentdealName),
        tag: currentdealName.toString());
    return Obx(() {
      if (dealController.dealProd.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        dealController.getDealName(currentdealName),
                        style: TextStyles.titleLargeSemiBold,
                      ),
                      ElevatedButton(
                        onPressed: () => {},
                        child: Text('View More',style: TextStyles.bodyWhite,),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  AppColors.primeColor,
                           // This is what you need!
                        ),
                      ),

                      // Text(
                      //   'View More',
                      //   style: TextStyles.headingFontBlue,
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                    height: 200,
                    child: DealProductCard(dealController, currentdealName))
              ],
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
