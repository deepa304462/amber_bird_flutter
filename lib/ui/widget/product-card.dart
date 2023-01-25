import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/controller/multi-product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/bootom-drawer/deal-bottom-drawer.dart';
import 'package:amber_bird/ui/widget/bootom-drawer/product-bottom-drawer.dart';
import 'package:amber_bird/ui/widget/card-color-animated.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final ProductSummary? product;
  final String? refId;
  final String? addedFrom;
  final Price? dealPrice;
  final RuleConfig? ruleConfig;
  final bool fixedHeight;
  Rx<Varient> activeVariant = Varient().obs;
  ProductCard(
      this.product, this.refId, this.addedFrom, this.dealPrice, this.ruleConfig,
      {super.key, this.fixedHeight = false});

  final CartController cartController = Get.find();
  final Controller stateController = Get.find();
  final WishlistController wishlistController = Get.find();
  Widget _gridItemBody(ProductSummary product, BuildContext context) {
    return Column(
      children: [
        product.images!.isNotEmpty
            ? InkWell(
                onTap: () {
                  Modular.to.pushNamed('product/${product.id}');
                },
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child:
                      // Image.network(
                      //   '${ClientService.cdnUrl}${product.images![0]}',
                      //   fit: BoxFit.fitHeight,
                      // ),
                      ImageBox(product.images![0]),
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
    String timeLeft = '';
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
                        bottomRight: Radius.circular(12))),
              )
            : const SizedBox(),
        Obx(() {
          return Visibility(
            visible: checkFavVisibility(),
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: wishlistController.checkIfProductWishlist(product.id)
                    ? AppColors.primeColor
                    : const Color(0xFFA6A3A0),
              ),
              onPressed: () async {
                stateController.showLoader.value = true;
                await wishlistController.addToWishlist(
                    product.id, product, null, addedFrom);
                stateController.showLoader.value = false;
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _gridItemFooter(ProductSummary product, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      // margin: const EdgeInsets.only(left: 3, right: 3),
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
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
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
                        Text('${product.varient!.weight}'),
                        Text(
                          '${CodeHelp.formatUnit(product.varient!.unit)}',
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 12),
                        )
                      ],
                    )
                  : SizedBox(),
              checkPriceVisibility()
                  ? addedFrom == 'DEAL'
                      ? PriceTag(dealPrice!.offerPrice!.toString(),
                          dealPrice!.actualPrice!.toString())
                      : PriceTag(product.varient!.price!.offerPrice!.toString(),
                          product.varient!.price!.actualPrice!.toString())
                  : const SizedBox(),
            ],
          ),
          product.varients!.length > 0
              ? productVarientView(product.varients!)
              : SizedBox()
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
            Obx(
              () => Visibility(
                visible: checkBuyProductVisibility(),
                child: cartController.checkProductInCart(
                        '$refId@${activeVariant.value.varientCode}')
                    ? Positioned(
                        right: 0,
                        top: 50,
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

                                  if (Get.isRegistered<DealController>(
                                      tag: addedFrom!)) {
                                    var dealController =
                                        Get.find<DealController>(
                                            tag: addedFrom!);
                                    var data = await dealController.checkValidDeal(
                                        refId!,
                                        'negative',
                                        '$refId@${activeVariant.value.varientCode}');
                                    valid = !data['error'];
                                    msg = data['msg'];
                                  }
                                  if (valid) {
                                    cartController.addToCart(
                                        '$refId@${activeVariant.value.varientCode}',
                                        addedFrom!,
                                        -1,
                                        dealPrice,
                                        product,
                                        null);
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
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.black),
                            ),
                            Text(cartController
                                .getCurrentQuantity(
                                    '$refId@${activeVariant.value.varientCode}')
                                .toString()),
                            IconButton(
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                              onPressed: () async {
                                stateController.showLoader.value = true;
                                if (stateController.isLogin.value) {
                                  var valid = false;
                                  var msg = 'Something went wrong!';

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
                                    cartController.addToCart(
                                        '$refId@${activeVariant.value.varientCode}',
                                        addedFrom!,
                                        1,
                                        dealPrice,
                                        product,
                                        null);
                                  } else {
                                    stateController.setCurrentTab(3);
                                    snackBarClass.showToast(context, msg);
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
                    : Positioned(
                        right: 0,
                        top: 50,
                        child: CircleAvatar(
                          backgroundColor: Colors.red.shade900,
                          radius: 20,
                          child: IconButton(
                            constraints: const BoxConstraints(),
                            color: Colors.white,

                            onPressed: stateController.isLogin.value
                                ? () async {
                                    stateController.showLoader.value = true;
                                    if (stateController.isActivate.value) {
                                      var valid = false;
                                      var msg = 'Something went wrong!';

                                      // this.refId, this.addedFrom,
                                      if (addedFrom == 'CATEGORY') {
                                        // if (product!.multiVarientExists ==
                                        //     true) {
                                        //   showModalBottomSheet<void>(
                                        //       context: context,
                                        //       useRootNavigator: true,
                                        //       shape: RoundedRectangleBorder(
                                        //           borderRadius:
                                        //               BorderRadius.circular(
                                        //                   13)),
                                        //       backgroundColor: Colors.white,
                                        //       isScrollControlled: true,
                                        //       elevation: 3,
                                        //       builder: (context) {
                                        //         return ProductBottomDrawer(
                                        //             refId);
                                        //       });
                                        // } else {
                                        cartController.addToCart(
                                            '$refId@${activeVariant.value.varientCode}',
                                            addedFrom!,
                                            1,
                                            dealPrice,
                                            product,
                                            null);
                                        // }
                                      } else {
                                        if (Get.isRegistered<DealController>(
                                            tag: addedFrom!)) {
                                          var dealController =
                                              Get.find<DealController>(
                                                  tag: addedFrom!);
                                          var data = await dealController
                                              .checkValidDeal(
                                                  refId!,
                                                  'positive',
                                                  '$refId@${activeVariant.value.varientCode}');
                                          valid = !data['error'];
                                          msg = data['msg'];
                                        }
                                        if (valid) {
                                          cartController.addToCart(
                                              '$refId@${activeVariant.value.varientCode}',
                                              addedFrom!,
                                              1,
                                              dealPrice,
                                              product,
                                              null);
                                        } else {
                                          snackBarClass.showToast(context, msg);
                                        }
                                      }
                                    } else {
                                      // Navigator.of(context).pop();
                                      snackBarClass.showToast(context,
                                          'Your profile is not active yet');
                                    }
                                    stateController.showLoader.value = false;
                                  }
                                : () {
                                    stateController.setCurrentTab(3);
                                    snackBarClass.showToast(
                                        context, 'Please Login to preoceed');
                                  },

                            // onPressed: () {
                            //   showModalBottomSheet<void>(
                            //     context: context,
                            //     useRootNavigator: true,
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(13)),
                            //     backgroundColor: Colors.white,
                            //     isScrollControlled: true,
                            //     elevation: 3,
                            //     builder: (context) {
                            //       if (addedFrom == 'CATEGORY') {
                            //         return ProductBottomDrawer(refId);
                            //       } else {
                            //         return DealBottomDrawer(
                            //             [product!],
                            //             refId,
                            //             addedFrom,
                            //             dealPrice,
                            //             Constraint(),
                            //             product!.name,
                            //             addedFrom!);
                            //       }
                            //     },
                            //   );
                            // },
                            icon: const Icon(
                              Icons.add,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productVarientView(List<Varient> varientList) {
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
          }),
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
