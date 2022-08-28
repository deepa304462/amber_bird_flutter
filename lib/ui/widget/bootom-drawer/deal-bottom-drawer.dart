import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DealBottomDrawer extends StatelessWidget {
  final ProductSummary? product;
  final String? refId;
  final String? addedFrom;
  final Price? dealPrice;
  DealBottomDrawer(this.product, this.refId, this.addedFrom, this.dealPrice,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();
    final Controller stateController = Get.find();
    final WishlistController wishlistController = Get.find();

    ProductSummary? p = ProductSummary.fromMap(product!.toMap());
    if (addedFrom == 'DEAL') {
      // var curProduct = product.toMap();
      // ProductSummary? p=ProductSummary.fromMap(curProduct);
      p!.varient!.price = dealPrice;
      inspect(p);
      inspect(product);
    }
    return SizedBox(
      height: 320,
      child: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add Item",
                  style: TextStyles.headingFontGray,
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Row(
              children: [
                Stack(alignment: AlignmentDirectional.topStart, children: [
                  Image.network(
                    '${ClientService.cdnUrl}${p!.images![0]}',
                    width: 130,
                  ),
                  Obx(
                    () => Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: wishlistController
                                  .checkIfProductWishlist(product!.id)
                              ? Colors.redAccent
                              : AppColors.grey,
                        ),
                        onPressed: () => {
                          wishlistController.addToWishlist(product!.id, product)
                        },
                      ),
                    ),
                  ),
                ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.ltr,
                  children: [
                    Text(
                      '${p.name!.defaultText!.text}',
                      style: TextStyles.headingFont,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Image.network(
                          '${ClientService.cdnUrl}${product!.category!.logoId}',
                          height: 20,
                        ),
                        Text(
                          '${product!.name!.defaultText!.text}',
                          style: TextStyles.subHeadingFont,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: Text(
                        product!.description!.defaultText!.text ?? '',
                        style: TextStyles.bodyFont,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(5),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('${p.varient!.weight!} ${p.varient!.unit!}'),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('\$${p.varient!.price!.offerPrice!}'),
                    Text(
                      '\$${p.varient!.price!.actualPrice!}',
                      style: TextStyles.prieLinThroughStyle,
                    ),
                  ],
                ),
                GetX<CartController>(builder: (cController) {
                  return cController.checkProductInCart(refId)
                      ? Row(
                          children: [
                            IconButton(
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                if (stateController.isLogin.value) {
                                  cController.addToCart(
                                      p, refId!, addedFrom!, -1);
                                } else {
                                  stateController.setCurrentTab(3);
                                  var showToast = snackBarClass.showToast(
                                      context, 'Please Login to preoceed');
                                }
                                // cController.addToCart(p, refId!, addedFrom!, -1);
                              },
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.black),
                            ),
                            Text(cController
                                .getCurrentQuantity(refId)
                                .toString()),
                            IconButton(
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                if (stateController.isLogin.value) {
                                  cController.addToCart(
                                      p, refId!, addedFrom!, 1);
                                } else {
                                  stateController.setCurrentTab(3);
                                  var showToast = snackBarClass.showToast(
                                      context, 'Please Login to preoceed');
                                }
                                // cController.addToCart(p, refId!, addedFrom!, 1);
                              },
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Colors.black),
                            ),
                          ],
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primeColor,
                              // padding: const EdgeInsets.symmetric(
                              //     horizontal: 50, vertical: 15),
                              textStyle: TextStyles.bodyWhite),
                          onPressed: p!.varient!.currentStock > 0
                              ? () {
                                  if (stateController.isLogin.value) {
                                    cartController.addToCart(
                                        p, refId!, addedFrom!, 1);
                                  } else {
                                    stateController.setCurrentTab(3);
                                    var showToast = snackBarClass.showToast(
                                        context, 'Please Login to preoceed');
                                  }
                                }
                              : () {
                                  print(
                                      'nnnnn${stateController.isLogin.value}');
                                  if (stateController.isLogin.value) {
                                    cartController.addToCart(
                                        p, refId!, addedFrom!, 1);
                                  } else {
                                    stateController.setCurrentTab(3);
                                    var showToast = snackBarClass.showToast(
                                        context, 'Please Login to preoceed');
                                  }
                                },
                          child: Text("Add to cart",
                              style: TextStyles.addTocartText),
                        );
                }),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
