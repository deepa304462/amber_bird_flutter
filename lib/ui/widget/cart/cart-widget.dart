import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartWidget extends StatelessWidget {
  final CartController cartController = Get.find();
  @override
  Widget build(BuildContext context) {
    return cartController.cartProducts.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: cartController.cartProducts.length,
            itemBuilder: (_, index) {
              var currentKey =
                  cartController.cartProducts.value.keys.elementAt(index);
              // var currentProduct =
              //     cartController.cartProducts.value[currentKey]!.product;
              print(currentKey);
              // print(currentProduct);
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: [
                    cartController.cartProducts.value[currentKey]!.products!
                            .isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: cartController.cartProducts
                                .value[currentKey]!.products!.length,
                            itemBuilder: (_, pIndex) {
                              var currentProduct = cartController.cartProducts
                                  .value[currentKey]!.products![pIndex];
                              return Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.network(
                                            '${ClientService.cdnUrl}${currentProduct.images![0]}',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.fill),
                                        Column(
                                          children: [
                                            Text(currentProduct
                                                .name!.defaultText!.text!),
                                            Text(
                                                '${cartController.cartProducts[currentKey]!.count!.toString()} * \$${currentProduct.varient!.price!.offerPrice!} ')
                                          ],
                                        ),
                                        Text(
                                            '\$${cartController.cartProducts[currentKey]!.price!.offerPrice.toString()}')
                                      ]),
                                ),
                              );
                            })
                        : Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                        '${ClientService.cdnUrl}${cartController.cartProducts.value[currentKey]!.product!.images![0]}',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.fill),
                                    Column(
                                      children: [
                                        Text(cartController
                                            .cartProducts
                                            .value[currentKey]!
                                            .product!
                                            .name!
                                            .defaultText!
                                            .text!),
                                        Text(
                                            '${cartController.cartProducts[currentKey]!.count!.toString()} * \$${cartController.cartProducts.value[currentKey]!.product!.varient!.price!.offerPrice!} ')
                                      ],
                                    ),
                                    Text(
                                        '\$${cartController.cartProducts[currentKey]!.price!.offerPrice.toString()}')
                                  ]),
                            ),
                          ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            cartController.checkout();
                          },
                          child: Text(
                            'Checkout',
                            style: TextStyles.bodyFont,
                          )),
                    ),
                    Obx(() =>   cartController.checkoutData.value!=null && cartController.checkoutData.value!.allAvailable == true
                            ? Center(
                                child: Text("All PRoduct Availale",
                                    style: TextStyles.headingFontBlue),
                              )
                            : Center(
                                child: Text(" Product Not Availale",
                                    style: TextStyles.headingFontBlue),
                              ))
                        
                  ],
                ),
              );
            },
          )
        : const SizedBox();
  }
}
