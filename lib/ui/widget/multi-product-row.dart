// class _DealRowState extends State<DealRow> {
import 'dart:developer';

import 'package:amber_bird/controller/multi-product-controller.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiProductRow extends StatelessWidget {
  bool isLoading = false;
  // RxList<DealProduct> dealProd = <DealProduct>[].obs;
  // final DealController dealController = Get.put(DealController());
  final currenttypeName;

  MultiProductRow(this.currenttypeName, {super.key});

  @override
  Widget build(BuildContext context) {
    final MultiProductController multiprodController = Get.put(
        MultiProductController(currenttypeName),
        tag: currenttypeName.toString());
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
                multiprodController.getProductName(currenttypeName),
                style: TextStyles.headingFont,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: multiprodController.multiProd.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 14.5 / 11,
                    crossAxisSpacing: 10),
                itemBuilder: (_, index) {
                  Multi mProduct = multiprodController.multiProd[index];
                  // var curProduct = dProduct!.product;
                  inspect(mProduct);
                  // curProduct!.varient!.price = dProduct!.dealPrice;
                  //  inspect(curProduct);
                  return SizedBox(
                      // height: 250,
                      // width: 500,
                      child: ListView(scrollDirection: Axis.horizontal,
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        for (var i = 0; i < mProduct.products!.length; i++) ...[
                          SizedBox(
                            width: (150 * mProduct.products!.length).toDouble(),
                            child: ProductCard(
                                mProduct.products![i],
                                mProduct.id,
                                'MULTIPRODUCT',
                                mProduct.products![i].varient!.price!),
                          )
                        ]
                      ]));
                  // return for (var i = 0; i < mProduct.products!.length; i++){
                  //   var curProduct = mProduct.products![i];
                  //   return ProductCard(curProduct, mProduct!.id, 'MULTIPRODUCT',
                  //       curProduct.varient!.price!);
                  // }
                  // return ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: mProduct.products!.length,
                  //     itemBuilder: (_, index1) {
                  //       var curProduct = mProduct.products![index1];
                  //       return ProductCard(curProduct, mProduct!.id,
                  //           'MULTIPRODUCT', curProduct.varient!.price!);
                  //     });

                  // ProductCard(dProduct!.product, dProduct!.id, 'DEAL',
                  //     dProduct.dealPrice);
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}