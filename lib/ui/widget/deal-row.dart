import 'dart:developer';

import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/deal_product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealRow extends StatelessWidget {
  bool isLoading = false;
  final Controller stateController = Get.find();
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
                        onPressed: () {
                          MegaMenuController megaMenuController;
                          if (Get.isRegistered<MegaMenuController>()) {
                            megaMenuController = Get.find();
                          } else {
                            megaMenuController = Get.put(MegaMenuController());
                          }
                          megaMenuController.selectedParentTab.value =
                              currentdealName;
                          if (currentdealName == dealName.FLASH.name) {
                            megaMenuController.getSubMenu(GenericTab(
                                image: '34038fcf-20e1-4840-a188-413b83d72e11',
                                id: dealName.FLASH.name,
                                type: 'DEAL',
                                text: 'Flash'));
                          } else if (currentdealName ==
                              dealName.EXCLUSIVE_DEAL.name) {
                            megaMenuController.getSubMenu(GenericTab(
                                image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
                                id: dealName.EXCLUSIVE_DEAL.name,
                                type: 'DEAL',
                                text: 'Exclusive'));
                          } else if (currentdealName ==
                              dealName.WEEKLY_DEAL.name) {
                            megaMenuController.getSubMenu(GenericTab(
                                image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
                                id: dealName.WEEKLY_DEAL.name,
                                type: 'DEAL',
                                text: 'Weekly deal'));
                          } else if (currentdealName ==
                              dealName.SUPER_DEAL.name) {
                            megaMenuController.getSubMenu(GenericTab(
                                image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
                                id: dealName.SUPER_DEAL.name,
                                type: 'DEAL',
                                text: 'Super deal'));
                          } else if (currentdealName ==
                              dealName.ONLY_COIN_DEAL.name) {
                            megaMenuController.getSubMenu(GenericTab(
                                image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
                                id: dealName.ONLY_COIN_DEAL.name,
                                type: 'DEAL',
                                text: 'Coin deal'));
                          } else if (currentdealName ==
                              dealName.MEMBER_DEAL.name) {
                            megaMenuController.getSubMenu(GenericTab(
                                image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
                                id: dealName.MEMBER_DEAL.name,
                                type: 'DEAL',
                                text: 'Member deal'));
                          } else if (currentdealName ==
                              dealName.PRIME_MEMBER_DEAL.name) {
                            megaMenuController.getSubMenu(GenericTab(
                                image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
                                id: dealName.PRIME_MEMBER_DEAL.name,
                                type: 'DEAL',
                                text: 'Prime deal'));
                          } else if (currentdealName ==
                              dealName.CUSTOM_RULE_DEAL.name) {
                            megaMenuController.getSubMenu(GenericTab(
                                image: '993a345c-885b-423b-bb49-f4f1c6ba78d0',
                                id: dealName.CUSTOM_RULE_DEAL.name,
                                type: 'DEAL',
                                text: 'Custom deal'));
                          }
                          stateController.setCurrentTab(2);
                        },
                        child: Text(
                          'View More',
                          style: TextStyles.bodyWhite,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primeColor,
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
