import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/coupon-widget.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class SaveLater extends StatelessWidget {
  final CartController cartController = Get.find();
  final Controller stateController = Get.find();
  RxBool checkoutClicked = false.obs;
  TextEditingController ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    cartController.clearCheckout();
    return Obx(
      () => cartController.saveLaterProducts.length > 0
          ? Column(
              children: [
                Text(
                  'Saved Products',
                  style: TextStyles.titleGreen,
                ),
                saveLaterData(context, cartController),
              ],
            )
          : Container(
              child: Text(
                'Saved Products',
                style: TextStyles.titleGreen,
              ),
            ),
    );
  }

  saveLaterData(context, cartController) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: cartController.saveLaterProducts.length,
      itemBuilder: (_, index) {
        var currentKey =
            cartController.saveLaterProducts.value.keys.elementAt(index);
        return Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Column(
            children: [
              cartController
                      .saveLaterProducts.value[currentKey]!.products!.isNotEmpty
                  ? Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(2.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 113, 116, 122))),
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: cartController.saveLaterProducts
                                .value[currentKey]!.products!.length,
                            itemBuilder: (_, pIndex) {
                              var currentProduct = cartController
                                  .saveLaterProducts
                                  .value[currentKey]!
                                  .products![pIndex];
                              return Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ImageBox(
                                            '${currentProduct.images![0]}',
                                            width: 80,
                                            height: 80,
                                          ),
                                          Column(
                                            children: [
                                              Text(currentProduct
                                                  .name!.defaultText!.text!),
                                              Text(
                                                  '${currentProduct.varient!.weight.toString()} ${currentProduct.varient!.unit}'),
                                              Text(
                                                  '${cartController.saveLaterProducts[currentKey]!.count!.toString()} * \$${currentProduct.varient!.price!.offerPrice!} ')
                                            ],
                                          ),
                                          Text(
                                              '\$${(cartController.saveLaterProducts[currentKey]!.price!.offerPrice * cartController.saveLaterProducts[currentKey]!.count).toString()}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () async {
                                stateController.showLoader.value = true;
                                await cartController.removeProduct(currentKey);
                                stateController.showLoader.value = false;
                              },
                              icon: const Icon(Icons.close_rounded)),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: saveLaterButtons(
                              context, cartController, currentKey),
                        )
                      ],
                    )
                  : Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ImageBox(
                                  cartController.saveLaterProducts
                                      .value[currentKey]!.product!.images![0],
                                  width: 80,
                                  height: 80,
                                ),
                                Column(
                                  children: [
                                    Text(cartController
                                        .saveLaterProducts
                                        .value[currentKey]!
                                        .product!
                                        .name!
                                        .defaultText!
                                        .text!),
                                    Text(
                                        '${cartController.saveLaterProducts.value[currentKey]!.product!.varient!.weight.toString()} ${cartController.saveLaterProducts.value[currentKey]!.product!.varient!.unit}'),
                                    Text(
                                        '${cartController.saveLaterProducts[currentKey]!.count!.toString()} * \$${cartController.saveLaterProducts.value[currentKey]!.product!.varient!.price!.offerPrice!} '),
                                  ],
                                ),
                                Text(
                                    '\$${(cartController.saveLaterProducts[currentKey]!.price!.offerPrice * cartController.saveLaterProducts[currentKey]!.count).toString()}'),
                                IconButton(
                                  onPressed: () async {
                                    stateController.showLoader.value = true;
                                    await cartController
                                        .removeProduct(currentKey);
                                    stateController.showLoader.value = false;
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                )
                              ],
                            ),
                            saveLaterButtons(
                                context, cartController, currentKey)
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  saveLaterButtons(context, cartController, currentKey) {
    return Row(
      children: [
        TextButton.icon(
            onPressed: () async {
              stateController.showLoader.value = true;
              await cartController.addTocartSaveLater(currentKey);
              stateController.showLoader.value = false;
            },
            icon: Icon(Icons.flash_on),
            label: Text(' "Add to cart"')),
        TextButton.icon(
            onPressed: () async {
              stateController.showLoader.value = true;
              await cartController.removeSaveLater(currentKey);
              stateController.showLoader.value = false;
            },
            icon: Icon(Icons.outbox),
            label: Text("Delete"))
      ],
    );
  }
}
