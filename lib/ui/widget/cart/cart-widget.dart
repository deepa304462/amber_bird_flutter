import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
                                                    '${currentProduct.varient!.weight.toString()} ${currentProduct.varient!.unit}'),
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
                                                '${cartController.cartProducts.value[currentKey]!.product!.varient!.weight.toString()} ${cartController.cartProducts.value[currentKey]!.product!.varient!.unit}'),
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
                                  child: Text("All Product Availale",
                                      style: TextStyles.headingFontBlue),
                                ),
                                Center(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        var data = await cartController
                                            .createPayment();
                                        print(data);
                                        Modular.to.navigate('/home/inapp',
                                            arguments: data['data']);
                                        // HeadlessInAppWebView headlessWebView =
                                        //     HeadlessInAppWebView(
                                        //   initialUrlRequest: URLRequest(
                                        //       url: Uri.parse(
                                        //           "https://github.com/flutter")),
                                        //   onWebViewCreated: (controller) {
                                        //     const snackBar = SnackBar(
                                        //       content:  Text(
                                        //           'HeadlessInAppWebView created!'),
                                        //       duration: Duration(seconds: 1),
                                        //     );
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(snackBar);
                                        //   },
                                        //   onConsoleMessage:
                                        //       (controller, consoleMessage) {
                                        //     final snackBar = SnackBar(
                                        //       content: Text(
                                        //           'Console Message: ${consoleMessage.message}'),
                                        //       duration: Duration(seconds: 1),
                                        //     );
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(snackBar);
                                        //   },
                                        //   onLoadStart: (controller, url) async {
                                        //     final snackBar = SnackBar(
                                        //       content: Text('onLoadStart $url'),
                                        //       duration: Duration(seconds: 1),
                                        //     );
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(snackBar);

                                        //     // setState(() {
                                        //     //   this.url = url?.toString() ?? '';
                                        //     // });
                                        //   },
                                        //   onLoadStop: (controller, url) async {
                                        //     final snackBar = SnackBar(
                                        //       content: Text('onLoadStop $url'),
                                        //       duration: Duration(seconds: 1),
                                        //     );
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(snackBar);

                                        //     // setState(() {
                                        //     //   this.url = url?.toString() ?? '';
                                        //     // });
                                        //   },
                                        // );
                                        // headlessWebView.run();
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
        : Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Your Cart is Empty',
                    style: TextStyles.bodyFont,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primeColor,
                        textStyle: TextStyles.bodyWhite),
                    onPressed: () {
                      Modular.to.navigate('../home/main');
                    },
                    child: Text(
                      'Add Products',
                      style: TextStyles.bodyWhiteLarge,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
