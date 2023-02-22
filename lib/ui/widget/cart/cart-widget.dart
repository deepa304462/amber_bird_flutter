import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/cart/save-later-widget.dart';
import 'package:amber_bird/ui/widget/coupon-widget.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class CartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartWidget();
  }
}

class _CartWidget extends State<CartWidget> {
  final CartController cartController = Get.find();
  final Controller stateController = Get.find();
  RxBool checkoutClicked = false.obs;
  TextEditingController ipController = TextEditingController();
  List<SliverList> innerLists = [];

  @override
  void initState() {
    super.initState();

    innerLists.add(SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) =>
          productListWidget(context, cartController),
      childCount: 1,
    )));
    innerLists.add(SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) =>
          scoinPRoductList(context, cartController),
      childCount: 1,
    )));
    innerLists.add(SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) => _saveLaterAndCheckoutOptions(),
      childCount: 1,
    )));
  }

  @override
  Widget build(BuildContext context) {
    cartController.clearCheckout();
    return Obx(() => (cartController.cartProducts.isNotEmpty ||
            cartController.cartProductsScoins.isNotEmpty)
        ? CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: innerLists,
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
                  SaveLater()
                ],
              ),
            ),
          ));
  }

  scoinPRoductList(context, cartController) {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartController.cartProductsScoins.length,
          itemBuilder: (_, index) {
            var currentKey =
                cartController.cartProductsScoins.value.keys.elementAt(index);
            return Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ImageBox(
                              cartController.cartProductsScoins
                                  .value[currentKey]!.product!.images![0],
                              width: 80,
                              height: 80,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: 160,
                                  child: Text(cartController
                                      .cartProductsScoins
                                      .value[currentKey]!
                                      .product!
                                      .name!
                                      .defaultText!
                                      .text!),
                                ),
                                Text(
                                    '${cartController.cartProductsScoins.value[currentKey]!.product!.varient!.weight.toString()} ${cartController.cartProductsScoins.value[currentKey]!.product!.varient!.unit}'),
                                Text(
                                    '${cartController.cartProductsScoins[currentKey]!.count!.toString()} * ${Helper.getMemberCoinValue(cartController.cartProductsScoins.value[currentKey]!.product!.varient!.price!, stateController.userType.value)} '),
                                Row(
                                  children: [
                                    IconButton(
                                      padding: const EdgeInsets.all(8),
                                      constraints: const BoxConstraints(),
                                      onPressed: () async {
                                        stateController.showLoader.value = true;
                                        if (stateController.isLogin.value) {
                                          cartController.addToCartScoins(
                                              cartController
                                                  .cartProductsScoins[
                                                      currentKey]
                                                  .ref!
                                                  .id,
                                              'SCOIN',
                                              -1,
                                              cartController
                                                  .cartProductsScoins[
                                                      currentKey]
                                                  .price,
                                              cartController
                                                  .cartProductsScoins[
                                                      currentKey]
                                                  .product,
                                              null,
                                              RuleConfig(),
                                              Constraint(),
                                              cartController
                                                  .cartProductsScoins[
                                                      currentKey]
                                                  .product
                                                  .varient);
                                        } else {
                                          stateController.setCurrentTab(4);
                                          var showToast =
                                              snackBarClass.showToast(context,
                                                  'Please Login to preoceed');
                                        }
                                        stateController.showLoader.value =
                                            false;
                                      },
                                      icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.black),
                                    ),
                                    Text(cartController
                                        .getCurrentQuantity(
                                            '${cartController.cartProductsScoins[currentKey].ref!.id}',
                                            'SCOIN')
                                        .toString()),
                                    IconButton(
                                      padding: const EdgeInsets.all(8),
                                      constraints: const BoxConstraints(),
                                      onPressed: () async {
                                        stateController.showLoader.value = true;
                                        if (stateController.isLogin.value) {
                                          var valid = false;
                                          var msg = 'Something went wrong!';
                                          cartController.addToCartScoins(
                                              cartController
                                                  .cartProductsScoins[
                                                      currentKey]
                                                  .ref!
                                                  .id,
                                              'SCOIN',
                                              1,
                                              cartController
                                                  .cartProductsScoins[
                                                      currentKey]
                                                  .price,
                                              cartController
                                                  .cartProductsScoins[
                                                      currentKey]
                                                  .product,
                                              null,
                                              RuleConfig(),
                                              Constraint(),
                                              cartController
                                                  .cartProductsScoins[
                                                      currentKey]
                                                  .product
                                                  .varient);

                                        } else {
                                          var showToast =
                                              snackBarClass.showToast(
                                                  context, 'Please Login');
                                        }

                                        stateController.showLoader.value =
                                            false;
                                      },
                                      icon: const Icon(Icons.add_circle_outline,
                                          color: Colors.black),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Text(Helper.getFormattedNumber(
                                    Helper.getMemberCoinValue(
                                            cartController
                                                .cartProductsScoins[currentKey]!
                                                .price!,
                                            stateController.userType.value) *
                                        cartController
                                            .cartProductsScoins[currentKey]!
                                            .count)
                                .toString()),
                            Positioned(
                              right: 990,
                              top: 50,
                              child: IconButton(
                                onPressed: () async {
                                  stateController.showLoader.value = true;
                                  await cartController.removeProduct(
                                      currentKey, 'SCOIN');
                                  stateController.showLoader.value = false;
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                            )
                          ],
                        ),
                        // cartButtons(context, cartController, currentKey)
                      ]),
                    ),
                  ),
                  checkoutClicked.value &&
                          !cartController.checktOrderRefAvailable(cartController
                              .cartProductsScoins.value[currentKey]!.ref)
                      ? recpmmondedProduct(context, cartController, currentKey)
                      // ,
                      //
                      : const SizedBox()
                ],
              ),
            );
          },
        ));
  }

  productListWidget(context, cartController) {
    return Obx((() => ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          // physics: const NeverScrollableScrollPhysics(),
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
                                  var currentProduct = cartController
                                      .cartProducts
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
                                                  SizedBox(
                                                    width: 160,
                                                    child: Text(currentProduct
                                                        .name!
                                                        .defaultText!
                                                        .text!),
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
                                    await cartController.removeProduct(
                                        currentKey, '');
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
                              right: 10,
                              bottom: -5,
                              child: cartButtons(
                                  context, cartController, currentKey),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      stateController.showLoader.value = true;
                                      if (stateController.isLogin.value) {
                                        var valid = false;
                                        var msg = 'Something went wrong!';

                                        if (cartController
                                                    .cartProducts[currentKey]!
                                                    .ruleConfig !=
                                                null ||
                                            cartController
                                                    .cartProducts[currentKey]!
                                                    .constraint !=
                                                null) {
                                          dynamic data = await Helper
                                              .checkProductValidtoAddinCart(
                                                  cartController
                                                      .cartProducts[currentKey]!
                                                      .ruleConfig,
                                                  cartController
                                                      .cartProducts[currentKey]!
                                                      .constraint,
                                                  cartController
                                                          .cartProducts[
                                                              currentKey]!
                                                          .ref!
                                                          .id ??
                                                      '',
                                                  cartController
                                                          .cartProducts[
                                                              currentKey]!
                                                          .ref!
                                                          .id ??
                                                      '');
                                          valid = !data['error'];
                                          msg = data['msg'];
                                        }

                                        // if (valid) {
                                        cartController.addToCart(
                                            '${cartController.cartProducts[currentKey]!.ref!.id}',
                                            cartController
                                                .cartProducts[currentKey]!
                                                .ref!
                                                .name!,
                                            -1,
                                            cartController
                                                .cartProducts[currentKey]!
                                                .price,
                                            null,
                                            cartController.cartProducts
                                                .value[currentKey]!.products,
                                            null,
                                            null);
                                      } else {
                                        stateController.setCurrentTab(3);
                                        var showToast = snackBarClass.showToast(
                                            context,
                                            'Please Login to preoceed');
                                      }
                                      stateController.showLoader.value = false;
                                    },
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.black),
                                  ),
                                  Text(cartController
                                      .getCurrentQuantity(
                                          '${cartController.cartProducts[currentKey]!.ref!.id}',
                                          '')
                                      .toString()),
                                  IconButton(
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      stateController.showLoader.value = true;
                                      if (stateController.isLogin.value) {
                                        var valid = false;
                                        var msg = 'Something went wrong!';

                                        if (cartController
                                                    .cartProducts[currentKey]!
                                                    .ruleConfig !=
                                                null ||
                                            cartController
                                                    .cartProducts[currentKey]!
                                                    .constraint !=
                                                null) {
                                          dynamic data = await Helper
                                              .checkProductValidtoAddinCart(
                                                  cartController
                                                      .cartProducts[currentKey]!
                                                      .ruleConfig,
                                                  cartController
                                                      .cartProducts[currentKey]!
                                                      .constraint,
                                                  cartController
                                                          .cartProducts[
                                                              currentKey]!
                                                          .ref!
                                                          .id ??
                                                      '',
                                                  cartController
                                                          .cartProducts[
                                                              currentKey]!
                                                          .ref!
                                                          .id ??
                                                      '');
                                          valid = !data['error'];
                                          msg = data['msg'];
                                        }

                                        if (valid) {
                                          cartController.addToCart(
                                              '${cartController.cartProducts[currentKey]!.ref!.id}',
                                              cartController
                                                  .cartProducts[currentKey]!
                                                  .ref!
                                                  .name!,
                                              1,
                                              cartController
                                                  .cartProducts[currentKey]!
                                                  .price,
                                              null,
                                              cartController.cartProducts
                                                  .value[currentKey]!.products,
                                              null,
                                              null);
                                        } else {
                                          var showToast = snackBarClass
                                              .showToast(context, msg);
                                        }
                                      }
                                      stateController.showLoader.value = false;
                                    },
                                    icon: const Icon(Icons.add_circle_outline,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ImageBox(
                                    cartController.cartProducts
                                        .value[currentKey]!.product!.images![0],
                                    width: 80,
                                    height: 80,
                                  ),
                                  Column(
                                    children: [
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
                                      Row(
                                        children: [
                                          IconButton(
                                            padding: const EdgeInsets.all(8),
                                            constraints: const BoxConstraints(),
                                            onPressed: () async {
                                              stateController.showLoader.value =
                                                  true;
                                              if (stateController
                                                  .isLogin.value) {
                                                cartController.addToCart(
                                                    '${cartController.cartProducts[currentKey]!.ref!.id}',
                                                    cartController
                                                        .cartProducts[
                                                            currentKey]!
                                                        .ref!
                                                        .name!,
                                                    -1,
                                                    cartController
                                                        .cartProducts[
                                                            currentKey]!
                                                        .price,
                                                    cartController
                                                        .cartProducts[
                                                            currentKey]!
                                                        .product,
                                                    null,
                                                    null,
                                                    null);
                                              } else {
                                                stateController
                                                    .setCurrentTab(3);
                                                var showToast =
                                                    snackBarClass.showToast(
                                                        context,
                                                        'Please Login to preoceed');
                                              }
                                              stateController.showLoader.value =
                                                  false;
                                            },
                                            icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.black),
                                          ),
                                          Text(cartController
                                              .getCurrentQuantity(
                                                  '${cartController.cartProducts[currentKey]!.ref!.id}',
                                                  '')
                                              .toString()),
                                          IconButton(
                                            padding: const EdgeInsets.all(8),
                                            constraints: const BoxConstraints(),
                                            onPressed: () async {
                                              stateController.showLoader.value =
                                                  true;
                                              if (stateController
                                                  .isLogin.value) {
                                                var valid = false;
                                                var msg =
                                                    'Something went wrong!';

                                                if (cartController
                                                            .cartProducts[
                                                                currentKey]!
                                                            .ruleConfig !=
                                                        null ||
                                                    cartController
                                                            .cartProducts[
                                                                currentKey]!
                                                            .constraint !=
                                                        null) {
                                                  dynamic data = await Helper
                                                      .checkProductValidtoAddinCart(
                                                          cartController
                                                              .cartProducts[
                                                                  currentKey]!
                                                              .ruleConfig,
                                                          cartController
                                                              .cartProducts[
                                                                  currentKey]!
                                                              .constraint,
                                                          cartController
                                                                  .cartProducts[
                                                                      currentKey]!
                                                                  .ref!
                                                                  .id ??
                                                              "",
                                                          cartController
                                                                  .cartProducts[
                                                                      currentKey]!
                                                                  .ref!
                                                                  .id ??
                                                              '');
                                                  valid = !data['error'];
                                                  msg = data['msg'];
                                                }
                                                if (valid) {
                                                  cartController.addToCart(
                                                      '${cartController.cartProducts[currentKey]!.ref!.id}',
                                                      cartController
                                                          .cartProducts[
                                                              currentKey]!
                                                          .ref!
                                                          .name!,
                                                      1,
                                                      cartController
                                                          .cartProducts[
                                                              currentKey]!
                                                          .price,
                                                      cartController
                                                          .cartProducts[
                                                              currentKey]!
                                                          .product,
                                                      null,
                                                      null,
                                                      null);
                                                } else {
                                                  var showToast = snackBarClass
                                                      .showToast(context, msg);
                                                }
                                              }
                                              stateController.showLoader.value =
                                                  false;
                                            },
                                            icon: const Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.black),
                                          ),
                                        ],
                                      )
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
                                        await cartController.removeProduct(
                                            currentKey, '');
                                        stateController.showLoader.value =
                                            false;
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
                          !cartController.checktOrderRefAvailable(cartController
                              .cartProducts.value[currentKey]!.ref)
                      ? recpmmondedProduct(context, cartController, currentKey)
                      : const SizedBox()
                ],
              ),
            );
          },
        )));
  }

  cartData(context, cartController) {
    return Expanded(
      child: Column(
        children: [
          const Text('Products'),
          productListWidget(context, cartController),
          const Text('Scoins Products'),
          scoinPRoductList(context, cartController)
        ],
      ),
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
            physics: const BouncingScrollPhysics(),
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
                                null,
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
    return Obx(() => Container(
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
                  onPressed: (() =>
                      {Modular.to.navigate('../home/address-list')}),
                  icon: const Icon(Icons.edit))
            ],
          ),
        ));
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
              stateController.showLoader.value = false;
            },
            icon: const Icon(Icons.outbox),
            label: const Text("Save for later"))
      ],
    );
  }

  ListView _saveLaterAndCheckoutOptions() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Obx(() {
            return Column(
              children: [
                shippingAddress(context),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      stateController.showLoader.value = true;
                      bool isCheckedActivate =
                          await stateController.getUserIsActive();
                      if (isCheckedActivate) {
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
                cartController.calculatedPayment.value.totalSCoinsPaid != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total coins',
                            style: TextStyles.headingFontGray,
                          ),
                          Text(
                            cartController
                                .calculatedPayment.value.totalSCoinsPaid
                                .toString(),
                            style: TextStyles.mrpStyle,
                          ),
                        ],
                      )
                    : const SizedBox(),
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
                (cartController.calculatedPayment.value != null &&
                        cartController
                                .calculatedPayment.value.appliedTaxDetail !=
                            null &&
                        cartController.calculatedPayment.value.appliedTaxDetail!
                                .length >
                            0)
                    ? Container(
                        margin: const EdgeInsets.all(2.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 113, 116, 122))),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: cartController
                              .calculatedPayment.value.appliedTaxDetail!.length,
                          itemBuilder: (_, pIndex) {
                            var currentTax = cartController.calculatedPayment
                                .value.appliedTaxDetail![pIndex];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        'You will rewarded with ${cartController.calculatedPayment.value.totalSCoinsEarned} SCOINS & ${cartController.calculatedPayment.value.totalSPointsEarned} SPOINTS on this order',
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
                        cartController.checkoutData.value!.allAvailable == true
                    ? Column(
                        children: [
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                var data = await cartController.createPayment();
                                if (data['error']) {
                                  // ignore: use_build_context_synchronously
                                  snackBarClass.showToast(context, data['msg']);
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
                                child: Text("Product Not Availale",
                                    style: TextStyles.headingFontBlue),
                              ),
                            ],
                          )
                        : const SizedBox()
              ],
            );
          }),
        ),
        SaveLater(),
      ],
    );
  }
}
