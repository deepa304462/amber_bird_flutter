import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/location-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/cart/save-later-widget.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/loading-with-logo.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../../helpers/controller-generator.dart';

class CartWidget extends StatelessWidget {
  late CartController cartController;
  final Controller stateController = Get.find();
  RxBool checkoutClicked = false.obs;
  RxBool isLoading = false.obs;
  TextEditingController ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    cartController =
        ControllerGenerator.create(CartController(), tag: 'cartController');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        leadingWidth: 50,
        backgroundColor: AppColors.primeColor,
        leading: MaterialButton(
          onPressed: () {
            stateController.navigateToUrl('/home/main');
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 15,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Cart',
              style: TextStyles.bodyFont.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Obx(
          () => (cartController.cartProducts.isNotEmpty ||
                      cartController.cartProductsScoins.isNotEmpty ||
                      cartController.msdProducts.isNotEmpty) &&
                  cartController.calculatedPayment.value.totalAmount != null &&
                  cartController.calculatedPayment.value.totalAmount as double >
                      0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: MaterialButton(
                      color: AppColors.green,
                      onPressed: () async {
                        checkoutClicked.value = true;
                        if (!isLoading.value) {
                          isLoading.value = true;
                          var data = await cartController.checkoutCart();
                          isLoading.value = false;
                          if (data['error']) {
                            snackBarClass.showToast(context, data['msg']);
                          } else {
                            Modular.to.pushNamed('/widget/pre-checkout');
                          }
                        }
                      },
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        isLoading.value ? 'Loading' : 'Checkout',
                        style: TextStyles.bodyFont
                            .copyWith(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ),
      body: Stack(children: [
        IgnorePointer(
          ignoring: isLoading.value,
          child: Obx(
            () {
              cartController.innerLists.clear();
              cartController.innerLists.add(
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Groceries',
                                style: TextStyles.bodyFont
                                    .copyWith(color: AppColors.primeColor),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total: ',
                                        style: TextStyles.bodyFont,
                                      ),
                                      Obx(
                                        () => Text(
                                          '${(cartController.calculatedPayment.value.totalAmount != null ? cartController.calculatedPayment.value.totalAmount as double : 0).toStringAsFixed(2)}${CodeHelp.euro}',
                                          style: TextStyles.headingFont
                                              .copyWith(color: AppColors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Shipping Fee: ',
                                        style: TextStyles.bodyFont,
                                      ),
                                      Obx(
                                        () => cartController.calculatedPayment
                                                    .value.shippingAmount ==
                                                0.00
                                            ? Text(
                                                'Free',
                                                style: TextStyles.bodyFont
                                                    .copyWith(
                                                        color: AppColors.green),
                                              )
                                            : Text(
                                                '${Helper.formatNumberTwodigit(Helper.getFormattedNumber((cartController.calculatedPayment.value.shippingAmount ?? 0.00)).toString())}${CodeHelp.euro}',
                                                style: TextStyles.headingFont
                                                    .copyWith(
                                                        color: AppColors.green),
                                              ),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          Divider()
                        ],
                      ),
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
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () =>
                  isLoading.value ? const LoadingWithLogo() : const SizedBox(),
            ),
          ),
        )
      ]),
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
              var currentMemberPrice = Helper.getMsdAmount(
                  price: currentProduct.price!,
                  userType: stateController.userType.value);
              return Container(
                color: (checkoutClicked.value &&
                        !cartController.checktOrderRefAvailable(
                            cartController.msdProducts.value[currentKey]!.ref))
                    ? AppColors.primeColor
                    : AppColors.white,
                child: Column(
                  children: [
                    currentProduct.products!.isNotEmpty
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Row(children: <Widget>[
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .1,
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
                                      width: MediaQuery.of(context).size.width *
                                          .73,
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
                                            visualDensity: const VisualDensity(
                                                vertical: 3),
                                            leading: InkWell(
                                              onTap: () {
                                                Modular.to.pushNamed(
                                                    '/widget/product/${currentInnerProduct.id}');
                                              },
                                              child: ImageBox(
                                                '${currentInnerProduct.images![0]}',
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.contain,
                                              ),
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
                                          ImageBox(
                                            stateController
                                                .membershipIcon.value,
                                            height: 20,
                                            width: 20,
                                            fit: BoxFit.contain,
                                          ),
                                          Text(
                                            '${Helper.formatNumberTwodigit(Helper.getFormattedNumber(currentMemberPrice * currentProduct.count))}${CodeHelp.euro}',
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
                                                    isLoading.value = true;
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
                                                        await cartController.addToCartMSD(
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
                                                                    "",
                                                            imageId:
                                                                currentProduct
                                                                    .imageId);
                                                      } else {
                                                        snackBarClass.showToast(
                                                            context, msg);
                                                      }
                                                    }
                                                    isLoading.value = false;
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
                                                    style: TextStyles
                                                        .headingFont
                                                        .copyWith(
                                                            color:
                                                                Colors.white)),
                                                IconButton(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  constraints:
                                                      const BoxConstraints(),
                                                  onPressed: () async {
                                                    isLoading.value = true;
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
                                                        await cartController.addToCartMSD(
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
                                                                    '',
                                                            imageId:
                                                                currentProduct
                                                                    .imageId);
                                                      } else {
                                                        snackBarClass.showToast(
                                                            context, msg);
                                                      }
                                                    }
                                                    isLoading.value = false;
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
                                          isLoading.value = true;
                                          await cartController.removeProduct(
                                              currentKey, 'MSD');
                                          isLoading.value = false;
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
                                  visualDensity:
                                      const VisualDensity(vertical: 3),
                                  leading: InkWell(
                                    onTap: () {
                                      Modular.to.pushNamed(
                                          '/widget/product/${currentProduct.product!.id}');
                                    },
                                    child: ImageBox(
                                      currentProduct.product!.images![0],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.contain,
                                    ),
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
                                        '${currentProduct.product!.varient!.weight.toString()} ${CodeHelp.formatUnit(currentProduct.product!.varient!.unit)}/ ',
                                        style: TextStyles.body,
                                      ),
                                      ImageBox(
                                        stateController.membershipIcon.value,
                                        height: 20,
                                        width: 20,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                          '${Helper.formatNumberTwodigit(Helper.getFormattedNumber(currentMemberPrice)).toString()}${CodeHelp.euro} ',
                                          style: TextStyles.body),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        child: Row(
                                          children: [
                                            ImageBox(
                                              stateController
                                                  .membershipIcon.value,
                                              height: 20,
                                              width: 20,
                                              fit: BoxFit.contain,
                                            ),
                                            Text(
                                              '${Helper.formatNumberTwodigit(Helper.getFormattedNumber(currentMemberPrice * currentProduct.count)).toString()}${CodeHelp.euro}',
                                              style: TextStyles.headingFont,
                                            ),
                                          ],
                                        ),
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
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: () async {
                                                isLoading.value = true;
                                                if (stateController
                                                    .isLogin.value) {
                                                  await cartController
                                                      .addToCartMSD(
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

                                                  snackBarClass.showToast(
                                                      context,
                                                      'Please Login to proceed!!');
                                                }
                                                isLoading.value = false;
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
                                                      color: Colors.white),
                                            ),
                                            IconButton(
                                              padding: const EdgeInsets.all(4),
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: () async {
                                                isLoading.value = true;
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
                                                                    .ref!.id ??
                                                                "",
                                                            currentProduct
                                                                    .ref!.id ??
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
                                                            currentProduct
                                                                .product,
                                                            null,
                                                            currentProduct
                                                                .ruleConfig,
                                                            currentProduct
                                                                .constraint,
                                                            currentProduct
                                                                .product
                                                                .varient);
                                                  } else {
                                                    snackBarClass.showToast(
                                                        context, msg);
                                                  }
                                                }
                                                isLoading.value = false;
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
                                        isLoading.value = true;
                                        await cartController.removeProduct(
                                            currentKey, 'MSD');
                                        isLoading.value = false;
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
                            cartController.cartProducts.value[currentKey] !=
                                null &&
                            !cartController.checktOrderRefAvailable(
                                cartController
                                    .cartProducts.value[currentKey]!.ref) &&
                            !isLoading.value
                        ? recpmmondedProduct(
                            context, cartController, currentKey)
                        : const SizedBox())
                  ],
                ),
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
          return Container(
            width: MediaQuery.of(context).size.width,
            color: (checkoutClicked.value &&
                    !cartController.checktOrderRefAvailable(cartController
                        .cartProductsScoins.value[currentKey]!.ref))
                ? AppColors.primeColor
                : AppColors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: false,
                  visualDensity: const VisualDensity(vertical: 3),
                  leading: InkWell(
                    onTap: () {
                      Modular.to.pushNamed(
                          '/widget/product/${cartController.cartProductsScoins.value[currentKey]!.product!.product!.id}');
                    },
                    child: ImageBox(
                      cartController.cartProductsScoins.value[currentKey]!
                          .product!.images![0],
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
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
                            PriceTag(
                              cartController.cartProductsScoins[currentKey]!
                                  .price!.offerPrice!
                                  .toString(),
                              cartController.cartProductsScoins[currentKey]!
                                  .price!.actualPrice!
                                  .toString(),
                              scoin: int.parse(Helper.getFormattedNumber(
                                  Helper.getMemberCoinValue(
                                          cartController
                                              .cartProductsScoins[currentKey]!
                                              .price!,
                                          stateController.userType.value) *
                                      cartController
                                          .cartProductsScoins[currentKey]!
                                          .count)),
                            )
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
                                isLoading.value = true;
                                if (stateController.isLogin.value) {
                                  await cartController.addToCartScoins(
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
                                  snackBarClass.showToast(
                                      context, 'Please Login to proceed!!');
                                }
                                isLoading.value = false;
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
                                isLoading.value = true;
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

                                isLoading.value = false;
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
                    isLoading.value = true;
                    await cartController.removeProduct(currentKey, 'SCOIN');
                    isLoading.value = false;
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
                      currentProduct.constraint.minimumOrder != null &&
                      currentProduct.constraint.minimumOrder > 0)
                  ? currentProduct.constraint!.minimumOrder
                  : 1;
              return Obx(() => Column(
                    children: [
                      currentProduct.products!.isNotEmpty
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Row(children: <Widget>[
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .1,
                                        child: const Divider()),
                                    FitText(
                                      '${currentProduct.name}',
                                      style: TextStyles.headingFont.copyWith(
                                          color: AppColors.primeColor),
                                    ),
                                    const Expanded(child: Divider()),
                                  ]),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .73,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              currentProduct.products!.length,
                                          itemBuilder: (_, pIndex) {
                                            var currentInnerProduct =
                                                currentProduct
                                                    .products![pIndex];
                                            return ListTile(
                                              dense: false,
                                              visualDensity:
                                                  const VisualDensity(
                                                      vertical: 3),
                                              leading: InkWell(
                                                onTap: () {
                                                  Modular.to.pushNamed(
                                                      '/widget/product/${currentInnerProduct.id}');
                                                },
                                                child: ImageBox(
                                                  '${currentInnerProduct.images![0]}',
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.contain,
                                                ),
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
                                              '${Helper.formatNumberTwodigit(Helper.getFormattedNumber(currentProduct.price!.offerPrice * currentProduct.count)).toString()}${CodeHelp.euro}',
                                              style: TextStyles.headingFont,
                                            ),
                                            Card(
                                              color: AppColors.primeColor,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
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
                                                        isLoading.value = true;

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
                                                                    "",
                                                            imageId:
                                                                currentProduct
                                                                    .imageId);
                                                        // } else {
                                                        //   var showToast =
                                                        //       snackBarClass
                                                        //           .showToast(
                                                        //               context, msg);
                                                        // }
                                                      }
                                                      isLoading.value = false;
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .remove_circle_outline,
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
                                                      style: TextStyles
                                                          .headingFont
                                                          .copyWith(
                                                              color: Colors
                                                                  .white)),
                                                  IconButton(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    constraints:
                                                        const BoxConstraints(),
                                                    onPressed: () async {
                                                      if (stateController
                                                          .isLogin.value) {
                                                        isLoading.value = true;
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
                                                          valid =
                                                              !data['error'];
                                                          msg = data['msg'];
                                                        }
                                                        if (valid) {
                                                          await cartController.addToCart(
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
                                                                      '',
                                                              imageId:
                                                                  currentProduct
                                                                      .imageId);
                                                        } else {
                                                          snackBarClass
                                                              .showToast(
                                                                  context, msg);
                                                        }
                                                      }
                                                      isLoading.value = false;
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
                                            isLoading.value = true;
                                            await cartController.removeProduct(
                                                currentKey, '');
                                            isLoading.value = false;
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
                                    visualDensity:
                                        const VisualDensity(vertical: 3),
                                    leading: InkWell(
                                      onTap: () {
                                        Modular.to.pushNamed(
                                            '/widget/product/${currentProduct.product.id}');
                                      },
                                      child: ImageBox(
                                        currentProduct.product!.images![0],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      ),
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
                                            '/${Helper.formatNumberTwodigit(Helper.getFormattedNumber(currentProduct.price!.offerPrice!)).toString()}${CodeHelp.euro} ',
                                            style: TextStyles.body),
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${Helper.formatNumberTwodigit(Helper.getFormattedNumber(currentProduct.price!.offerPrice * currentProduct.count)).toString()}${CodeHelp.euro}',
                                          style: TextStyles.headingFont,
                                        ),
                                        Card(
                                          color: (checkoutClicked.value &&
                                                  !cartController
                                                      .checktOrderRefAvailable(
                                                          currentProduct!.ref))
                                              ? AppColors.grey
                                              : AppColors.primeColor,
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
                                                  isLoading.value = true;
                                                  if (stateController
                                                      .isLogin.value) {
                                                    await cartController
                                                        .addToCart(
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

                                                    snackBarClass.showToast(
                                                        context,
                                                        'Please Login to proceed!!');
                                                  }
                                                  isLoading.value = false;
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
                                                        color: Colors.white),
                                              ),
                                              IconButton(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () async {
                                                  isLoading.value = true;
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
                                                                  "",
                                                              currentProduct
                                                                      .ref!
                                                                      .id ??
                                                                  '');
                                                      valid = !data['error'];
                                                      msg = data['msg'];
                                                    }
                                                    if (valid) {
                                                      await cartController
                                                          .addToCart(
                                                              '${currentProduct.ref!.id}',
                                                              currentProduct
                                                                  .ref!.name!,
                                                              minOrder,
                                                              currentProduct
                                                                  .price,
                                                              currentProduct
                                                                  .product,
                                                              null,
                                                              currentProduct
                                                                  .ruleConfig,
                                                              currentProduct
                                                                  .constraint,
                                                              currentProduct
                                                                  .product
                                                                  .varient);
                                                    } else {
                                                      snackBarClass.showToast(
                                                          context, msg);
                                                    }
                                                  }
                                                  isLoading.value = false;
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
                                          isLoading.value = true;
                                          await cartController.removeProduct(
                                              currentKey, '');
                                          isLoading.value = false;
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
                      checkoutClicked.value &&
                              !cartController.checktOrderRefAvailable(
                                  cartController
                                      .cartProducts.value[currentKey]!.ref)
                          ? recpmmondedProduct(
                              context, cartController, currentKey)
                          : const SizedBox()
                    ],
                  ));
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
            ? Container(
                padding: EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                    // color: AppColors.grey,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.primeColor)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recommended Products', style: TextStyles.headingFont),
                    SizedBox(
                      height: 190,
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
                        },
                      ),
                    ),
                  ],
                ))
            : const SizedBox()
        : const SizedBox();
  }

  shippingAddress(context) {
    LocationController locationController = Get.find();
    // log(locationController.addressData.toString());
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
                          {Modular.to.navigate('../widget/address-list')}),
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
            isLoading.value = true;
            await cartController.createSaveLater(
                cartController.cartProducts[currentKey], currentKey);
            isLoading.value = false;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 5),
              //   child: CouponWidget(),
              // ),
              // Text(
              //   'Order Summary',
              //   style: TextStyles.headingFont,
              // ),
              // cartController.calculatedPayment.value.discountAmount != null &&
              //         cartController.calculatedPayment.value.discountAmount !=
              //             0.00
              //     ? Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Coupon discount Amount',
              //             style: TextStyles.body,
              //           ),
              //           Text(
              //             '${(cartController.calculatedPayment.value.discountAmount != null ? cartController.calculatedPayment.value.discountAmount : 0.0 as double).toStringAsFixed(2)}${CodeHelp.euro}',
              //             style: TextStyles.headingFont,
              //           ),
              //         ],
              //       )
              //     : const SizedBox(),
              // cartController.calculatedPayment.value
              //                 .totalAdditionalDiscountAmount !=
              //             null &&
              //         cartController.calculatedPayment.value
              //                 .totalAdditionalDiscountAmount !=
              //             0.00
              //     ? Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Membership Discount',
              //             style: TextStyles.body,
              //           ),
              //           Text(
              //             '${(cartController.calculatedPayment.value.totalAdditionalDiscountAmount ?? 0.0).toStringAsFixed(2)}${CodeHelp.euro}',
              //             style: TextStyles.headingFont,
              //           ),
              //         ],
              //       )
              //     : const SizedBox(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Shipping Charges',
              //       style: TextStyles.body,
              //     ),
              //     cartController.calculatedPayment.value.shippingAmount ==
              //             0.00
              //         ? Text(
              //             'Free',
              //             style: TextStyles.titleFont
              //                 .copyWith(color: AppColors.green),
              //           )
              //         : Text(
              //             '${Helper.getFormattedNumber((cartController.calculatedPayment.value.shippingAmount ?? 0)).toStringAsFixed(2)}${CodeHelp.euro}',
              //             style: TextStyles.headingFont,
              //           ),
              //   ],
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Tax* (Inclusive)',
              //       style: TextStyles.body,
              //     ),
              //     Text(
              //       '${Helper.getFormattedNumber(cartController.calculatedPayment.value.appliedTaxAmount).toStringAsFixed(2)}${CodeHelp.euro}',
              //       style: TextStyles.headingFont,
              //     ),
              //   ],
              // ),
              // (cartController.calculatedPayment.value != null &&
              //         cartController
              //                 .calculatedPayment.value.appliedTaxDetail !=
              //             null &&
              //         cartController.calculatedPayment.value.appliedTaxDetail!
              //             .isNotEmpty)
              //     ? Container(
              //         margin: const EdgeInsets.all(2.0),
              //         padding: const EdgeInsets.all(3.0),
              //         // decoration: BoxDecoration(
              //         //     border: Border.all(color: Colors.grey)),
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: ListView.builder(
              //                 shrinkWrap: true,
              //                 scrollDirection: Axis.vertical,
              //                 itemCount: cartController.calculatedPayment
              //                     .value.appliedTaxDetail!.length,
              //                 itemBuilder: (_, pIndex) {
              //                   var currentTax = cartController
              //                       .calculatedPayment
              //                       .value
              //                       .appliedTaxDetail![pIndex];
              //                   return Text(
              //                     currentTax.description ?? '',
              //                     style: TextStyles.bodySm,
              //                   );
              //                 },
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     : const SizedBox(),
              // cartController.calculatedPayment.value.totalAmount != null &&
              //         cartController.calculatedPayment.value.totalAmount > 0
              //     ? Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Total ',
              //             style: TextStyles.headingFont
              //                 .copyWith(color: Colors.blue),
              //           ),
              //           Text(
              //             CodeHelp.euro +
              //                 (cartController.calculatedPayment.value
              //                         .totalAmount as double)
              //                     .toStringAsFixed(2)
              //                     .toString(),
              //             style: TextStyles.headingFont,
              //           ),
              //         ],
              //       )
              //     : const SizedBox(),
              // cartController.calculatedPayment.value.totalSCoinsPaid !=
              //             null &&
              //         cartController
              //                 .calculatedPayment.value.totalSCoinsPaid !=
              //             0
              //     ? Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'Total coins',
              //             style: TextStyles.body,
              //           ),
              //           Text(
              //             (cartController.calculatedPayment.value
              //                     .totalSCoinsPaid as int)
              //                 .toString(),
              //             style: TextStyles.headingFont,
              //           ),
              //         ],
              //       )
              //     : const SizedBox(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     SizedBox(
              //       width: MediaQuery.of(context).size.width * 0.9,
              //       child: Text(
              //         'You will be rewarded with ${cartController.calculatedPayment.value.totalSCoinsEarned} SCOINS & ${cartController.calculatedPayment.value.totalSPointsEarned} SPOINTS on this order.',
              //         style: TextStyles.body,
              //       ),
              //     ),
              //     cartController.calculatedPayment.value.totalSavedAmount !=
              //                 null &&
              //             cartController
              //                     .calculatedPayment.value.totalSavedAmount !=
              //                 0.00
              //         ? SizedBox(
              //             width: MediaQuery.of(context).size.width * 0.9,
              //             child: Text(
              //               'You will save ${CodeHelp.euro}${Helper.getFormattedNumber(cartController.calculatedPayment.value.totalSavedAmount as double).toStringAsFixed(2)} on this purchase',
              //               style: TextStyles.body,
              //             ),
              //           )
              //         : const SizedBox(),
              //   ],
              // ),
              // (cartController.calculatedPayment.value
              //                 .refferalDiscountApplied !=
              //             null &&
              //         cartController
              //             .calculatedPayment.value.refferalDiscountApplied!)
              //     ? const Text('You will received 9% Referral discout')
              //     : const SizedBox()
            ],
          ),
        ),
        const Divider(),
        SaveLater(),
      ],
    );
  }
}
