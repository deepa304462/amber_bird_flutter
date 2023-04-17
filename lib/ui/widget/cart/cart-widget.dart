import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/cart/save-later-widget.dart';
import 'package:amber_bird/ui/widget/coupon-widget.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../helpers/controller-generator.dart';

class CartWidget extends StatelessWidget {
  late CartController cartController;
  final Controller stateController = Get.find();
  RxBool checkoutClicked = false.obs;
  TextEditingController ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    cartController =
        ControllerGenerator.create(CartController(), tag: 'cartController');
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 1, color: Colors.grey))),
        child: Obx(
          () => (cartController.cartProducts.isNotEmpty ||
                      cartController.cartProductsScoins.isNotEmpty ||
                      cartController.msdProducts.isNotEmpty) &&
                  cartController.calculatedPayment.value.totalAmount != null &&
                  cartController.calculatedPayment.value.totalAmount as double >
                      0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL PRICE',
                            style: TextStyles.body,
                          ),
                          Text(
                            '${CodeHelp.euro}${(cartController.calculatedPayment.value.totalAmount != null ? cartController.calculatedPayment.value.totalAmount as double : 0).toStringAsFixed(2)}',
                            style: TextStyles.headingFont,
                          ),
                        ],
                      ),
                      MaterialButton(
                        color: Colors.green,
                        visualDensity: const VisualDensity(horizontal: 4),
                        onPressed: () async {
                          var checkoutResp = await cartController.checkout();
                          checkoutClicked.value = true;
                          checkoutClicked.refresh();
                          if (checkoutResp == null || checkoutResp['error']) {
                            // ignore: use_build_context_synchronously
                            snackBarClass.showToast(context,
                                checkoutResp['msg'] ?? 'Something went wrong');
                          } else {
                            if (cartController
                                    .checkoutData.value!.allAvailable ==
                                true) {
                              var data = await cartController.createPayment();
                              if (data == null || data['error']) {
                                // ignore: use_build_context_synchronously
                                snackBarClass.showToast(context,
                                    data['msg'] ?? 'Something went wrong');
                              } else {
                                Modular.to.navigate('/home/inapp',
                                    arguments: data['data']);
                              }
                            } else {
                              // ignore: use_build_context_synchronously
                              snackBarClass.showToast(
                                  context, 'All product not available');
                            }
                          }
                        },
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          'Payment',
                          style: TextStyles.bodyFontBold
                              .copyWith(color: Colors.white),
                        ),
                      )
                    ],
                  ))
              : const SizedBox(),
        ),
      ),
      body: Obx(
        () {
          cartController.innerLists.clear();
          cartController.innerLists.add(
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    shippingAddress(context),
                  ],
                ),
                childCount: 1,
              ),
            ),
          );
          cartController.innerLists.add(
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) =>
                    productListWidget(context, cartController),
                childCount: 1,
              ),
            ),
          );
          cartController.innerLists.add(
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) =>
                    scoinPRoductList(context, cartController),
                childCount: 1,
              ),
            ),
          );
          cartController.innerLists.add(
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) =>
                    msdPRoductList(context, cartController),
                childCount: 1,
              ),
            ),
          );
          cartController.innerLists.add(
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) =>
                    _saveLaterAndCheckoutOptions(context),
                childCount: 1,
              ),
            ),
          );
          cartController.clearCheckout();
          return (cartController.cartProducts.isNotEmpty ||
                  cartController.cartProductsScoins.isNotEmpty)
              ? CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: cartController.innerLists,
                )
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'Your Cart is Empty',
                          style: TextStyles.body,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primeColor,
                              textStyle: TextStyles.body
                                  .copyWith(color: AppColors.white)),
                          onPressed: () {
                            Modular.to.navigate('../home/main');
                          },
                          child: Text(
                            'Add Products',
                            style: TextStyles.headingFont
                                .copyWith(color: AppColors.white),
                          ),
                        ),
                        SaveLater()
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  msdPRoductList(context, cartController) {
    return Obx(
      (() => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: cartController.msdProducts.length,
            itemBuilder: (_, index) {
              var currentKey =
                  cartController.msdProducts.value.keys.elementAt(index);
              var currentProduct =
                  cartController.msdProducts.value[currentKey]!;
              var minOrder = (currentProduct.constraint != null &&
                      currentProduct.constraint.minimumOrder != null)
                  ? currentProduct.constraint!.minimumOrder
                  : 1;
              return Column(
                children: [
                  currentProduct.products!.isNotEmpty
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Row(children: <Widget>[
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .1,
                                    child: Divider()),
                                FitText(
                                  '${currentProduct.name}',
                                  style: TextStyles.headingFont
                                      .copyWith(color: AppColors.primeColor),
                                ),
                                const Expanded(child: Divider()),
                              ]),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .73,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          currentProduct.products!.length,
                                      itemBuilder: (_, pIndex) {
                                        var currentInnerProduct =
                                            currentProduct.products![pIndex];
                                        return ListTile(
                                          dense: false,
                                          visualDensity:
                                              const VisualDensity(vertical: 3),
                                          leading: ImageBox(
                                            '${currentInnerProduct.images![0]}',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.contain,
                                          ),
                                          title: FitText(
                                            currentInnerProduct
                                                .name!.defaultText!.text!,
                                            style: TextStyles.headingFont,
                                            align: TextAlign.start,
                                          ),
                                          subtitle: Text(
                                            '${currentInnerProduct.varient!.weight.toString()} ${CodeHelp.formatUnit(currentInnerProduct!.varient!.unit)}',
                                            style: TextStyles.body,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${CodeHelp.euro}${Helper.getFormattedNumber(currentProduct.price!.offerPrice * currentProduct.count).toString()}',
                                          style: TextStyles.headingFont,
                                        ),
                                        Card(
                                          color: AppColors.primeColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () async {
                                                  stateController
                                                      .showLoader.value = true;
                                                      stateController.showLoader
                                                      .refresh();
                                                  if (stateController
                                                      .isLogin.value) {
                                                    var valid = false;
                                                    var msg =
                                                        'Something went wrong!';

                                                    if (currentProduct
                                                                .ruleConfig !=
                                                            null ||
                                                        currentProduct
                                                                .constraint !=
                                                            null) {
                                                      dynamic data = await Helper
                                                          .checkProductValidtoAddinCart(
                                                              currentProduct
                                                                  .ruleConfig,
                                                              currentProduct
                                                                  .constraint,
                                                              currentProduct
                                                                      .ref!
                                                                      .id ??
                                                                  '',
                                                              currentProduct
                                                                      .ref!
                                                                      .id ??
                                                                  '');
                                                      valid = !data['error'];
                                                      msg = data['msg'];
                                                    }
                                                    if (valid) {
                                                      await cartController
                                                          .addToCartMSD(
                                                              '${currentProduct.ref!.id}',
                                                              currentProduct
                                                                  .ref!.name!,
                                                              minOrder,
                                                              currentProduct
                                                                  .price,
                                                              null,
                                                              currentProduct
                                                                  .products,
                                                              currentProduct
                                                                  .ruleConfig,
                                                              currentProduct
                                                                  .constraint,
                                                              null,
                                                              mutliProductName:
                                                                  currentProduct
                                                                          .name ??
                                                                      "");
                                                    } else {
                                                      var showToast =
                                                          snackBarClass
                                                              .showToast(
                                                                  context, msg);
                                                    }
                                                  }
                                                  stateController
                                                      .showLoader.value = false;
                                                },
                                                icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.white,
                                                  size: FontSizes.title,
                                                ),
                                              ),
                                              Text(
                                                  cartController
                                                      .getCurrentQuantity(
                                                          '${currentProduct.ref!.id}',
                                                          'MSD')
                                                      .toString(),
                                                  style: TextStyles.headingFont
                                                      .copyWith(
                                                          color: Colors.white)),
                                              IconButton(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () async {
                                                  stateController
                                                      .showLoader.value = true;
                                                      stateController.showLoader
                                                      .refresh();
                                                  if (stateController
                                                      .isLogin.value) {
                                                    var valid = false;
                                                    var msg =
                                                        'Something went wrong!';

                                                    if (currentProduct
                                                                .ruleConfig !=
                                                            null ||
                                                        currentProduct
                                                                .constraint !=
                                                            null) {
                                                      dynamic data = await Helper
                                                          .checkProductValidtoAddinCart(
                                                              currentProduct
                                                                  .ruleConfig,
                                                              currentProduct
                                                                  .constraint,
                                                              currentProduct
                                                                      .ref!
                                                                      .id ??
                                                                  '',
                                                              currentProduct
                                                                      .ref!
                                                                      .id ??
                                                                  '');
                                                      valid = !data['error'];
                                                      msg = data['msg'];
                                                    }
                                                    if (valid) {
                                                      await cartController
                                                          .addToCartMSD(
                                                              '${currentProduct.ref!.id}',
                                                              currentProduct
                                                                  .ref!.name!,
                                                              minOrder,
                                                              currentProduct
                                                                  .price,
                                                              null,
                                                              currentProduct
                                                                  .products,
                                                              currentProduct
                                                                  .ruleConfig,
                                                              currentProduct
                                                                  .constraint,
                                                              null,
                                                              mutliProductName:
                                                                  currentProduct
                                                                          .name ??
                                                                      '');
                                                    } else {
                                                      var showToast =
                                                          snackBarClass
                                                              .showToast(
                                                                  context, msg);
                                                    }
                                                  }
                                                  stateController
                                                      .showLoader.value = false;
                                                },
                                                icon: Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.white,
                                                  size: FontSizes.title,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  cartButtons(
                                      context, cartController, currentKey),
                                  MaterialButton(
                                      onPressed: () async {
                                        stateController.showLoader.value = true;
                                        stateController.showLoader.refresh();
                                        await cartController.removeProduct(
                                            currentKey, 'MSD');
                                        stateController.showLoader.value =
                                            false;
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.delete,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Remove',
                                            style: TextStyles.body.copyWith(
                                              color: Colors.grey,
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              )
                            ],
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                dense: false,
                                visualDensity: const VisualDensity(vertical: 3),
                                leading: ImageBox(
                                  currentProduct.product!.images![0],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                                title: FitText(
                                  currentProduct
                                      .product!.name!.defaultText!.text!,
                                  style: TextStyles.headingFont,
                                  align: TextAlign.start,
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      '${currentProduct.product!.varient!.weight.toString()} ${CodeHelp.formatUnit(currentProduct.product!.varient!.unit)}',
                                      style: TextStyles.body,
                                    ),
                                    Text(
                                        '/${CodeHelp.euro}${Helper.getFormattedNumber(currentProduct.price!.offerPrice!)} ',
                                        style: TextStyles.body),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${CodeHelp.euro}${Helper.getFormattedNumber(Helper.getMsdAmount(price: currentProduct.price!, userType: stateController.userType.value) * currentProduct.count).toString()}',
                                      style: TextStyles.headingFont,
                                    ),
                                    Card(
                                      color: AppColors.primeColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            padding: const EdgeInsets.all(4),
                                            constraints: const BoxConstraints(),
                                            onPressed: () async {
                                              stateController.showLoader.value =
                                                  true;
                                              if (stateController
                                                  .isLogin.value) {
                                                cartController.addToCartMSD(
                                                  '${currentProduct.ref!.id}',
                                                  currentProduct.ref!.name!,
                                                  -minOrder,
                                                  currentProduct.price,
                                                  currentProduct.product,
                                                  null,
                                                  currentProduct.ruleConfig,
                                                  currentProduct.constraint,
                                                  currentProduct
                                                      .product.varient,
                                                );
                                              } else {
                                                stateController
                                                    .setCurrentTab(3);

                                                snackBarClass.showToast(context,
                                                    'Please Login to preoceed');
                                              }
                                              stateController.showLoader.value =
                                                  false;
                                            },
                                            icon: Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.white,
                                              size: FontSizes.title,
                                            ),
                                          ),
                                          Text(
                                            cartController
                                                .getCurrentQuantity(
                                                    '${currentProduct.ref!.id}',
                                                    'MSD')
                                                .toString(),
                                            style: TextStyles.headingFont
                                                .copyWith(color: Colors.white),
                                          ),
                                          IconButton(
                                            padding: const EdgeInsets.all(4),
                                            constraints: const BoxConstraints(),
                                            onPressed: () async {
                                              stateController.showLoader.value =
                                                  true;
                                              if (stateController
                                                  .isLogin.value) {
                                                var valid = false;
                                                var msg =
                                                    'Something went wrong!';

                                                if (currentProduct.ruleConfig !=
                                                        null ||
                                                    currentProduct.constraint !=
                                                        null) {
                                                  dynamic data = await Helper
                                                      .checkProductValidtoAddinCart(
                                                          currentProduct
                                                              .ruleConfig,
                                                          currentProduct
                                                              .constraint,
                                                          currentProduct
                                                                  .ref!.id ??
                                                              "",
                                                          currentProduct
                                                                  .ref!.id ??
                                                              '');
                                                  valid = !data['error'];
                                                  msg = data['msg'];
                                                }
                                                if (valid) {
                                                  cartController.addToCartMSD(
                                                      '${currentProduct.ref!.id}',
                                                      currentProduct.ref!.name!,
                                                      minOrder,
                                                      currentProduct.price,
                                                      currentProduct.product,
                                                      null,
                                                      currentProduct.ruleConfig,
                                                      currentProduct.constraint,
                                                      currentProduct
                                                          .product.varient);
                                                } else {
                                                  snackBarClass.showToast(
                                                      context, msg);
                                                }
                                              }
                                              stateController.showLoader.value =
                                                  false;
                                            },
                                            icon: Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.white,
                                              size: FontSizes.title,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  cartButtons(
                                      context, cartController, currentKey),
                                  MaterialButton(
                                    onPressed: () async {
                                      stateController.showLoader.value = true;
                                      stateController.showLoader.refresh();
                                      await cartController.removeProduct(
                                          currentKey, 'MSD');
                                      stateController.showLoader.value = false;
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.delete,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Remove',
                                          style: TextStyles.body.copyWith(
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                  Obx(() => checkoutClicked.value &&
                          !cartController.checktOrderRefAvailable(cartController
                              .cartProducts.value[currentKey]!.ref)
                      ? recpmmondedProduct(context, cartController, currentKey)
                      : const SizedBox())
                ],
              );
            },
          )),
    );
  }

  scoinPRoductList(context, cartController) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cartController.cartProductsScoins.length,
        itemBuilder: (_, index) {
          var currentKey =
              cartController.cartProductsScoins.value.keys.elementAt(index);
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: false,
                  visualDensity: const VisualDensity(vertical: 3),
                  leading: ImageBox(
                    cartController.cartProductsScoins.value[currentKey]!
                        .product!.images![0],
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  title: FitText(
                    cartController.cartProductsScoins.value[currentKey]!
                        .product!.name!.defaultText!.text!,
                    style: TextStyles.headingFont,
                    align: TextAlign.start,
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        '${cartController.cartProductsScoins.value[currentKey]!.product!.varient!.weight.toString()} ${CodeHelp.formatUnit(cartController.cartProductsScoins.value[currentKey]!.product!.varient!.unit)}',
                        style: TextStyles.body,
                      ),
                      Text(
                          '/${Helper.getMemberCoinValue(cartController.cartProductsScoins.value[currentKey]!.product!.varient!.price!, stateController.userType.value)} ',
                          style: TextStyles.body),
                    ],
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Helper.getFormattedNumber(
                                      Helper.getMemberCoinValue(
                                              cartController
                                                  .cartProductsScoins[
                                                      currentKey]!
                                                  .price!,
                                              stateController.userType.value) *
                                          cartController
                                              .cartProductsScoins[currentKey]!
                                              .count)
                                  .toString(),
                              style: TextStyles.headingFont,
                            ),
                            Lottie.asset('assets/coin.json',
                                height: 25, fit: BoxFit.fill, repeat: true),
                          ],
                        ),
                      ),
                      Card(
                        color: AppColors.primeColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                              onPressed: () async {
                                stateController.showLoader.value = true;
                                stateController.showLoader.refresh();
                                if (stateController.isLogin.value) {
                                  cartController.addToCartScoins(
                                      cartController
                                          .cartProductsScoins[currentKey]
                                          .ref!
                                          .id,
                                      'SCOIN',
                                      -1,
                                      cartController
                                          .cartProductsScoins[currentKey].price,
                                      cartController
                                          .cartProductsScoins[currentKey]
                                          .product,
                                      null,
                                      RuleConfig(),
                                      Constraint(),
                                      cartController
                                          .cartProductsScoins[currentKey]
                                          .product
                                          .varient);
                                } else {
                                  stateController.setCurrentTab(4);
                                  var showToast = snackBarClass.showToast(
                                      context, 'Please Login to preoceed');
                                }
                                stateController.showLoader.value = false;
                              },
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            Text(
                                cartController
                                    .getCurrentQuantity(
                                        '${cartController.cartProductsScoins[currentKey].ref!.id}',
                                        'SCOIN')
                                    .toString(),
                                style: TextStyles.headingFont
                                    .copyWith(color: Colors.white)),
                            IconButton(
                              padding: const EdgeInsets.all(4),
                              constraints: const BoxConstraints(),
                              onPressed: () async {
                                stateController.showLoader.value = true;
                                stateController.showLoader.refresh();
                                if (stateController.isLogin.value) {
                                  await cartController.addToCartScoins(
                                      cartController
                                          .cartProductsScoins[currentKey]
                                          .ref!
                                          .id,
                                      'SCOIN',
                                      1,
                                      cartController
                                          .cartProductsScoins[currentKey].price,
                                      cartController
                                          .cartProductsScoins[currentKey]
                                          .product,
                                      null,
                                      RuleConfig(),
                                      Constraint(),
                                      cartController
                                          .cartProductsScoins[currentKey]
                                          .product
                                          .varient);
                                } else {
                                  snackBarClass.showToast(
                                      context, 'Please Login');
                                }

                                stateController.showLoader.value = false;
                              },
                              icon: Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                                size: FontSizes.title,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    stateController.showLoader.value = true;
                    stateController.showLoader.refresh();
                    await cartController.removeProduct(currentKey, 'SCOIN');
                    stateController.showLoader.value = false;
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.delete,
                        size: 16,
                        color: Colors.grey,
                      ),
                      Text(
                        'Remove',
                        style: TextStyles.body.copyWith(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  productListWidget(context, cartController) {
    return Obx(
      (() => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: cartController.cartProducts.length,
            itemBuilder: (_, index) {
              var currentKey =
                  cartController.cartProducts.value.keys.elementAt(index);
              var currentProduct =
                  cartController.cartProducts.value[currentKey]!;
              var minOrder = (currentProduct.constraint != null &&
                      currentProduct.constraint.minimumOrder != null)
                  ? currentProduct.constraint!.minimumOrder
                  : 1;
              return Column(
                children: [
                  currentProduct.products!.isNotEmpty
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Row(children: <Widget>[
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .1,
                                    child: const Divider()),
                                FitText(
                                  '${currentProduct.name}',
                                  style: TextStyles.headingFont
                                      .copyWith(color: AppColors.primeColor),
                                ),
                                const Expanded(child: Divider()),
                              ]),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .73,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          currentProduct.products!.length,
                                      itemBuilder: (_, pIndex) {
                                        var currentInnerProduct =
                                            currentProduct.products![pIndex];
                                        return ListTile(
                                          dense: false,
                                          visualDensity:
                                              const VisualDensity(vertical: 3),
                                          leading: ImageBox(
                                            '${currentInnerProduct.images![0]}',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.contain,
                                          ),
                                          title: FitText(
                                            currentInnerProduct
                                                .name!.defaultText!.text!,
                                            style: TextStyles.headingFont,
                                            align: TextAlign.start,
                                          ),
                                          subtitle: Text(
                                            '${currentInnerProduct.varient!.weight.toString()} ${CodeHelp.formatUnit(currentInnerProduct!.varient!.unit)}',
                                            style: TextStyles.body,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${CodeHelp.euro}${Helper.getFormattedNumber(currentProduct.price!.offerPrice * currentProduct.count).toString()}',
                                          style: TextStyles.headingFont,
                                        ),
                                        Card(
                                          color: AppColors.primeColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () async {
                                                  if (stateController
                                                      .isLogin.value) {
                                                    stateController.showLoader
                                                        .value = true;
                                                    var valid = false;
                                                    var msg =
                                                        'Something went wrong!';

                                                    // if (currentProduct
                                                    //             .ruleConfig !=
                                                    //         null ||
                                                    //     currentProduct
                                                    //             .constraint !=
                                                    //         null) {
                                                    //   dynamic data = await Helper
                                                    //       .checkProductValidtoAddinCart(
                                                    //           currentProduct
                                                    //               .ruleConfig,
                                                    //           currentProduct
                                                    //               .constraint,
                                                    //           currentProduct
                                                    //                   .ref!
                                                    //                   .id ??
                                                    //               '',
                                                    //           currentProduct
                                                    //                   .ref!
                                                    //                   .id ??
                                                    //               '');
                                                    //   valid = !data['error'];
                                                    //   msg = data['msg'];
                                                    // }
                                                    // if (valid) {
                                                    await cartController.addToCart(
                                                        '${currentProduct.ref!.id}',
                                                        currentProduct
                                                            .ref!.name!,
                                                        -minOrder,
                                                        currentProduct.price,
                                                        null,
                                                        currentProduct.products,
                                                        currentProduct
                                                            .ruleConfig,
                                                        currentProduct
                                                            .constraint,
                                                        null,
                                                        mutliProductName:
                                                            currentProduct
                                                                    .name ??
                                                                "");
                                                    // } else {
                                                    //   var showToast =
                                                    //       snackBarClass
                                                    //           .showToast(
                                                    //               context, msg);
                                                    // }
                                                  }
                                                  stateController
                                                      .showLoader.value = false;
                                                },
                                                icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.white,
                                                  size: FontSizes.title,
                                                ),
                                              ),
                                              Text(
                                                  cartController
                                                      .getCurrentQuantity(
                                                          '${currentProduct.ref!.id}',
                                                          '')
                                                      .toString(),
                                                  style: TextStyles.headingFont
                                                      .copyWith(
                                                          color: Colors.white)),
                                              IconButton(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () async {
                                                  if (stateController
                                                      .isLogin.value) {
                                                    stateController.showLoader
                                                        .value = true;
                                                    var valid = false;
                                                    var msg =
                                                        'Something went wrong!';

                                                    if (currentProduct
                                                                .ruleConfig !=
                                                            null ||
                                                        currentProduct
                                                                .constraint !=
                                                            null) {
                                                      dynamic data = await Helper
                                                          .checkProductValidtoAddinCart(
                                                              currentProduct
                                                                  .ruleConfig,
                                                              currentProduct
                                                                  .constraint,
                                                              currentProduct
                                                                      .ref!
                                                                      .id ??
                                                                  '',
                                                              currentProduct
                                                                      .ref!
                                                                      .id ??
                                                                  '');
                                                      valid = !data['error'];
                                                      msg = data['msg'];
                                                    }
                                                    if (valid) {
                                                      await cartController.addToCart(
                                                          '${currentProduct.ref!.id}',
                                                          currentProduct
                                                              .ref!.name!,
                                                          minOrder,
                                                          currentProduct.price,
                                                          null,
                                                          currentProduct
                                                              .products,
                                                          currentProduct
                                                              .ruleConfig,
                                                          currentProduct
                                                              .constraint,
                                                          null,
                                                          mutliProductName:
                                                              currentProduct
                                                                      .name ??
                                                                  '');
                                                    } else {
                                                      snackBarClass.showToast(
                                                          context, msg);
                                                    }
                                                  }
                                                  stateController
                                                      .showLoader.value = false;
                                                },
                                                icon: Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.white,
                                                  size: FontSizes.title,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  cartButtons(
                                      context, cartController, currentKey),
                                  MaterialButton(
                                      onPressed: () async {
                                        stateController.showLoader.value = true;
                                        stateController.showLoader.refresh();
                                        await cartController.removeProduct(
                                            currentKey, '');
                                        stateController.showLoader.value =
                                            false;
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.delete,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Remove',
                                            style: TextStyles.body.copyWith(
                                              color: Colors.grey,
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              )
                            ],
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                dense: false,
                                visualDensity: const VisualDensity(vertical: 3),
                                leading: ImageBox(
                                  currentProduct.product!.images![0],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                                title: FitText(
                                  currentProduct
                                      .product!.name!.defaultText!.text!,
                                  style: TextStyles.headingFont,
                                  align: TextAlign.start,
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      '${currentProduct.product!.varient!.weight.toString()} ${CodeHelp.formatUnit(currentProduct.product!.varient!.unit)}',
                                      style: TextStyles.body,
                                    ),
                                    Text(
                                        '/${CodeHelp.euro}${Helper.getFormattedNumber(currentProduct.price!.offerPrice!)} ',
                                        style: TextStyles.body),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${CodeHelp.euro}${Helper.getFormattedNumber(currentProduct.price!.offerPrice * currentProduct.count).toString()}',
                                      style: TextStyles.headingFont,
                                    ),
                                    Card(
                                      color: AppColors.primeColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            padding: const EdgeInsets.all(4),
                                            constraints: const BoxConstraints(),
                                            onPressed: () async {
                                              stateController.showLoader.value =
                                                  true;
                                                  stateController.showLoader.refresh();
                                              if (stateController
                                                  .isLogin.value) {
                                                cartController.addToCart(
                                                  '${currentProduct.ref!.id}',
                                                  currentProduct.ref!.name!,
                                                  -minOrder,
                                                  currentProduct.price,
                                                  currentProduct.product,
                                                  null,
                                                  currentProduct.ruleConfig,
                                                  currentProduct.constraint,
                                                  currentProduct
                                                      .product.varient,
                                                );
                                              } else {
                                                stateController
                                                    .setCurrentTab(3);

                                                snackBarClass.showToast(context,
                                                    'Please Login to preoceed');
                                              }
                                              stateController.showLoader.value =
                                                  false;
                                            },
                                            icon: Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.white,
                                              size: FontSizes.title,
                                            ),
                                          ),
                                          Text(
                                            cartController
                                                .getCurrentQuantity(
                                                    '${currentProduct.ref!.id}',
                                                    '')
                                                .toString(),
                                            style: TextStyles.headingFont
                                                .copyWith(color: Colors.white),
                                          ),
                                          IconButton(
                                            padding: const EdgeInsets.all(4),
                                            constraints: const BoxConstraints(),
                                            onPressed: () async {
                                              stateController.showLoader.value =
                                                  true;
                                              if (stateController
                                                  .isLogin.value) {
                                                var valid = false;
                                                var msg =
                                                    'Something went wrong!';

                                                if (currentProduct.ruleConfig !=
                                                        null ||
                                                    currentProduct.constraint !=
                                                        null) {
                                                  dynamic data = await Helper
                                                      .checkProductValidtoAddinCart(
                                                          currentProduct
                                                              .ruleConfig,
                                                          currentProduct
                                                              .constraint,
                                                          currentProduct
                                                                  .ref!.id ??
                                                              "",
                                                          currentProduct
                                                                  .ref!.id ??
                                                              '');
                                                  valid = !data['error'];
                                                  msg = data['msg'];
                                                }
                                                if (valid) {
                                                  cartController.addToCart(
                                                      '${currentProduct.ref!.id}',
                                                      currentProduct.ref!.name!,
                                                      minOrder,
                                                      currentProduct.price,
                                                      currentProduct.product,
                                                      null,
                                                      currentProduct.ruleConfig,
                                                      currentProduct.constraint,
                                                      currentProduct
                                                          .product.varient);
                                                } else {
                                                  snackBarClass.showToast(
                                                      context, msg);
                                                }
                                              }
                                              stateController.showLoader.value =
                                                  false;
                                            },
                                            icon: Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.white,
                                              size: FontSizes.title,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  cartButtons(
                                      context, cartController, currentKey),
                                  MaterialButton(
                                    onPressed: () async {
                                      stateController.showLoader.value = true;
                                      stateController.showLoader.refresh();
                                      await cartController.removeProduct(
                                          currentKey, '');
                                      stateController.showLoader.value = false;
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.delete,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Remove',
                                          style: TextStyles.body.copyWith(
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                  Obx(() => checkoutClicked.value &&
                          !cartController.checktOrderRefAvailable(cartController
                              .cartProducts.value[currentKey]!.ref)
                      ? recpmmondedProduct(context, cartController, currentKey)
                      : const SizedBox())
                ],
              );
            },
          )),
    );
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
    return prod.productAvailabilityStatus != null
        ? prod.productAvailabilityStatus!.recommendedProducts!.isNotEmpty
            ? Column(
                children: [
                  Text('Recommended Products', style: TextStyles.headingFont),
                  Container(
                      padding: const EdgeInsets.all(5),
                      height: 160,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ListView.builder(
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
                              }))),
                ],
              )
            : const SizedBox()
        : const SizedBox();
  }

  shippingAddress(context) {
    LocationController locationController = Get.find();
    log(locationController.addressData.toString());
    var add = locationController.addressData;
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shipping Address',
                      style: TextStyles.headingFont,
                    ),
                    MaterialButton(
                      color: Colors.white,
                      elevation: 0,
                      onPressed: (() =>
                          {Modular.to.navigate('../home/address-list')}),
                      child: Row(
                        children: [
                          Text(
                            'Edit',
                            style: TextStyles.titleFont
                                .copyWith(color: AppColors.primeColor),
                          ),
                          Icon(
                            Icons.edit,
                            color: AppColors.primeColor,
                            size: 15,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Card(
                  color: Colors.grey.shade300,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(add.value.name ?? '',
                                  style: TextStyles.bodyFontBold),
                              Text(
                                  '(${add.value.zipCode ?? ''} ${add.value.line1 ?? ''})',
                                  style: TextStyles.body.copyWith())
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
            stateController.showLoader.refresh();
            await cartController.createSaveLater(
                cartController.cartProducts[currentKey], currentKey);
            stateController.showLoader.value = false;
          },
          icon: const Icon(
            Icons.bookmark_add_outlined,
            size: 16,
            color: Colors.grey,
          ),
          label: Text(
            "Save for later",
            style: TextStyles.body.copyWith(color: Colors.grey),
          ),
        )
      ],
    );
  }

  ListView _saveLaterAndCheckoutOptions(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CouponWidget(),
                ),
                Text(
                  'Order Summary',
                  style: TextStyles.headingFont,
                ),
                cartController.calculatedPayment.value.discountAmount != null &&
                        cartController.calculatedPayment.value.discountAmount !=
                            0.00
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Coupon discount Amount',
                            style: TextStyles.body,
                          ),
                          Text(
                            '${CodeHelp.euro}${(cartController.calculatedPayment.value.discountAmount != null ? cartController.calculatedPayment.value.discountAmount : 0.0 as double).toStringAsFixed(2)}',
                            style: TextStyles.headingFont,
                          ),
                        ],
                      )
                    : const SizedBox(),
                cartController.calculatedPayment.value
                                .totalAdditionalDiscountAmount !=
                            null &&
                        cartController.calculatedPayment.value
                                .totalAdditionalDiscountAmount !=
                            0.00
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Membership Discount',
                            style: TextStyles.body,
                          ),
                          Text(
                            '${CodeHelp.euro}${(cartController.calculatedPayment.value.totalAdditionalDiscountAmount ?? 0.0 as double).toStringAsFixed(2)}',
                            style: TextStyles.headingFont,
                          ),
                        ],
                      )
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shipping Charges',
                      style: TextStyles.body,
                    ),
                    cartController.calculatedPayment.value.shippingAmount ==
                            0.00
                        ? Text(
                            'Free',
                            style: TextStyles.titleFont
                                .copyWith(color: AppColors.green),
                          )
                        : Text(
                            '${CodeHelp.euro}${Helper.getFormattedNumber((cartController.calculatedPayment.value.shippingAmount ?? 0) as double).toStringAsFixed(2)}',
                            style: TextStyles.headingFont,
                          ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tax* (Inclusive)',
                      style: TextStyles.body,
                    ),
                    Text(
                      '${CodeHelp.euro}${Helper.getFormattedNumber(cartController.calculatedPayment.value.appliedTaxAmount).toStringAsFixed(2)}',
                      style: TextStyles.headingFont,
                    ),
                  ],
                ),
                (cartController.calculatedPayment.value != null &&
                        cartController
                                .calculatedPayment.value.appliedTaxDetail !=
                            null &&
                        cartController.calculatedPayment.value.appliedTaxDetail!
                            .isNotEmpty)
                    ? Container(
                        margin: const EdgeInsets.all(2.0),
                        padding: const EdgeInsets.all(3.0),
                        // decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.grey)),
                        child: Row(
                          children: [
                            Expanded(
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
                                  return Text(
                                    currentTax.description ?? '',
                                    style: TextStyles.bodySm,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                cartController.calculatedPayment.value.totalAmount != null &&
                        cartController.calculatedPayment.value.totalAmount > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total ',
                            style: TextStyles.headingFont
                                .copyWith(color: Colors.blue),
                          ),
                          Text(
                            CodeHelp.euro +
                                (cartController.calculatedPayment.value
                                        .totalAmount as double)
                                    .toStringAsFixed(2)
                                    .toString(),
                            style: TextStyles.headingFont,
                          ),
                        ],
                      )
                    : const SizedBox(),
                cartController.calculatedPayment.value.totalSCoinsPaid !=
                            null &&
                        cartController
                                .calculatedPayment.value.totalSCoinsPaid !=
                            0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total coins',
                            style: TextStyles.body,
                          ),
                          Text(
                            (cartController.calculatedPayment.value
                                    .totalSCoinsPaid as int)
                                .toString(),
                            style: TextStyles.headingFont,
                          ),
                        ],
                      )
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        'You will be rewarded with ${cartController.calculatedPayment.value.totalSCoinsEarned} SCOINS & ${cartController.calculatedPayment.value.totalSPointsEarned} SPOINTS on this order.',
                        style: TextStyles.body,
                      ),
                    ),
                    cartController.calculatedPayment.value.totalSavedAmount !=
                                null &&
                            cartController
                                    .calculatedPayment.value.totalSavedAmount !=
                                0.00
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              'You will save ${CodeHelp.euro}${Helper.getFormattedNumber(cartController.calculatedPayment.value.totalSavedAmount as double).toStringAsFixed(2)} on this purchase',
                              style: TextStyles.body,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                cartController.calculatedPayment.value.refferalDiscountApplied!
                    ? const Text('You will received 9% Referral discout')
                    : const SizedBox()
              ],
            );
          }),
        ),
        const Divider(),
        SaveLater(),
      ],
    );
  }
}
