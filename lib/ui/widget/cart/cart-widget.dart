import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartWidget extends StatelessWidget {
  final CartController cartController = Get.find();
  
  @override
  Widget build(BuildContext context) {
    cartController.clearCheckout();
    return cartController.cartProducts.isNotEmpty
        ? Obx(
            () => Column(children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: cartController.cartProducts.length,
                    itemBuilder: (_, index) {
                      var currentKey = cartController.cartProducts.value.keys
                          .elementAt(index);
                      print(currentKey);
                      return Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: cartController.cartProducts.value[currentKey]!
                                .products!.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: cartController.cartProducts
                                    .value[currentKey]!.products!.length,
                                itemBuilder: (_, pIndex) {
                                  var currentProduct = cartController
                                      .cartProducts
                                      .value[currentKey]!
                                      .products![pIndex];
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
                                                '\$${cartController.cartProducts[currentKey]!.price!.offerPrice.toString()}'),
                                            IconButton(
                                                onPressed: () {
                                                  cartController.removeProduct(
                                                      currentKey);
                                                },
                                                icon: const Icon(
                                                    Icons.close_rounded))
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
                                            '\$${cartController.cartProducts[currentKey]!.price!.offerPrice.toString()}'),
                                        IconButton(
                                            onPressed: () {
                                              cartController
                                                  .removeProduct(currentKey);
                                            },
                                            icon:
                                                const Icon(Icons.close_rounded))
                                      ]),
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
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
                      cartController.checkoutData.value != null &&
                              cartController.checkoutData.value!.allAvailable ==
                                  true
                          ? Column(
                              children: [
                                Center(
                                  child: Text("All PRoduct Availale",
                                      style: TextStyles.headingFontBlue),
                                ),
                                Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        cartController.createPayment();
                                      },
                                      child: Text(
                                        'Payment',
                                        style: TextStyles.bodyFont,
                                      )),
                                )
                              ],
                            )
                          : Column(
                              children: [
                                Center(
                                  child: Text(" Product Not Availale",
                                      style: TextStyles.headingFontBlue),
                                ),
                                // Text('Recommonded Products',style: TextStyles.headingFont),
                                //  Container(
                                //   margin: const EdgeInsets.all(5.0),
                                //   height: 160,
                                //   child: ListView(
                                //       scrollDirection: Axis.horizontal,
                                //       shrinkWrap: true,
                                //       children: [
                                //         for (var i = 0;
                                //             i < cartController.checkoutData.value!.productAvailability!.recommendedProducts;
                                //             i++) ...[
                                //           SizedBox(
                                //             width: 150,
                                //             child: ProductCard(
                                //                 mProduct.products![i],
                                //                 mProduct.products![i].id,
                                //                 'MULTIPRODUCT',
                                //                 mProduct.products![i].varient!
                                //                     .price!),
                                //           )
                                //         ]
                                //       ]),
                                // ),
                              ],
                            ),
                    ],
                  ))
            ]),
          )
        : const SizedBox();
  }
}
