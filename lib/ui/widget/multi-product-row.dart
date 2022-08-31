// class _DealRowState extends State<DealRow> {
import 'dart:developer';

import 'package:amber_bird/controller/multi-product-controller.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/ui/widget/bootom-drawer/deal-bottom-drawer.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiProductRow extends StatelessWidget {
  bool isLoading = false;
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
          height: 340,
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: multiprodController.multiProd.length,
                shrinkWrap: true,
                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 1,
                //     childAspectRatio: 14.5 / 11,
                //     crossAxisSpacing: 10),
                itemBuilder: (_, index) {
                  Multi mProduct = multiprodController.multiProd[index];
                  // var curProduct = dProduct!.product;
                  inspect(mProduct);
                  return SizedBox(
                    height: 280,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5.0),
                          height: 250,
                          // padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppColors.secondaryColor)),

                          // width: (150 * mProduct.products!.length).toDouble(),
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              children: [
                                for (var i = 0;
                                    i < mProduct.products!.length;
                                    i++) ...[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        .45, //150,

                                    // child: ProductCard(
                                    //     mProduct.products![i],
                                    //     mProduct.id,
                                    //     'MULTIPRODUCT',
                                    //     mProduct.products![i].varient!.price!),
                                         child: ProductCard(
                                        mProduct.products![i],
                                        mProduct.products![i].id,
                                        'DIRECTLY',
                                        mProduct.products![i].varient!.price!),
                                  )
                                ]
                              ]),
                        ),
                        Align(
                          alignment: AlignmentDirectional.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            // margin: const EdgeInsets.only(left: 3, right: 3),
                            height: 55,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mProduct!.name!.defaultText!.text ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\$${mProduct.price!.offerPrice}",
                                        style: TextStyles.bodyFont,
                                      ),
                                      const SizedBox(width: 3),
                                      Visibility(
                                        visible:
                                            mProduct!.price!.actualPrice != null
                                                ? true
                                                : false,
                                        child: Text(
                                          "\$${mProduct!.price!.actualPrice.toString()}",
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        padding: const EdgeInsets.all(1),
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          showModalBottomSheet<void>(
                                            // context and builder are
                                            // required properties in this widget
                                            context: context,
                                            elevation: 3,
                                            builder: (context) {
                                              // return _bottomSheetAddToCart(product, context);
                                              return DealBottomDrawer(
                                                  mProduct!.products![0],
                                                  mProduct.id,
                                                  'MULTIPRODUCT',
                                                  mProduct.price);
                                            },
                                          );
                                          // cartController.addToCart(product!, refId!, addedFrom!);
                                        },
                                        icon: Icon(Icons.add_circle_outline,
                                            color: AppColors.primeColor),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
