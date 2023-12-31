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
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

import '../../helpers/controller-generator.dart';
import 'add-to-cart-button.dart';
import 'discount-tag.dart';
import 'like-button.dart';

class ProductCard extends StatelessWidget {
  final ProductSummary? product;
  final String? refId;
  final String? addedFrom;
  final Price? dealPrice;
  final RuleConfig? ruleConfig;
  final Constraint? constraint;
  final String? CurrentKey;
  final bool fixedHeight;
  Rx<Varient> activeVariant = Varient().obs;
  ProductCard(this.product, this.refId, this.addedFrom, this.dealPrice,
      this.ruleConfig, this.constraint,
      {super.key, this.fixedHeight = false, this.CurrentKey});

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
                  Modular.to.pushNamed(
                    '/widget/product',
                    arguments: product.id,
                  );
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

  Widget _gridItemHeader(ProductSummary product, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Obx(() {
          return Visibility(
            visible: checkFavVisibility(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: LikeButton(
                isLiked: wishlistController.checkIfProductWishlist(
                    '${product.id}@${product.varient!.varientCode}'),
                onPressed: () async {
                  stateController.showLoader.value = true;

                  if (stateController.isLogin.value) {
                    await wishlistController.addToWishlist(
                        '${product.id}@${product.varient!.varientCode}',
                        product,
                        null,
                        addedFrom);
                  } else {
                    stateController.setCurrentTab(3);
                    snackBarClass.showToast(
                        context, 'Please Login to proceed!!');
                  }
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
          Text('${product.name!.defaultText!.text ?? ''} ',
              overflow: this.fixedHeight
                  ? TextOverflow.ellipsis
                  : TextOverflow.visible,
              style: TextStyles.body),
          // addedFrom == 'MULTIPRODUCT'
          //     ? Text(
          //         '${product.defaultPurchaseCount.toString()} * ${activeVariant.value.price!.offerPrice!}',
          //         style: TextStyles.bodySm)
          //     : const SizedBox(),
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
                          ' ${CodeHelp.formatUnit(product.varient!.unit)}',
                          style: TextStyles.body,
                        )
                      ],
                    )
                  : (product.varients!.length == 1 ||
                          addedFrom == 'TAGS_PRODUCT' ||
                          addedFrom == dealName.WEEKLY_DEAL.name ||
                          addedFrom == dealName.FLASH.name ||
                          addedFrom == dealName.SALES.name ||
                          addedFrom == dealName.SUPER_DEAL.name ||
                          addedFrom == dealName.ONLY_COIN_DEAL.name ||
                          addedFrom == dealName.EXCLUSIVE_DEAL.name ||
                          addedFrom == dealName.MEMBER_DEAL.name ||
                          addedFrom == dealName.PRIME_MEMBER_DEAL.name ||
                          addedFrom == dealName.CUSTOM_RULE_DEAL.name ||
                          addedFrom == 'MULTIPRODUCT')
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
              checkPriceVisibility() ? showPrice() : const SizedBox(),
            ],
          ),
          (addedFrom == 'TAGS_PRODUCT' ||
                  addedFrom == 'DEAL' ||
                  addedFrom == dealName.WEEKLY_DEAL.name ||
                  addedFrom == dealName.FLASH.name ||
                  addedFrom == dealName.SALES.name ||
                  addedFrom == dealName.SUPER_DEAL.name ||
                  addedFrom == dealName.ONLY_COIN_DEAL.name ||
                  addedFrom == dealName.EXCLUSIVE_DEAL.name ||
                  addedFrom == dealName.MEMBER_DEAL.name ||
                  addedFrom == dealName.PRIME_MEMBER_DEAL.name ||
                  addedFrom == dealName.CUSTOM_RULE_DEAL.name ||
                  addedFrom == 'MULTIPRODUCT')
              ? const SizedBox()
              : (product.varients!.length > 1
                  ? productVarientView(product.varients!)
                  : const SizedBox())
        ],
      ),
    );
  }

  Widget showPrice() {
    if (addedFrom == 'MSD') {
      var currentMemberPrice = Helper.getMsdAmount(
          price: activeVariant.value.price!,
          userType: stateController.userType.value);
      return Row(children: [
        Text(
          "${currentMemberPrice.toString()}${CodeHelp.euro} ",
          style: TextStyles.headingFont,
        ),
        ImageBox(
          stateController.membershipIcon.value,
          height: 20,
          width: 20,
          fit: BoxFit.contain,
        ),
      ]);
    } else {
      return
          // (addedFrom == 'PRODUCT' ||
          //         addedFrom == 'CATEGORY' ||
          //         addedFrom == 'TAGS_PRODUCT' ||
          //         addedFrom == 'TAG' ||
          //         addedFrom == 'BRAND' ||
          //         addedFrom == 'GUIDE' ||
          //         addedFrom == 'RECOMMENDED')
          //     ?
          Obx(() => PriceTag(activeVariant.value.price!.offerPrice!.toString(),
                  activeVariant.value.price!.actualPrice!.toString())
              //  Text(
              //       "${activeVariant.value.price!.actualPrice!.toString()} ${CodeHelp.euro}",
              //       style: TextStyles.headingFont,
              //     )
              );
      // : PriceTag(dealPrice!.offerPrice!.toString(),
      //     dealPrice!.actualPrice!.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    activeVariant.value = product!.varient!;
    var minOrder = (constraint != null &&
            constraint!.minimumOrder != null &&
            constraint!.minimumOrder != 0)
        ? constraint!.minimumOrder
        : 1;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.all(5),
          child: Container(
            color: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Stack(
                fit: StackFit.loose,
                children: [
                  _gridItemBody(product!, context),
                  _gridItemHeader(product!, context),
                  Obx(() {
                    return Visibility(
                      visible: checkBuyProductVisibility(),
                      child: Positioned(
                        right: fixedHeight ? 10 : 20,
                        top: 65,
                        child: AnimatedSwitcher(
                          switchInCurve: Curves.bounceIn,
                          switchOutCurve: Curves.easeOut,
                          duration: const Duration(milliseconds: 200),
                          child: AddToCartButtons(
                            hideAdd: cartController.checkProductInCart(
                                '$refId@${activeVariant.value.varientCode}',
                                addedFrom),
                            quantity: cartController.getCurrentQuantity(
                                '$refId@${activeVariant.value.varientCode}',
                                addedFrom),
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
                                            minOrder,
                                            price,
                                            product,
                                            null,
                                            ruleConfig,
                                            constraint,
                                            activeVariant.value);
                                      } else if (addedFrom == 'MSD') {
                                        await cartController.addToCartMSD(
                                            '$refId@${activeVariant.value.varientCode}',
                                            addedFrom!,
                                            minOrder,
                                            price,
                                            product,
                                            null,
                                            ruleConfig,
                                            constraint,
                                            activeVariant.value);
                                        await cartController.removeProduct(
                                            CurrentKey, '');
                                      } else if (addedFrom ==
                                          'RECOMMEDED_PRODUCT') {
                                        var data;
                                        if (Get.isRegistered<DealController>(
                                            tag: addedFrom!)) {
                                          var dealController =
                                              Get.find<DealController>(
                                                  tag: addedFrom!);
                                          data = await dealController
                                              .checkValidDeal(
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
                                              minOrder,
                                              price,
                                              product,
                                              null,
                                              ruleConfig,
                                              constraint,
                                              activeVariant.value);
                                          await cartController.removeProduct(
                                              CurrentKey, '');
                                        } else if (data['type'] ==
                                            'maxNumberExceeded') {
                                          snackBarClass.showToast(context, msg);
                                          await cartController.addToCart(
                                              '${product!.id}@${product!.varient!.varientCode}',
                                              'CATEGORY',
                                              minOrder,
                                              product!.varient!.price,
                                              product,
                                              null,
                                              RuleConfig(),
                                              Constraint(),
                                              product!.varient!);
                                        } else {
                                          snackBarClass.showToast(context, msg);
                                        }
                                      } else {
                                        var data;
                                        if (Get.isRegistered<DealController>(
                                            tag: addedFrom!)) {
                                          var dealController =
                                              Get.find<DealController>(
                                                  tag: addedFrom!);
                                          data = await dealController
                                              .checkValidDeal(
                                                  refId!,
                                                  'positive',
                                                  '$refId@${activeVariant.value.varientCode}');
                                          valid = !data['error'];
                                          msg = data['msg'];
                                          if (valid) price = dealPrice;
                                        }
                                        if (valid) {
                                          await cartController.addToCart(
                                              '$refId@${activeVariant.value.varientCode}',
                                              addedFrom!,
                                              minOrder,
                                              price,
                                              product,
                                              null,
                                              ruleConfig,
                                              constraint,
                                              activeVariant.value);
                                        } else if (data['type'] ==
                                            'maxNumberExceeded') {
                                          snackBarClass.showToast(context, msg);
                                          await cartController.addToCart(
                                              '${product!.id}@${product!.varient!.varientCode}',
                                              'CATEGORY',
                                              minOrder,
                                              product!.varient!.price,
                                              product,
                                              null,
                                              RuleConfig(),
                                              Constraint(),
                                              product!.varient!);
                                        } else {
                                          snackBarClass.showToast(context, msg);
                                        }
                                      }
                                    } else {
                                      // Navigator.of(context).pop();
                                      snackBarClass.showToast(context,
                                          'Your profile is Inactive!!');
                                    }
                                    stateController.showLoader.value = false;
                                  }
                                : () {
                                    stateController.setCurrentTab(3);
                                    snackBarClass.showToast(
                                        context, 'Please Login to proceed!!');
                                  },
                            onDecrease: () async {
                              stateController.showLoader.value = true;
                              Price? price = activeVariant.value.price;
                              if (stateController.isLogin.value) {
                                var valid = true;
                                var msg = 'Something went wrong!';
                                var data;
                                if (Get.isRegistered<DealController>(
                                    tag: addedFrom!)) {
                                  var dealController =
                                      Get.find<DealController>(tag: addedFrom!);
                                  data = await dealController.checkValidDeal(
                                      refId!,
                                      'negative',
                                      '$refId@${activeVariant.value.varientCode}');
                                  valid = !data['error'];
                                  msg = data['msg'];
                                  if (valid) price = dealPrice;
                                }
                                if (valid) {
                                  if (addedFrom == 'SCOIN') {
                                    await cartController.addToCartScoins(
                                        '$refId@${activeVariant.value.varientCode}',
                                        addedFrom!,
                                        -minOrder!,
                                        price,
                                        product,
                                        null,
                                        ruleConfig,
                                        constraint,
                                        activeVariant.value);
                                  } else if (addedFrom == 'MSD') {
                                    await cartController.addToCartMSD(
                                        '$refId@${activeVariant.value.varientCode}',
                                        addedFrom!,
                                        -minOrder!,
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
                                        -minOrder!,
                                        price,
                                        product,
                                        null,
                                        ruleConfig,
                                        constraint,
                                        activeVariant.value);
                                  }
                                } else if (data['type'] ==
                                    'maxNumberExceeded') {
                                  snackBarClass.showToast(context, msg);
                                  await cartController.addToCart(
                                      '${product!.id}@${product!.varient!.varientCode}',
                                      'CATEGORY',
                                      -minOrder!,
                                      product!.varient!.price,
                                      product,
                                      null,
                                      RuleConfig(),
                                      Constraint(),
                                      product!.varient!);
                                } else {
                                  await cartController.addToCart(
                                      '$refId@${activeVariant.value.varientCode}',
                                      addedFrom!,
                                      -minOrder!,
                                      price,
                                      product,
                                      null,
                                      ruleConfig,
                                      constraint,
                                      activeVariant.value);
                                }
                              } else {
                                stateController.setCurrentTab(3);
                                snackBarClass.showToast(
                                    context, 'Please Login to proceed!!');
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
                                  if (valid) price = dealPrice;
                                }
                                if (valid) {
                                  if (addedFrom == 'SCOIN') {
                                    await cartController.addToCartScoins(
                                        '$refId@${activeVariant.value.varientCode}',
                                        addedFrom!,
                                        minOrder,
                                        price,
                                        product,
                                        null,
                                        ruleConfig,
                                        constraint,
                                        activeVariant.value);
                                  } else if (addedFrom == 'MSD') {
                                    await cartController.addToCartMSD(
                                        '$refId@${activeVariant.value.varientCode}',
                                        addedFrom!,
                                        minOrder,
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
                                        minOrder,
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
                  }),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            margin: const EdgeInsets.only(left: 5, top: 5),
            child: DiscountTag(
              price: dealPrice!,
            ),
          ),
        ),
        (product!.tags!.length > 0 &&
                addedFrom != 'TAGS_PRODUCT' &&
                addedFrom != dealName.WEEKLY_DEAL.name &&
                addedFrom != dealName.FLASH.name &&
                addedFrom != dealName.SALES.name &&
                addedFrom != dealName.SUPER_DEAL.name &&
                addedFrom != dealName.ONLY_COIN_DEAL.name &&
                addedFrom != dealName.EXCLUSIVE_DEAL.name &&
                addedFrom != dealName.MEMBER_DEAL.name &&
                addedFrom != dealName.PRIME_MEMBER_DEAL.name &&
                addedFrom != dealName.CUSTOM_RULE_DEAL.name)
            ? Positioned(
                top: 25,
                child: Card(
                    color: AppColors.secondaryColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          product!.tags![0].name!,
                          style:
                              TextStyles.body.copyWith(color: AppColors.white),
                        ))))
            : const SizedBox()
      ],
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
                  padding: const EdgeInsets.fromLTRB(4, 1.0, 04, 01),
                  child: Center(
                    child: Text(
                      '${currentVarient.weight!.toStringAsFixed(0)} ${CodeHelp.formatUnit(currentVarient.unit!)}',
                      style: TextStyles.body.copyWith(
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
        },
      ),
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
