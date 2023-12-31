import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/data/price/price.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/card-color-animated.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../helpers/controller-generator.dart';
import 'add-to-cart-button.dart';

class ProductCardScoin extends StatelessWidget {
  final ProductSummary? product;
  final String? refId;
  final String? addedFrom;
  final Price? dealPrice;
  final RuleConfig? ruleConfig;
  final Constraint? constraint;

  final bool fixedHeight;
  Rx<Varient> activeVariant = Varient().obs;
  ProductCardScoin(this.product, this.refId, this.addedFrom, this.dealPrice,
      this.ruleConfig, this.constraint,
      {super.key, this.fixedHeight = false});

  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  final Controller stateController = Get.find();
  final WishlistController wishlistController = Get.find();
  Widget _gridItemBody(ProductSummary product, BuildContext context) {
    return Column(
      children: [
        product.images!.isNotEmpty
            ? InkWell(
                onTap: () {
                  Modular.to
                      .pushNamed('/widget/product', arguments: product.id);
                },
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: ImageBox(product.images![0]),
                ),
              )
            : const SizedBox(
                child: Text('Empty Image'),
              ),
        _gridItemFooter(product, context)
      ],
    );
  }

  Widget _gridItemHeader(ProductSummary product) {
    // String timeLeft = '';
    var difference;
    if (addedFrom == dealName.FLASH.name) {
      String expire = ruleConfig!.willExpireAt ?? '';
      var newDate = DateTime.now().toUtc();
      difference = DateTime.parse(expire).difference(newDate);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        addedFrom == dealName.FLASH.name
            ? CardColorAnimated(
                Padding(
                  padding: const EdgeInsets.only(
                      right: 5, top: 1, bottom: 1, left: 2),
                  child: Text(
                    difference.inHours != null
                        ? '${difference.inHours}H left'
                        : '${difference.inMinutes}M left',
                    style:
                        TextStyles.bodyFontBold.copyWith(color: Colors.white),
                  ),
                ),
                Colors.red,
                Colors.indigo,
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              )
            : const SizedBox(),
        // Obx(() {
        //   return Visibility(
        //     visible: checkFavVisibility(),
        //     child: IconButton(
        //       icon: Icon(
        //         Icons.favorite,
        //         color: wishlistController.checkIfProductWishlist(product.id)
        //             ? AppColors.primeColor
        //             : const Color(0xFFA6A3A0),
        //       ),
        //       onPressed: () async {
        //         stateController.showLoader.value = true;
        //         await wishlistController.addToWishlist(
        //             product.id, product, null, addedFrom);
        //         stateController.showLoader.value = false;
        //       },
        //     ),
        //   );
        // }),
      ],
    );
  }

  Widget _gridItemFooter(ProductSummary product, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name!.defaultText!.text ?? '',
            overflow:
                this.fixedHeight ? TextOverflow.ellipsis : TextOverflow.visible,
            style: TextStyles.body,
          ),
          Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            children: [
              product.varients!.length == 0
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          product.varient!.weight!.toStringAsFixed(0),
                          style: TextStyles.body,
                        ),
                        Text(
                          '${CodeHelp.formatUnit(product.varient!.unit)}',
                          style: TextStyles.body,
                        )
                      ],
                    )
                  : product.varients!.length == 1
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              product.varient!.weight!.toStringAsFixed(0),
                              style: TextStyles.body,
                            ),
                            Text(
                              ' ${CodeHelp.formatUnit(product.varient!.unit)}',
                              style: TextStyles.body,
                            )
                          ],
                        )
                      : const SizedBox(),
              checkPriceVisibility()
                  ? PriceTag(
                      dealPrice!.offerPrice!.toString(),
                      dealPrice!.actualPrice!.toString(),
                      scoin: Helper.getMemberCoinValue(
                          dealPrice!, stateController.userType.value),
                    )
                  : const SizedBox(),
            ],
          ),
          product.varients!.length > 1
              ? productVarientView(product.varients!)
              : const SizedBox()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    activeVariant.value = product!.varient!;
    return Padding(
      padding: const EdgeInsetsDirectional.all(5),
      child: Container(
        color: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Stack(
            fit: StackFit.loose,
            children: [
              _gridItemBody(product!, context),
              _gridItemHeader(product!),
              Obx(
                () {
                  return Visibility(
                    visible: checkBuyProductVisibility(),
                    child: Positioned(
                      right: 5,
                      top: 65,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: AddToCartButtons(
                          hideAdd: cartController.checkProductInCart(
                              '$refId@${activeVariant.value.varientCode}',
                              addedFrom),
                          onDecrease: () async {
                            stateController.showLoader.value = true;
                            if (stateController.isLogin.value) {
                              var valid = false;
                              var msg = 'Something went wrong!';
                              var data = await Helper.checkValidScoin(
                                  dealPrice!,
                                  stateController.userType.value,
                                  cartController.cartProductsScoins,
                                  stateController.customerDetail.value
                                      .coinWalletDetail!.totalActiveCoins,
                                  cartController.getCurrentQuantity(
                                      '$refId@${activeVariant.value.varientCode}',
                                      'SCOIN'));
                              valid = !data['error'];
                              msg = data['msg'];
                              if (valid) {
                                cartController.addToCartScoins(
                                    '$refId@${product!.varient!.varientCode}',
                                    addedFrom!,
                                    -1,
                                    dealPrice,
                                    product,
                                    null,
                                    ruleConfig,
                                    constraint,
                                    activeVariant.value);
                              } else {
                                snackBarClass.showToast(context, msg);
                              }
                            } else {
                              stateController.setCurrentTab(3);
                              snackBarClass.showToast(
                                  context, 'Please Login to proceed!!');
                            }
                            stateController.showLoader.value = false;
                          },
                          quantity: cartController.getCurrentQuantity(
                              '$refId@${activeVariant.value.varientCode}',
                              'SCOIN'),
                          onIncrease: () async {
                            stateController.showLoader.value = true;
                            var valid = false;
                            var msg = 'Something went wrong!';
                            if (stateController.isLogin.value) {
                              var data = await Helper.checkValidScoin(
                                  dealPrice!,
                                  stateController.userType.value,
                                  cartController.cartProductsScoins,
                                  stateController.customerDetail.value
                                      .coinWalletDetail!.totalActiveCoins,
                                  cartController.getCurrentQuantity(
                                      '$refId@${activeVariant.value.varientCode}',
                                      'SCOIN'));
                              valid = !data['error'];
                              msg = data['msg'];
                              if (valid) {
                                cartController.addToCartScoins(
                                    '$refId@${product!.varient!.varientCode}',
                                    addedFrom!,
                                    1,
                                    dealPrice,
                                    product,
                                    null,
                                    ruleConfig,
                                    constraint,
                                    product!.varient!);
                              } else {
                                snackBarClass.showToast(context, msg);
                              }
                            } else {
                              stateController.setCurrentTab(4);
                              snackBarClass.showToast(context, 'Please login');
                            }
                            stateController.showLoader.value = false;
                          },
                          onAdd: stateController.isLogin.value
                              ? () async {
                                  stateController.showLoader.value = true;
                                  bool isCheckedActivate =
                                      await stateController.getUserIsActive();
                                  if (isCheckedActivate) {
                                    // if (stateController.isActivate.value) {
                                    var valid = false;
                                    var msg = 'Something went wrong!';

                                    // this.refId, this.addedFrom,
                                    if (addedFrom == 'CATEGORY') {
                                      await cartController.addToCart(
                                          '$refId@${product!.varient!.varientCode}',
                                          addedFrom!,
                                          1,
                                          dealPrice,
                                          product,
                                          null,
                                          ruleConfig,
                                          constraint,
                                          activeVariant.value);
                                    } else if (addedFrom == 'SCOIN') {
                                      var data = await Helper.checkValidScoin(
                                          dealPrice!,
                                          stateController.userType.value,
                                          cartController.cartProductsScoins,
                                          stateController
                                              .customerDetail
                                              .value
                                              .coinWalletDetail!
                                              .totalActiveCoins,
                                          cartController.getCurrentQuantity(
                                              '$refId@${activeVariant.value.varientCode}',
                                              'SCOIN'));
                                      valid = !data['error'];
                                      msg = data['msg'];
                                      if (valid) {
                                        cartController.addToCartScoins(
                                            '$refId@${product!.varient!.varientCode}',
                                            addedFrom!,
                                            1,
                                            dealPrice,
                                            product,
                                            null,
                                            ruleConfig,
                                            constraint,
                                            activeVariant.value);
                                      } else {
                                        snackBarClass.showToast(context, msg);
                                      }
                                    } else {
                                      if (Get.isRegistered<DealController>(
                                          tag: addedFrom!)) {
                                        var dealController =
                                            Get.find<DealController>(
                                                tag: addedFrom!);
                                        var data =
                                            await dealController.checkValidDeal(
                                                refId!,
                                                'positive',
                                                '$refId@${activeVariant.value.varientCode}');
                                        valid = !data['error'];
                                        msg = data['msg'];
                                      }
                                      if (valid) {
                                        await cartController.addToCart(
                                            '$refId@${activeVariant.value.varientCode}',
                                            addedFrom!,
                                            1,
                                            dealPrice,
                                            product,
                                            null,
                                            ruleConfig,
                                            constraint,
                                            activeVariant.value);
                                      } else if (addedFrom == 'SCOIN') {
                                        var data = await Helper.checkValidScoin(
                                            dealPrice!,
                                            stateController.userType.value,
                                            cartController.cartProductsScoins,
                                            stateController
                                                .customerDetail
                                                .value
                                                .coinWalletDetail!
                                                .totalActiveCoins,
                                            cartController.getCurrentQuantity(
                                                '$refId@${activeVariant.value.varientCode}',
                                                'SCOIN'));
                                        valid = !data['error'];
                                        msg = data['msg'];
                                        if (valid) {
                                          cartController.addToCartScoins(
                                              '$refId@${product!.varient!.varientCode}',
                                              addedFrom!,
                                              1,
                                              dealPrice,
                                              product,
                                              null,
                                              ruleConfig,
                                              constraint,
                                              product!.varient!);
                                        } else {
                                          snackBarClass.showToast(context, msg);
                                        }
                                      } else {
                                        snackBarClass.showToast(context, msg);
                                      }
                                    }
                                  } else {
                                    snackBarClass.showToast(
                                        context, 'Your profile is Inactive!!');
                                  }
                                  stateController.showLoader.value = false;
                                }
                              : () {
                                  stateController.setCurrentTab(3);
                                  snackBarClass.showToast(
                                      context, 'Please Login to proceed!!');
                                },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productVarientView(List<Varient> varientList) {
    activeVariant.value = varientList[0];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: varientList.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          var currentVarient = varientList[index];
          return Obx(
            () => InkWell(
              onTap: () {
                activeVariant.value = currentVarient;
                // productController.setVarient(currentVarient);
              },
              child: SizedBox(
                height: 50,
                child: Card(
                  color: currentVarient.varientCode ==
                          activeVariant.value.varientCode
                      ? AppColors.primeColor
                      : Colors.white,
                  margin: const EdgeInsets.all(5),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${currentVarient.weight!} ${CodeHelp.formatUnit(currentVarient.unit!)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: currentVarient.varientCode !=
                                    activeVariant.value.varientCode
                                ? AppColors.primeColor
                                : Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  checkFavVisibility() {
    if (addedFrom == 'MULTIPRODUCT') {
      return false;
    }
    return true;
  }

  checkBuyProductVisibility() {
    if (addedFrom == 'MULTIPRODUCT') {
      return false;
    }
    return true;
  }

  checkPriceVisibility() {
    if (addedFrom == 'MULTIPRODUCT') {
      return false;
    }
    return true;
  }

  checkDealTimeoutVisibility() {
    if (addedFrom == 'MULTIPRODUCT') {
      return false;
    }
    return true;
  }
}
