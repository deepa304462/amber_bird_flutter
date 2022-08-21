import 'dart:developer';

import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/ui/widget/deal_product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class DealRow extends StatefulWidget {
//   String CurrentdealName = '';

//   DealRow(dealName CurrentdealName, {Key? key}) : super(key: key);

//   @override
//   State<DealRow> createState() => _DealRowState();
// }

// class _DealRowState extends State<DealRow> {
class DealRow extends StatelessWidget {
  bool isLoading = false;
  // RxList<DealProduct> dealProd = <DealProduct>[].obs;
  // final DealController dealController = Get.put(DealController());
  final currentdealName;

  DealRow(this.currentdealName, {super.key});

  @override
  Widget build(BuildContext context) {
    final DealController dealController = Get.put(
        DealController(currentdealName),
        tag: currentdealName.toString());
    // if (dealController.dealProd.isNotEmpty) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                dealController.getDealName(currentdealName),
                style: TextStyles.headingFont,
              ),
            ],
          ),
        ),
        SizedBox(height: 240, child: DealProductCard(dealController))
      ],
    );
    // } else {
    //   return SizedBox();
    // }
  }
}
