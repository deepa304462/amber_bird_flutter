import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/coupon-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class CartWidget extends StatelessWidget {
  final CartController cartController = Get.find();
  final Controller stateController = Get.find();
  RxBool checkoutClicked = false.obs;
  TextEditingController ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    cartController.clearCheckout();
    return cartController.cartProducts.isNotEmpty
        ? Obx(
            () => Column(children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Image.network(
                                                      '${ClientService.cdnUrl}${currentProduct.images![0]}',
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.fill),
                                                  Column(
                                                    children: [
                                                      Text(currentProduct.name!
                                                          .defaultText!.text!),
                                                      Text(
                                                          '${currentProduct.varient!.weight.toString()} ${currentProduct.varient!.unit}'),
                                                      Text(
                                                          '${cartController.cartProducts[currentKey]!.count!.toString()} * \$${currentProduct.varient!.price!.offerPrice!} ')
                                                    ],
                                                  ),
                                                  Text(
                                                      '\$${cartController.cartProducts[currentKey]!.price!.offerPrice.toString()}'),
                                                ]),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                        onPressed: () {
                                          cartController
                                              .removeProduct(currentKey);
                                        },
                                        icon: const Icon(Icons.close_rounded)),
                                  )
                                ],
                              )
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
                                              '${cartController.cartProducts[currentKey]!.count!.toString()} * \$${cartController.cartProducts.value[currentKey]!.product!.varient!.price!.offerPrice!} '),
                                        ],
                                      ),
                                      Text(
                                          '\$${cartController.cartProducts[currentKey]!.price!.offerPrice.toString()}'),
                                      IconButton(
                                        onPressed: () {
                                          cartController
                                              .removeProduct(currentKey);
                                        },
                                        icon: const Icon(Icons.close_rounded),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (stateController.isActivate.value) {
                              cartController.checkout();
                              checkoutClicked.value = true;
                            } else {
                              snackBarClass.showToast(
                                  context, 'Your profile is not active yet');
                            }
                          },
                          child: Text(
                            'Checkout',
                            style: TextStyles.bodyFont,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyles.headingFontGray,
                          ),
                          Text(
                            cartController.totalPrice.value.offerPrice
                                .toString(),
                            style: TextStyles.mrpStyle,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CouponWidget()
                          // SizedBox(
                          //   height: 120,
                          //   width: MediaQuery.of(context).size.width * 0.5,
                          //   child: TextField(
                          //     style: TextStyles.title,
                          //     decoration: InputDecoration(
                          //       border: InputBorder.none,
                          //       labelText: "Coupon name",
                          //     ),
                          //     controller: ipController,
                          //     obscureText: true,
                          //     // keyboardType: Ke,
                          //     // readOnly: isDisabled,
                          //   ),
                          // ),
                          // TextButton(
                          //   onPressed: () {
                          //     print(ipController.value);
                          //     cartController.applyCoupon();
                          //   },
                          //   child: Text(
                          //     'Apply coupon',
                          //     style: TextStyles.headingFontGray,
                          //   ),
                          // ),
                        ],
                      ),
                      cartController.checkoutData.value != null &&
                              cartController.checkoutData.value!.allAvailable ==
                                  true
                          ? Column(
                              children: [
                                Center(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        var data = await cartController
                                            .createPayment();
                                        print(data);
                                        Modular.to.navigate('/home/inapp',
                                            arguments: data['data']);
                                      },
                                      child: Text(
                                        'Payment',
                                        style: TextStyles.bodyFont,
                                      )),
                                )
                              ],
                            )
                          : checkoutClicked.value
                              ? Column(
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
                                )
                              : const SizedBox()
                    ],
                  ),
                ),
              ),
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
