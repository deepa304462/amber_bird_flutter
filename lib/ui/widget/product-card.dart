import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../helpers/controller-generator.dart';
import 'add-to-cart-button.dart';
import 'like-button.dart';

class ProductCard extends StatelessWidget {
  final ProductSummary? product;
  final String? refId;
  final String? addedFrom;
  final Price? dealPrice;
  final RuleConfig? ruleConfig;
  final Constraint? constraint;

  final bool fixedHeight;
  Rx<Varient> activeVariant = Varient().obs;
  ProductCard(this.product, this.refId, this.addedFrom, this.dealPrice,
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
                  if (addedFrom == 'BRAND') {
                    Modular.to.pushNamed('../product/${product.id}');
                  } else {
                    Modular.to.pushNamed('product/${product.id}');
                  }
                },
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: ImageBox(
                      product.images == null || product.images!.length == 0
                          ? product.category!.logoId
                          : product.images![0] ?? product.category!.logoId),
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
    // var difference;
    // if (addedFrom == dealName.FLASH.name) {
    //   String expire = ruleConfig!.willExpireAt ?? '';
    //   var newDate = DateTime.now().toUtc();
    //   difference = DateTime.parse(expire).difference(newDate);
    // }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Obx(() {
          return Visibility(
            visible: checkFavVisibility(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LikeButton(
                isLiked: wishlistController.checkIfProductWishlist(product.id),
                onPressed: () async {
                  stateController.showLoader.value = true;
                  await wishlistController.addToWishlist(
                      product.id, product, null, addedFrom);
                  stateController.showLoader.value = false;
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _gridItemFooter(ProductSummary product, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.name!.defaultText!.text ?? '',
              overflow: this.fixedHeight
                  ? TextOverflow.ellipsis
                  : TextOverflow.visible,
              style: TextStyles.body),
          addedFrom == 'MULTIPRODUCT'
              ? Text(
                  '${product.defaultPurchaseCount.toString()} * ${activeVariant.value.price!.offerPrice!}',
                  style: TextStyles.bodySm)
              : const SizedBox(),
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
                          '${product.varient!.weight!.toStringAsFixed(0)}',
                          style: TextStyles.body,
                        ),
                        Text(
                          ' ${CodeHelp.formatUnit(product.varient!.unit)}',
                          style: TextStyles.body,
                        )
                      ],
                    )
                  : (product.varients!.length == 1 ||
                          addedFrom == 'TAGS_PRODUCT')
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              product.varients![0].weight!.toStringAsFixed(0),
                              style: TextStyles.body,
                            ),
                            Text(
                              ' ${CodeHelp.formatUnit(product.varients![0].unit)}',
                              style: TextStyles.body,
                            )
                          ],
                        )
                      : const SizedBox(),
              checkPriceVisibility()
                  ? (addedFrom == 'PRODUCT' ||
                          addedFrom == 'CATEGORY' ||
                          addedFrom == 'BRAND' ||
                          addedFrom == 'TAGS_PRODUCT')
                      ? Obx(() => Text(
                            "${CodeHelp.euro}${activeVariant.value.price!.actualPrice!.toString()}",
                            style: TextStyles.headingFont,
                          ))
                      : PriceTag(dealPrice!.offerPrice!.toString(),
                          dealPrice!.actualPrice!.toString())
                  : const SizedBox(),
            ],
          ),
          (addedFrom == 'TAGS_PRODUCT')
              ? const SizedBox()
              : (product.varients!.length > 1
                  ? productVarientView(product.varients!)
                  : const SizedBox())
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    activeVariant.value = product!.varient!;
    return Padding(
      padding: const EdgeInsetsDirectional.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          fit: StackFit.loose,
          children: [
            _gridItemBody(product!, context),
            _gridItemHeader(product!),
            Obx(() {
              return Visibility(
                visible: checkBuyProductVisibility(),
                child: Positioned(
                  right: fixedHeight ? 15 : 50,
                  top: 80,
                  child: AnimatedSwitcher(
                    switchInCurve: Curves.bounceIn,
                    switchOutCurve: Curves.easeOut,
                    duration: const Duration(milliseconds: 200),
                    child: AddToCartButtons(
                      hideAdd: cartController.checkProductInCart(
                          '$refId@${activeVariant.value.varientCode}',
                          addedFrom),
                      quantity: cartController.getCurrentQuantity(
                          '$refId@${activeVariant.value.varientCode}', ''),
                      onAdd: stateController.isLogin.value
                          ? () async {
                              stateController.showLoader.value = true;
                              bool isCheckedActivate =
                                  await stateController.getUserIsActive();
                              if (isCheckedActivate) {
                                // if (stateController.isActivate.value) {
                                var valid = true;
                                var msg = 'Something went wrong!';

                                Price? price = activeVariant.value.price;
                                // this.refId, this.addedFrom,
                                if (addedFrom == 'CATEGORY') {
                                  await cartController.addToCart(
                                      '$refId@${activeVariant.value.varientCode}',
                                      addedFrom!,
                                      1,
                                      price,
                                      product,
                                      null,
                                      ruleConfig,
                                      constraint,
                                      activeVariant.value);
                                } else if (addedFrom == 'SCOIN') {
                                  cartController.addToCartScoins(
                                      '$refId@${activeVariant.value.varientCode}',
                                      addedFrom!,
                                      -1,
                                      price,
                                      product,
                                      null,
                                      ruleConfig,
                                      constraint,
                                      activeVariant.value);
                                } else {
                                  if (Get.isRegistered<DealController>(
                                      tag: addedFrom!)) {
                                    var dealController =
                                        Get.find<DealController>(
                                            tag: addedFrom!);
                                    var data = await dealController.checkValidDeal(
                                        refId!,
                                        'positive',
                                        '$refId@${activeVariant.value.varientCode}');
                                    valid = !data['error'];
                                    msg = data['msg'];
                                  }
                                  if (valid) {
                                  await  cartController.addToCart(
                                        '$refId@${activeVariant.value.varientCode}',
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
                                }
                              } else {
                                // Navigator.of(context).pop();
                                snackBarClass.showToast(
                                    context, 'Your profile is not active yet');
                              }
                              stateController.showLoader.value = false;
                            }
                          : () {
                              stateController.setCurrentTab(3);
                              snackBarClass.showToast(
                                  context, 'Please Login to preoceed');
                            },
                      onDecrease: () async {
                        stateController.showLoader.value = true;
                        Price? price = activeVariant.value.price;
                        if (stateController.isLogin.value) {
                          var valid = true;
                          var msg = 'Something went wrong!';

                          if (Get.isRegistered<DealController>(
                              tag: addedFrom!)) {
                            price = dealPrice;
                            var dealController =
                                Get.find<DealController>(tag: addedFrom!);
                            var data = await dealController.checkValidDeal(
                                refId!,
                                'negative',
                                '$refId@${activeVariant.value.varientCode}');
                            valid = !data['error'];
                            msg = data['msg'];
                          }
                          if (valid) {
                            if (addedFrom == 'SCOIN') {
                              await cartController.addToCartScoins(
                                  '$refId@${activeVariant.value.varientCode}',
                                  addedFrom!,
                                  -1,
                                  price,
                                  product,
                                  null,
                                  ruleConfig,
                                  constraint,
                                  activeVariant.value);
                            } else {
                              await cartController.addToCart(
                                  '$refId@${activeVariant.value.varientCode}',
                                  addedFrom!,
                                  -1,
                                  price,
                                  product,
                                  null,
                                  ruleConfig,
                                  constraint,
                                  activeVariant.value);
                            }
                          } else {
                            snackBarClass.showToast(context, msg);
                          }
                        } else {
                          stateController.setCurrentTab(3);
                          var showToast = snackBarClass.showToast(
                              context, 'Please Login to preoceed');
                        }
                        stateController.showLoader.value = false;
                      },
                      onIncrease: () async {
                        stateController.showLoader.value = true;
                        if (stateController.isLogin.value) {
                          var valid = true;
                          var msg = 'Something went wrong!';
                          Price? price = activeVariant.value.price;
                          if (Get.isRegistered<DealController>(
                              tag: addedFrom!)) {
                            var dealController =
                                Get.find<DealController>(tag: addedFrom!);
                            var data = await dealController.checkValidDeal(
                                refId!,
                                'positive',
                                '$refId@${activeVariant.value.varientCode}');
                            valid = !data['error'];
                            msg = data['msg'];
                            price = dealPrice;
                          }
                          if (valid) {
                            if (addedFrom == 'SCOIN') {
                              await cartController.addToCartScoins(
                                  '$refId@${activeVariant.value.varientCode}',
                                  addedFrom!,
                                  -1,
                                  price,
                                  product,
                                  null,
                                  ruleConfig,
                                  constraint,
                                  activeVariant.value);
                            } else {
                              await cartController.addToCart(
                                  '$refId@${activeVariant.value.varientCode}',
                                  addedFrom!,
                                  1,
                                  price,
                                  product,
                                  null,
                                  ruleConfig,
                                  constraint,
                                  activeVariant.value);
                            }
                          } else {
                            stateController.setCurrentTab(3);
                            snackBarClass.showToast(context, msg);
                          }
                        }
                        stateController.showLoader.value = false;
                      },
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget productVarientView(List<Varient> varientList) {
    return SizedBox(
      height: 30,
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
                child: Card(
                  color: currentVarient.varientCode ==
                          activeVariant.value.varientCode
                      ? AppColors.primeColor
                      : Colors.white,
                  margin: const EdgeInsets.all(1),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: Text(
                        '${currentVarient.weight!.toStringAsFixed(0)} ${CodeHelp.formatUnit(currentVarient.unit!)}',
                        style: TextStyles.bodyFont.copyWith(
                            color: currentVarient.varientCode !=
                                    activeVariant.value.varientCode
                                ? AppColors.primeColor
                                : Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  checkFavVisibility() {
    if (fixedHeight) {
      return false;
    }
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
