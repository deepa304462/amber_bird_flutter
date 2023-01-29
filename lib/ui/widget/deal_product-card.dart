import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart'; 
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealProductCard extends StatelessWidget {
  final CartController cartController = Get.find();

  final DealController con;
  final String currentdealName;
  DealProductCard(this.con, this.currentdealName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: con.dealProd.length,
          itemBuilder: (_, index) {
            DealProduct dProduct = con.dealProd[index];
            return SizedBox(
              width: 150,
              child: ProductCard(
                  fixedHeight: true,
                  dProduct.product,
                  dProduct.id,
                  currentdealName.toString(),
                  dProduct.dealPrice,
                  dProduct.ruleConfig),
            );
          },
        ),
      ),
    );
  }
}
