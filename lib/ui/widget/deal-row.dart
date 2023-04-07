import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/card-color-animated.dart';
import 'package:amber_bird/ui/widget/deal_product-card.dart';
import 'package:amber_bird/ui/widget/shimmer-widget.dart';
import 'package:amber_bird/ui/widget/view-more-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealRow extends StatelessWidget {
  bool isLoading = false;
  final Controller stateController = Get.find();
  final currentdealName;
  late DealController dealController;
  DealRow(this.currentdealName, {super.key}) {
    dealController = Get.put(DealController(currentdealName),
        tag: currentdealName.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (dealController.dealProd.isNotEmpty) {
        String timeLeft = '';
        var difference;
        if (currentdealName == dealName.FLASH.name) {
          // String expire = ruleConfig!.willExpireAt ?? '';

          var newDate = DateTime.now().toUtc();
          var endDate = DateTime.now().toUtc();
          // endDate = endDate
          // ..subtract(Duration(hours: endDate.hour, minutes: endDate.minute))
          // ..add(Duration(hours: 23, minutes: 59));
          endDate = endDate.applyTimeOfDay(hour: 20, minute: 00);
          difference = endDate.difference(newDate);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        dealController.getDealName(currentdealName),
                        style: TextStyles.headingFont,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          currentdealName == dealName.FLASH.name
                              ? CardColorAnimated(
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, top: 1, bottom: 1, left: 5),
                                    child: Text(
                                      difference.inHours != null
                                          ? '${difference.inHours}H left'
                                          : '${difference.inMinutes}M left',
                                      style: TextStyles.bodyFontBold
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  Colors.red,
                                  Colors.indigo,
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                )
                              : const SizedBox(),
                          ViewMoreWidget(onTap: () {
                            MegaMenuController megaMenuController;
                            if (Get.isRegistered<MegaMenuController>()) {
                              megaMenuController = Get.find();
                            } else {
                              megaMenuController =
                                  Get.put(MegaMenuController());
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
                            stateController.setCurrentTab(1);
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 180,
                child: DealProductCard(dealController, currentdealName),
              )
            ],
          ),
        );
      } else {
        return dealController.isLoading.value
            ? ShimmerWidget(
                heightOfTheRow: 180, radiusOfcell: 12, widthOfCell: 150)
            : const SizedBox();
      }
    });
  }
}

extension DateTimeExt on DateTime {
  DateTime applyTimeOfDay({required int hour, required int minute}) {
    return DateTime(year, month, day, hour, minute);
  }
}
