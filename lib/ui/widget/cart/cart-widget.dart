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
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    innerLists.clear();
    innerLists.add(SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) => ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          shippingAddress(context),
        ],
      ),
      childCount: 1,
    )));
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
    cartController.clearCheckout();
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(width: 1, color: Colors.grey))),
        child: Obx(
          () => Padding(
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
                      style: TextStyles.bodyFont,
                    ),
                    Text(
                      '${CodeHelp.euro}${(cartController.calculatedPayment.value.totalAmount != null ? cartController.calculatedPayment.value.totalAmount as double : 0).toStringAsFixed(2)}',
                      style: TextStyles.titleLargeBold,
                    ),
                  ],
                ),
                MaterialButton(
                  color: Colors.green,
                  visualDensity: VisualDensity(horizontal: 4),
                  onPressed: () async {
                    var checkoutResp = await cartController.checkout();
                    if (checkoutResp == null || checkoutResp['error']) {
                      // ignore: use_build_context_synchronously
                      snackBarClass.showToast(context,
                          checkoutResp['msg'] ?? 'Something went wrong');
                    } else {
                      if (cartController.checkoutData.value!.allAvailable ==
                          true) {
                        checkoutClicked.value = true;
                        var data = await cartController.createPayment();
                        if (data == null || data['error']) {
                          // ignore: use_build_context_synchronously
                          snackBarClass.showToast(
                              context, data['msg'] ?? 'Something went wrong');
                        } else {
                          Modular.to
                              .navigate('/home/inapp', arguments: data['data']);
                        }
                      } else {
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
                    style:
                        TextStyles.bodyFontBold.copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Obx(
        () => (cartController.cartProducts.isNotEmpty ||
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
              ),
      ),
    );
  }

  //  checkoutClicked.value &&
  //                       !cartController.checktOrderRefAvailable(cartController
  //                           .cartProductsScoins.value[currentKey]!.ref)
  //                   ? recpmmondedProduct(context, cartController, currentKey)
  //                   // ,
  //                   //
  //                   : const SizedBox()
  scoinPRoductList(context, cartController) {
    return Obx(() => ListView.builder(
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
                    visualDensity: VisualDensity(vertical: 3),
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
                      style: TextStyles.bodyFontBold,
                      align: TextAlign.start,
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                            '${cartController.cartProductsScoins.value[currentKey]!.product!.varient!.weight.toString()} ${cartController.cartProductsScoins.value[currentKey]!.product!.varient!.unit}'),
                        Text(
                            '${cartController.cartProductsScoins[currentKey]!.count!.toString()} * ${Helper.getMemberCoinValue(cartController.cartProductsScoins.value[currentKey]!.product!.varient!.price!, stateController.userType.value)} '),
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
                                                stateController
                                                    .userType.value) *
                                            cartController
                                                .cartProductsScoins[currentKey]!
                                                .count)
                                    .toString(),
                                style: TextStyles.titleLargeBold,
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
                                  if (stateController.isLogin.value) {
                                    cartController.addToCartScoins(
                                        cartController
                                            .cartProductsScoins[currentKey]
                                            .ref!
                                            .id,
                                        'SCOIN',
                                        -1,
                                        cartController
                                            .cartProductsScoins[currentKey]
                                            .price,
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
                                  size: 20,
                                ),
                              ),
                              Text(
                                  cartController
                                      .getCurrentQuantity(
                                          '${cartController.cartProductsScoins[currentKey].ref!.id}',
                                          'SCOIN')
                                      .toString(),
                                  style: TextStyles.bodyFontBold.copyWith(
                                      fontSize: 20, color: Colors.white)),
                              IconButton(
                                padding: const EdgeInsets.all(4),
                                constraints: const BoxConstraints(),
                                onPressed: () async {
                                  stateController.showLoader.value = true;
                                  if (stateController.isLogin.value) {
                                    var valid = false;
                                    var msg = 'Something went wrong!';
                                    cartController.addToCartScoins(
                                        cartController
                                            .cartProductsScoins[currentKey]
                                            .ref!
                                            .id,
                                        'SCOIN',
                                        1,
                                        cartController
                                            .cartProductsScoins[currentKey]
                                            .price,
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
                                    var showToast = snackBarClass.showToast(
                                        context, 'Please Login');
                                  }

                                  stateController.showLoader.value = false;
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.white,
                                  size: 20,
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
                        await cartController.removeProduct(currentKey, 'SCOIN');
                        stateController.showLoader.value = false;
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.grey,
                          ),
                          Text(
                            'Remove',
                            style: TextStyles.body
                                .copyWith(color: Colors.grey, fontSize: 16),
                          )
                        ],
                      ))
                ],
              ),
            );
          },
        ));
  }

  productListWidget(context, cartController) {
    return Obx(
      (() => ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: cartController.cartProducts.length,
            itemBuilder: (_, index) {
              var currentKey =
                  cartController.cartProducts.value.keys.elementAt(index);
              return Column(
                children: [
                  cartController
                          .cartProducts.value[currentKey]!.products!.isNotEmpty
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
                                  '${cartController.cartProducts.value[currentKey]!.name}',
                                  style: TextStyles.titleLarge
                                      .copyWith(color: AppColors.primeColor),
                                ),
                                const Expanded(child: Divider()),
                              ]),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .74,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: cartController.cartProducts
                                          .value[currentKey]!.products!.length,
                                      itemBuilder: (_, pIndex) {
                                        var currentProduct = cartController
                                            .cartProducts
                                            .value[currentKey]!
                                            .products![pIndex];
                                        return ListTile(
                                            dense: false,
                                            visualDensity:
                                                VisualDensity(vertical: 3),
                                            leading: ImageBox(
                                              '${currentProduct.images![0]}',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.contain,
                                            ),
                                            title: FitText(
                                              currentProduct
                                                  .name!.defaultText!.text!,
                                              style: TextStyles.bodyFontBold,
                                              align: TextAlign.start,
                                            ),
                                            subtitle: Text(
                                                '${currentProduct.varient!.weight.toString()} ${currentProduct!.varient!.unit}'));
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
                                          '${CodeHelp.euro}${Helper.getFormattedNumber(cartController.cartProducts[currentKey]!.price!.offerPrice * cartController.cartProducts[currentKey]!.count).toString()}',
                                          style: TextStyles.titleLargeBold,
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
                                                      await cartController.addToCart(
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
                                                          null,
                                                          cartController
                                                              .cartProducts
                                                              .value[
                                                                  currentKey]!
                                                              .products,
                                                          null,
                                                          cartController
                                                              .cartProducts
                                                              .value[
                                                                  currentKey]!
                                                              .constraint,
                                                          null,
                                                          mutliProductName:
                                                              cartController
                                                                      .cartProducts
                                                                      .value[
                                                                          currentKey]!
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
                                                icon: const Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              Text(
                                                  cartController
                                                      .getCurrentQuantity(
                                                          '${cartController.cartProducts[currentKey]!.ref!.id}',
                                                          '')
                                                      .toString(),
                                                  style: TextStyles.bodyFontBold
                                                      .copyWith(
                                                          fontSize: 20,
                                                          color: Colors.white)),
                                              IconButton(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () async {
                                                  stateController
                                                      .showLoader.value = true;
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
                                                      await cartController.addToCart(
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
                                                          null,
                                                          cartController
                                                              .cartProducts
                                                              .value[
                                                                  currentKey]!
                                                              .products,
                                                          null,
                                                          cartController
                                                              .cartProducts
                                                              .value[
                                                                  currentKey]!
                                                              .constraint,
                                                          null,
                                                          mutliProductName:
                                                              cartController
                                                                      .cartProducts
                                                                      .value[
                                                                          currentKey]!
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
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.white,
                                                  size: 20,
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
                                        await cartController.removeProduct(
                                            currentKey, '');
                                        stateController.showLoader.value =
                                            false;
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            'Remove',
                                            style: TextStyles.body.copyWith(
                                                color: Colors.grey,
                                                fontSize: 16),
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
                                visualDensity: VisualDensity(vertical: 3),
                                leading: ImageBox(
                                  cartController.cartProducts.value[currentKey]!
                                      .product!.images![0],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                                title: FitText(
                                  cartController.cartProducts.value[currentKey]!
                                      .product!.name!.defaultText!.text!,
                                  style: TextStyles.bodyFontBold,
                                  align: TextAlign.start,
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                        '${cartController.cartProducts.value[currentKey]!.product!.varient!.weight.toString()} ${cartController.cartProducts.value[currentKey]!.product!.varient!.unit}'),
                                    Text(
                                        '${cartController.cartProducts[currentKey]!.count!.toString()} * ${CodeHelp.euro}${cartController.cartProducts.value[currentKey]!.product!.varient!.price!.offerPrice!} '),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${CodeHelp.euro}${Helper.getFormattedNumber(cartController.cartProducts[currentKey]!.price!.offerPrice * cartController.cartProducts[currentKey]!.count).toString()}',
                                      style: TextStyles.titleLargeBold,
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
                                                  cartController
                                                      .cartProducts[currentKey]!
                                                      .product,
                                                  null,
                                                  null,
                                                  null,
                                                  cartController
                                                      .cartProducts[currentKey]!
                                                      .product
                                                      .varient,
                                                );
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
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          Text(
                                            cartController
                                                .getCurrentQuantity(
                                                    '${cartController.cartProducts[currentKey]!.ref!.id}',
                                                    '')
                                                .toString(),
                                            style: TextStyles.bodyFontBold
                                                .copyWith(
                                                    fontSize: 20,
                                                    color: Colors.white),
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
                                                      null,
                                                      cartController
                                                          .cartProducts[
                                                              currentKey]!
                                                          .product
                                                          .varient);
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
                                              color: Colors.white,
                                              size: 20,
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
                                      await cartController.removeProduct(
                                          currentKey, '');
                                      stateController.showLoader.value = false;
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Remove',
                                          style: TextStyles.body.copyWith(
                                              color: Colors.grey, fontSize: 16),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                  checkoutClicked.value &&
                          !cartController.checktOrderRefAvailable(cartController
                              .cartProducts.value[currentKey]!.ref)
                      ? recpmmondedProduct(context, cartController, currentKey)
                      : const SizedBox()
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
    return Obx(() => Padding(
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
                        style: TextStyles.titleLargeBold.copyWith(fontSize: 20),
                      ),
                      MaterialButton(
                          onPressed: (() =>
                              {Modular.to.navigate('../home/address-list')}),
                          child: Row(
                            children: [
                              Text(
                                'Edit',
                                style: TextStyles.bodyFont.copyWith(
                                    color: AppColors.primeColor, fontSize: 20),
                              ),
                              Icon(
                                Icons.edit,
                                color: AppColors.primeColor,
                                size: 20,
                              ),
                            ],
                          ))
                    ],
                  ),
                  Card(
                    color: Colors.grey.shade300,
                    elevation: 0,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(add.value.name ?? '',
                                style: TextStyles.bodyFont),
                            Row(
                              children: [
                                Text('(ZipCode: ${add.value.zipCode ?? ''})',
                                    style: TextStyles.bodyFont.copyWith()),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(add.value.line1 ?? '',
                                    style: TextStyles.bodyFont),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
            icon: const Icon(
              Icons.bookmark_add_outlined,
              size: 20,
              color: Colors.grey,
            ),
            label: Text(
              "Save for later",
              style: TextStyles.body.copyWith(color: Colors.grey, fontSize: 16),
            ))
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(
                //   child: ElevatedButton(
                //     onPressed: () async {
                //       stateController.showLoader.value = true;
                //       bool isCheckedActivate =
                //           await stateController.getUserIsActive();
                //       if (isCheckedActivate) {
                //         await cartController.checkout();
                //         checkoutClicked.value = true;
                //       } else {
                //         snackBarClass.showToast(
                //             context, 'Your profile is not active yet');
                //       }
                //       stateController.showLoader.value = false;
                //     },
                //     child: Text(
                //       'Checkout',
                //       style: TextStyles.bodyFont,
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CouponWidget(),
                ),
                Text(
                  'Order Summary',
                  style: TextStyles.bodyFontBold.copyWith(fontSize: 20),
                ),
                cartController.calculatedPayment.value.totalSCoinsPaid != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total coins',
                            style: TextStyles.bodyFont,
                          ),
                          Text(
                            (cartController.calculatedPayment.value
                                    .totalSCoinsPaid as int)
                                .toString(),
                            style: TextStyles.bodyFontBold,
                          ),
                        ],
                      )
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discount Amount',
                      style: TextStyles.bodyFont,
                    ),
                    Text(
                      '${CodeHelp.euro}${(cartController.calculatedPayment.value.discountAmount != null ? cartController.calculatedPayment.value.discountAmount : 0 as double).toStringAsFixed(2)}',
                      style: TextStyles.bodyFontBold,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tax',
                      style: TextStyles.bodyFont,
                    ),
                    Text(
                      '${CodeHelp.euro}${Helper.getFormattedNumber(cartController.calculatedPayment.value.appliedTaxAmount).toStringAsFixed(2)}',
                      style: TextStyles.bodyFontBold,
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
                // cartController.checkoutData.value != null &&
                //         cartController.checkoutData.value!.allAvailable == true
                //     ? Column(
                //         children: [
                //           Center(
                //             child: ElevatedButton(
                //               onPressed: () async {
                //                 await cartController.checkout();
                //                 checkoutClicked.value = true;
                //                 var data = await cartController.createPayment();
                //                 if (data['error']) {
                //                   // ignore: use_build_context_synchronously
                //                   snackBarClass.showToast(context, data['msg']);
                //                 } else {
                //                   Modular.to.navigate('/home/inapp',
                //                       arguments: data['data']);
                //                 }
                //               },
                //               child: Text(
                //                 'Payment',
                //                 style: TextStyles.bodyFont,
                //               ),
                //             ),
                //           ),
                //         ],
                //       )
                //     : checkoutClicked.value
                //         ? Column(
                //             children: [
                //               Center(
                //                 child: Text("Product Not Availale",
                //                     style: TextStyles.headingFontBlue),
                //               ),
                //             ],
                //           )
                //         : const SizedBox()
              ],
            );
          }),
        ),
        Divider(),
        SaveLater(),
      ],
    );
  }
}
