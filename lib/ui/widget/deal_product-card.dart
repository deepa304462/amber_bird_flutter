import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/open_container_wrapper.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealProductCard extends StatelessWidget {
  final CartController cartController = Get.find();

  final DealController con;
  DealProductCard(this.con, {super.key});
 
 
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => 
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: con.dealProd.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 14.5 / 11,
              crossAxisSpacing: 10),
          itemBuilder: (_, index) {
            DealProduct dProduct = con.dealProd[index];
            var curProduct = dProduct!.product;
            inspect(curProduct);
            // curProduct!.varient!.price = dProduct!.dealPrice;
            //  inspect(curProduct);
            return ProductCard(
                dProduct!.product, dProduct!.id, 'DEAL', dProduct.dealPrice);
          },
        ),
      ),
    );
  }
}
