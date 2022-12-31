import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/controller/multi-product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/name.dart';
import 'package:amber_bird/data/deal_product/price.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class DealBottomDrawer extends StatelessWidget {
  final List<ProductSummary>? products;
  final String? refId;
  final String? addedFrom;
  final String? type;
  final Price? priceInfo;
  final Constraint? constraint;
  final Name? name;
  DealBottomDrawer(this.products, this.refId, this.addedFrom, this.priceInfo,
      this.constraint, this.name, this.type,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();
    final Controller stateController = Get.find();
    final WishlistController wishlistController = Get.find();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .75),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${name!.defaultText!.text}',
                        style: TextStyles.headingFontGray,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: products!.map((product) {
                        product.varient!.price = priceInfo;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ImageBox(
                                        product.images![0],
                                        width: 120,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        textDirection: TextDirection.ltr,
                                        children: [
                                          Visibility(
                                            visible: name!.defaultText!.text !=
                                                product.name!.defaultText!.text,
                                            child: Text(
                                              '${product.name!.defaultText!.text}',
                                              style: TextStyles.headingFont,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              ImageBox(
                                                product.category!.logoId!,
                                                width: 20,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '${product.category!.name!.defaultText!.text}',
                                                style:
                                                    TextStyles.subHeadingFont,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .5,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Card(
                                                  color: Colors.white,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Text(
                                                          '${product.varient!.weight!} ${CodeHelp.formatUnit(product.varient!.unit)}'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: -12,
                                    left: -12,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: wishlistController
                                                .checkIfProductWishlist(
                                                    product.id)
                                            ? AppColors.primeColor
                                            : AppColors.grey,
                                      ),
                                      onPressed: () => {
                                        wishlistController.addToWishlist(
                                            product.id,
                                            product,
                                            null,
                                            addedFrom)
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Description',
                                style: TextStyles.bodyFontBold,
                              ),
                              Html(
                                data: product.description!.defaultText!.text ??
                                    '',
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AppBar(
                    shape: Border(top: BorderSide(color: AppColors.primeColor)),
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PriceTag(priceInfo!.offerPrice.toString(),
                            priceInfo!.actualPrice.toString()),
                        GetX<CartController>(builder: (cController) {
                          return cController.checkProductInCart(refId)
                              ? Obx(
                                  () => Row(
                                    children: [
                                      IconButton(
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(),
                                        onPressed: () async {
                                          if (stateController.isLogin.value) {
                                            var valid = false;
                                            var msg = 'Something went wrong!';
                                            if (type == 'MULTIPRODUCT') {
                                              var multiController = Get.find<
                                                      MultiProductController>(
                                                  tag: addedFrom!);
                                              var data = await multiController
                                                  .checkValidDeal(refId!);
                                              valid = !data['error'];
                                              msg = data['msg'];
                                              if (valid) {
                                                cartController.addToCart(
                                                    refId!,
                                                    addedFrom!,
                                                    (-(constraint
                                                                ?.minimumOrder ??
                                                            1)) ??
                                                        -1,
                                                    priceInfo,
                                                    null,
                                                    products);
                                              } else {
                                                Navigator.of(context).pop();
                                                snackBarClass.showToast(
                                                    context, msg);
                                              }
                                            } else {
                                              if (Get.isRegistered<
                                                      DealController>(
                                                  tag: addedFrom!)) {
                                                var dealController =
                                                    Get.find<DealController>(
                                                        tag: addedFrom!);
                                                var data = await dealController
                                                    .checkValidDeal(refId!);
                                                valid = !data['error'];
                                                msg = data['msg'];
                                              }
                                              if (valid) {
                                                cartController.addToCart(
                                                    refId!,
                                                    addedFrom!,
                                                    -(constraint?.minimumOrder ??
                                                            1) ??
                                                        1,
                                                    priceInfo,
                                                    products![0],
                                                    null);
                                              } else {
                                                Navigator.of(context).pop();
                                                snackBarClass.showToast(
                                                    context, msg);
                                              }
                                            }
                                          } else {
                                            stateController.setCurrentTab(3);
                                            var showToast =
                                                snackBarClass.showToast(context,
                                                    'Please Login to preoceed');
                                          }
                                        },
                                        icon: const Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.black),
                                      ),
                                      Text(cController
                                          .getCurrentQuantity(refId)
                                          .toString()),
                                      IconButton(
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(),
                                        onPressed: () async {
                                          if (stateController.isLogin.value) {
                                            var valid = false;
                                            var msg = 'Something went wrong!';

                                            if (type == 'MULTIPRODUCT') {
                                              var multiController = Get.find<
                                                      MultiProductController>(
                                                  tag: addedFrom!);
                                              var data = await multiController
                                                  .checkValidDeal(refId!);
                                              valid = !data['error'];
                                              msg = data['msg'];
                                              if (valid) {
                                                cartController.addToCart(
                                                    refId!,
                                                    addedFrom!,
                                                    constraint!.minimumOrder ??
                                                        1,
                                                    priceInfo,
                                                    null,
                                                    products);
                                              } else {
                                                Navigator.of(context).pop();
                                                snackBarClass.showToast(
                                                    context, msg);
                                              }
                                            } else {
                                              if (Get.isRegistered<
                                                      DealController>(
                                                  tag: addedFrom!)) {
                                                var dealController =
                                                    Get.find<DealController>(
                                                        tag: addedFrom!);
                                                var data = await dealController
                                                    .checkValidDeal(refId!);
                                                valid = !data['error'];
                                                msg = data['msg'];
                                              }
                                              if (valid) {
                                                cartController.addToCart(
                                                    refId!,
                                                    addedFrom!,
                                                    constraint!.minimumOrder ??
                                                        1,
                                                    priceInfo,
                                                    products![0],
                                                    null);
                                              } else {
                                                stateController
                                                    .setCurrentTab(3);
                                                snackBarClass.showToast(context,
                                                    'Please Login to preoceed');
                                              }
                                            }
                                          }
                                        },
                                        icon: const Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                )
                              : Obx(
                                  () => ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primeColor,
                                        textStyle: TextStyles.bodyWhite),
                                    onPressed: stateController.isLogin.value
                                        ? () async {
                                            if (stateController
                                                .isActivate.value) {
                                              var valid = false;
                                              var msg = 'Something went wrong!';

                                              if (type == 'MULTIPRODUCT') {
                                                var multiController = Get.find<
                                                        MultiProductController>(
                                                    tag: addedFrom!);
                                                var data = await multiController
                                                    .checkValidDeal(refId!);
                                                valid = !data['error'];
                                                msg = data['msg'];
                                                if (valid) {
                                                  cartController.addToCart(
                                                      refId!,
                                                      addedFrom!,
                                                      constraint!
                                                              .minimumOrder ??
                                                          1,
                                                      priceInfo,
                                                      null,
                                                      products);
                                                } else {
                                                  Navigator.of(context).pop();
                                                  snackBarClass.showToast(
                                                      context, msg);
                                                }
                                              } else {
                                                // this.refId, this.addedFrom,
                                                if (Get.isRegistered<
                                                        DealController>(
                                                    tag: addedFrom!)) {
                                                  var dealController =
                                                      Get.find<DealController>(
                                                          tag: addedFrom!);
                                                  var data =
                                                      await dealController
                                                          .checkValidDeal(
                                                              refId!);
                                                  valid = !data['error'];
                                                  msg = data['msg'];
                                                }
                                                if (valid) {
                                                  cartController.addToCart(
                                                      refId!,
                                                      addedFrom!,
                                                      constraint!
                                                              .minimumOrder ??
                                                          1,
                                                      priceInfo,
                                                      products![0],
                                                      null);
                                                } else {
                                                  Navigator.of(context).pop();
                                                  snackBarClass.showToast(
                                                      context, msg);
                                                }
                                              }
                                            } else {
                                              Navigator.of(context).pop();
                                              snackBarClass.showToast(context,
                                                  'Your profile is not active yet');
                                            }
                                          }
                                        : () {
                                            Navigator.of(context).pop();
                                            stateController.setCurrentTab(3);
                                            snackBarClass.showToast(context,
                                                'Please Login to preoceed');
                                          },
                                    child: Text("Add to cart",
                                        style: TextStyles.addTocartText),
                                  ),
                                );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
