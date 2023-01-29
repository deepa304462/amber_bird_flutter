import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/coupon-widget.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/codehelp.dart';
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
            () => Column(
              children: [
                cartData(context, cartController),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      shippingAddress(context),
                      Obx(
                        () => cartController
                                .paymentGateWaydropdownItems.isNotEmpty
                            ? DropdownButton(
                                value:
                                    cartController.selectedPaymentMethod.value,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: cartController
                                    .paymentGateWaydropdownItems
                                    .map((items) {
                                  return DropdownMenuItem(
                                    value: items['value'],
                                    child: Text(items['label'] ?? ''),
                                  );
                                }).toList(),
                                onChanged: (dynamic newValue) {
                                  stateController.showLoader.value = true;
                                  checkoutClicked.value = false;
                                  cartController.clearCheckout();
                                  cartController.selectedPaymentMethod.value =
                                      newValue!;
                                  stateController.showLoader.value = false;
                                },
                              )
                            : const SizedBox(),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            stateController.showLoader.value = true;
                            if (stateController.isActivate.value) {
                              await cartController.checkout();
                              checkoutClicked.value = true;
                            } else {
                              snackBarClass.showToast(
                                  context, 'Your profile is not active yet');
                            }
                            stateController.showLoader.value = false;
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
                            '${CodeHelp.euro}${cartController.calculatedPayment.value.totalAmount.toString()}',
                            style: TextStyles.mrpStyle,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount Amount',
                            style: TextStyles.headingFontGray,
                          ),
                          Text(
                            '${CodeHelp.euro}${cartController.calculatedPayment.value.discountAmount.toString()}',
                            style: TextStyles.mrpStyle,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tax',
                            style: TextStyles.headingFontGray,
                          ),
                          Text(
                            Helper.getFormattedNumber(cartController
                                    .calculatedPayment.value.appliedTaxAmount)
                                .toString(),
                            style: TextStyles.mrpStyle,
                          ),
                        ],
                      ),
                      (cartController.calculatedPayment.value
                                      .appliedTaxDetail !=
                                  null &&
                              cartController.calculatedPayment.value
                                      .appliedTaxDetail!.length >
                                  0)
                          ? Container(
                              margin: const EdgeInsets.all(2.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 113, 116, 122))),
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: cartController.calculatedPayment
                                    .value.appliedTaxDetail!.length,
                                itemBuilder: (_, pIndex) {
                                  var currentTax = cartController
                                      .calculatedPayment
                                      .value
                                      .appliedTaxDetail![pIndex];
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentTax.description ?? '',
                                        style: TextStyles.headingFontGray,
                                      ),
                                      Text(
                                        '${CodeHelp.euro}${Helper.getFormattedNumber(currentTax.amount).toString()}',
                                        style: TextStyles.bodyFontBold,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          : const SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              'You will rewarded with ${cartController.calculatedPayment.value.totalSCoins} SCOINS & ${cartController.calculatedPayment.value.totalSPoints} SPOINTS on this order',
                              style: TextStyles.body,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [CouponWidget()],
                        ),
                      ),
                      cartController.checkoutData.value != null &&
                              cartController.checkoutData.value!.allAvailable ==
                                  true
                          ? Column(
                              children: [
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      var data =
                                          await cartController.createPayment();
                                      if (data['error']) {
                                        // ignore: use_build_context_synchronously
                                        snackBarClass.showToast(
                                            context, data['msg']);
                                      } else {
                                        Modular.to.navigate('/home/inapp',
                                            arguments: data['data']);
                                      }
                                    },
                                    child: Text(
                                      'Payment',
                                      style: TextStyles.bodyFont,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : checkoutClicked.value
                              ? Column(
                                  children: [
                                    Center(
                                      child: Text(" Product Not Availale",
                                          style: TextStyles.headingFontBlue),
                                    ),
                                  ],
                                )
                              : const SizedBox()
                    ],
                  ),
                ),
              ],
            ),
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

  cartData(context, cartController) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: cartController.cartProducts.length,
      itemBuilder: (_, index) {
        var currentKey =
            cartController.cartProducts.value.keys.elementAt(index);
        return Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Column(
            children: [
              cartController
                      .cartProducts.value[currentKey]!.products!.isNotEmpty
                  ? Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(2.0),
                          padding: const EdgeInsets.fromLTRB(3.0, 3, 3, 20),
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
                              var currentProduct = cartController.cartProducts
                                  .value[currentKey]!.products![pIndex];
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
                                              SizedBox(
                                                width: 160,
                                                child: Text(currentProduct
                                                    .name!.defaultText!.text!),
                                              ),
                                              Text(
                                                  '${currentProduct.varient!.weight.toString()} ${currentProduct.varient!.unit}'),
                                              Text(
                                                  '${cartController.cartProducts[currentKey]!.count!.toString()} * ${CodeHelp.euro}${currentProduct.varient!.price!.offerPrice!} ')
                                            ],
                                          ),
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
                        Positioned(
                          left: 10,
                          bottom: 0,
                          child: Text(
                              'Total: ${CodeHelp.euro}${Helper.getFormattedNumber(cartController.cartProducts[currentKey]!.price!.offerPrice * cartController.cartProducts[currentKey]!.count).toString()}'),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child:
                              cartButtons(context, cartController, currentKey),
                        )
                      ],
                    )
                  : Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ImageBox(
                                cartController.cartProducts.value[currentKey]!
                                    .product!.images![0],
                                width: 80,
                                height: 80,
                              ),
                              Column(
                                children: [
                                  // Text(cartController
                                  //     .cartProducts
                                  //     .value[currentKey]!
                                  //     .product!
                                  //     .name!
                                  //     .defaultText!
                                  //     .text!),
                                  SizedBox(
                                    width: 160,
                                    child: Text(cartController
                                        .cartProducts
                                        .value[currentKey]!
                                        .product!
                                        .name!
                                        .defaultText!
                                        .text!),
                                  ),
                                  Text(
                                      '${cartController.cartProducts.value[currentKey]!.product!.varient!.weight.toString()} ${cartController.cartProducts.value[currentKey]!.product!.varient!.unit}'),
                                  Text(
                                      '${cartController.cartProducts[currentKey]!.count!.toString()} * ${CodeHelp.euro}${cartController.cartProducts.value[currentKey]!.product!.varient!.price!.offerPrice!} '),
                                ],
                              ),
                              Text(
                                  '${CodeHelp.euro}${Helper.getFormattedNumber(cartController.cartProducts[currentKey]!.price!.offerPrice * cartController.cartProducts[currentKey]!.count).toString()}'),
                              Positioned(
                                right: 990,
                                top: 50,
                                child: IconButton(
                                  onPressed: () async {
                                    stateController.showLoader.value = true;
                                    await cartController
                                        .removeProduct(currentKey);
                                    stateController.showLoader.value = false;
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                              )
                            ],
                          ),
                          cartButtons(context, cartController, currentKey)
                        ]),
                      ),
                    ),
              checkoutClicked.value &&
                      !cartController.checktOrderRefAvailable(
                          cartController.cartProducts.value[currentKey]!.ref)
                  ? recpmmondedProduct(context, cartController, currentKey)
                  // ,
                  //
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }

  recpmmondedProduct(context, cartController, currentKey) {
    var prod = cartController
        .getRecommendedProd(cartController.cartProducts.value[currentKey]!.ref);
    return Column(
      children: [
        Text('Recommonded Products', style: TextStyles.headingFont),
        Container(
          // margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(5),
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              prod.productAvailabilityStatus != null
                  ? prod.productAvailabilityStatus!.recommendedProducts!
                          .isNotEmpty
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: prod.productAvailabilityStatus!
                              .recommendedProducts!.length,
                          itemBuilder: (_, index) {
                            var curProd = prod.productAvailabilityStatus!
                                .recommendedProducts![index];
                            return ProductCard(
                                curProd,
                                curProd.id,
                                'RECOMMEDED_PRODUCT',
                                curProd.varient!.price!,
                                null);
                          })
                      : const Text('No Product available')
                  : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }

  shippingAddress(context) {
    LocationController locationController = Get.find();
    log(locationController.addressData.toString());
    var add = locationController.addressData;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(2.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 113, 116, 122)),
      ),
      child: Column(
        children: [
          Text(
            'Address',
            style: TextStyles.titleLargeBold,
          ),
          Text(add.value.name ?? '', style: TextStyles.headingFont),
          Text(add.value.line1 ?? '', style: TextStyles.bodyFont),
          Text('ZipCode: ${add.value.zipCode ?? ''}',
              style: TextStyles.headingFont),
          IconButton(
              onPressed: (() => {Modular.to.navigate('../home/address-list')}),
              icon: const Icon(Icons.edit))
        ],
      ),
    );
  }

  cartButtons(context, cartController, currentKey) {
    return Row(
      children: [
        // TextButton.icon(
        //     onPressed: () => {},
        //     icon: Icon(Icons.flash_on),
        //     label: Text(' "Buy it now"')),
        TextButton.icon(
            onPressed: () async {
              stateController.showLoader.value = true;
              await cartController.createSaveLater(
                  cartController.cartProducts[currentKey], currentKey);
              stateController.showLoader.value = true;
            },
            icon: const Icon(Icons.outbox),
            label: const Text("Save for later"))
      ],
    );
  }
}
