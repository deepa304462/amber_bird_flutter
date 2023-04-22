import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/controller/multi-product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/name.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/data/price/price.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../helpers/controller-generator.dart';

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
    final Controller stateController = Get.find();
    final WishlistController wishlistController = Get.find();
    final CartController cartController =
        ControllerGenerator.create(CartController(), tag: 'cartController');
    num totalNumberOfProducts = 0;
    products!.forEach(
      (element) {
        totalNumberOfProducts =
            totalNumberOfProducts + element.defaultPurchaseCount!;
      },
    );
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
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${name!.defaultText!.text}',
                            style: TextStyles.headingFont
                                .copyWith(color: AppColors.grey),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${totalNumberOfProducts} Products',
                            style: TextStyles.headingFont
                                .copyWith(color: AppColors.primeColor),
                          ),
                        ],
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
                  padding: const EdgeInsets.all(4.0),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ImageBox(
                                    product.images![0],
                                    width: 50,
                                    fit: BoxFit.contain,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    textDirection: TextDirection.ltr,
                                    children: [
                                      Visibility(
                                        visible: name!.defaultText!.text !=
                                            product.name!.defaultText!.text,
                                        child: Text(
                                          '${product.name!.defaultText!.text}',
                                          style: TextStyles.bodyFontBold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Card(
                                              color: Colors.white,
                                              margin: const EdgeInsets.all(5),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Text(
                                                      '${product.defaultPurchaseCount ?? '1'} x ${product.varient!.weight!} ${CodeHelp.formatUnit(product.varient!.unit)}'),
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
                              const Divider(),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 50,
              child: AppBar(
                shape: Border(top: BorderSide(color: AppColors.primeColor)),
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.primeColor,
                title: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: PriceTag(priceInfo!.offerPrice.toString(),
                              priceInfo!.actualPrice.toString()),
                        ),
                      ),
                      cartController.checkProductInCart(refId, addedFrom)
                          ? Row(
                              children: [
                                IconButton(
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                  onPressed: () async {
                                    stateController.showLoader.value = true;
                                    if (stateController.isLogin.value) {
                                      var valid = false;
                                      var msg = 'Something went wrong!';
                                      if (type == 'MULTIPRODUCT') {
                                        var multiController =
                                            Get.find<MultiProductController>(
                                                tag: addedFrom!);
                                        var data = await multiController
                                            .checkValidDeal(
                                                refId!, 'negative', refId!);
                                        valid = !data['error'];
                                        msg = data['msg'];
                                        if (valid) {
                                          await cartController.addToCart(
                                              refId!,
                                              addedFrom!,
                                              (-(constraint?.minimumOrder ??
                                                      1)) ??
                                                  -1,
                                              priceInfo,
                                              null,
                                              products,
                                              null,
                                              null,
                                              Varient());
                                          stateController.showLoader.value =
                                              false;
                                        } else {
                                          stateController.showLoader.value =
                                              false;
                                          Navigator.of(context).pop();
                                          // ignore: use_build_context_synchronously
                                          snackBarClass.showToast(context, msg);
                                        }
                                      } else {
                                        if (Get.isRegistered<DealController>(
                                            tag: addedFrom!)) {
                                          var dealController =
                                              Get.find<DealController>(
                                                  tag: addedFrom!);
                                          var data = await dealController
                                              .checkValidDeal(
                                                  refId!, 'negative', refId!);
                                          valid = !data['error'];
                                          msg = data['msg'];
                                        }
                                        if (valid) {
                                          await cartController.addToCart(
                                              refId!,
                                              addedFrom!,
                                              -(constraint?.minimumOrder ??
                                                      1) ??
                                                  -1,
                                              priceInfo,
                                              products![0],
                                              null,
                                              null,
                                              null,
                                              products![0].varient);
                                          stateController.showLoader.value =
                                              false;
                                        } else {
                                          stateController.showLoader.value =
                                              false;
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                          // ignore: use_build_context_synchronously
                                          snackBarClass.showToast(context, msg);
                                        }
                                      }
                                    } else {
                                      stateController.showLoader.value = false;
                                      stateController.setCurrentTab(3);
                                      snackBarClass.showToast(
                                          context, 'Please Login to preoceed');
                                    }
                                  },
                                  icon: Icon(Icons.remove_circle_outline,
                                      color: AppColors.white),
                                ),
                                Text(
                                    cartController
                                        .getCurrentQuantity(refId, '')
                                        .toString(),
                                    style: TextStyles.bodyFont
                                        .copyWith(color: AppColors.white)),
                                IconButton(
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                  onPressed: () async {
                                    stateController.showLoader.value = true;
                                    if (stateController.isLogin.value) {
                                      var valid = false;
                                      var msg = 'Something went wrong!';

                                      if (type == 'MULTIPRODUCT') {
                                        var multiController =
                                            Get.find<MultiProductController>(
                                                tag: addedFrom!);
                                        var data = await multiController
                                            .checkValidDeal(
                                                refId!, 'positive', refId!);
                                        valid = !data['error'];
                                        msg = data['msg'];
                                        if (valid) {
                                          await cartController.addToCart(
                                              refId!,
                                              addedFrom!,
                                              constraint!.minimumOrder ?? 1,
                                              priceInfo,
                                              null,
                                              products,
                                              null,
                                              null,
                                              null);
                                          stateController.showLoader.value =
                                              false;
                                        } else {
                                          stateController.showLoader.value =
                                              false;
                                          Navigator.of(context).pop();
                                          snackBarClass.showToast(context, msg);
                                        }
                                      } else {
                                        if (Get.isRegistered<DealController>(
                                            tag: addedFrom!)) {
                                          var dealController =
                                              Get.find<DealController>(
                                                  tag: addedFrom!);
                                          var data = await dealController
                                              .checkValidDeal(
                                                  refId!, 'positive', refId!);
                                          valid = !data['error'];
                                          msg = data['msg'];
                                        }
                                        if (valid) {
                                          await cartController.addToCart(
                                              refId!,
                                              addedFrom!,
                                              constraint!.minimumOrder ?? 1,
                                              priceInfo,
                                              products![0],
                                              null,
                                              null,
                                              null,
                                              null);
                                          stateController.showLoader.value =
                                              false;
                                        } else {
                                          stateController.showLoader.value =
                                              false;
                                          stateController.setCurrentTab(3);
                                          snackBarClass.showToast(context,
                                              'Please Login to preoceed');
                                        }
                                      }
                                    }
                                  },
                                  icon: Icon(Icons.add_circle_outline,
                                      color: AppColors.white),
                                ),
                              ],
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primeColor,
                                  textStyle: TextStyles.body
                                      .copyWith(color: AppColors.white)),
                              onPressed: stateController.isLogin.value
                                  ? () async {
                                      stateController.showLoader.value = true;
                                      bool isCheckedActivate =
                                          await stateController
                                              .getUserIsActive();
                                      if (isCheckedActivate) {
                                        var valid = false;
                                        var msg = 'Something went wrong!';

                                        if (type == 'MULTIPRODUCT') {
                                          var multiController =
                                              Get.find<MultiProductController>(
                                                  tag: addedFrom!);
                                          var data = await multiController
                                              .checkValidDeal(
                                                  refId!, 'positive', refId!);
                                          valid = !data['error'];
                                          msg = data['msg'];
                                          if (valid) {
                                            await cartController.addToCart(
                                                refId!,
                                                addedFrom!,
                                                constraint!.minimumOrder ?? 1,
                                                priceInfo,
                                                null,
                                                products,
                                                null,
                                                null,
                                                null);
                                            stateController.showLoader.value =
                                                false;
                                          } else {
                                            stateController.showLoader.value =
                                                false;
                                            Navigator.of(context).pop();
                                            snackBarClass.showToast(
                                                context, msg);
                                          }
                                        } else {
                                          // this.refId, this.addedFrom,
                                          if (Get.isRegistered<DealController>(
                                              tag: addedFrom!)) {
                                            var dealController =
                                                Get.find<DealController>(
                                                    tag: addedFrom!);
                                            var data = await dealController
                                                .checkValidDeal(
                                                    refId!, 'positive', refId!);
                                            valid = !data['error'];
                                            msg = data['msg'];
                                          }
                                          if (valid) {
                                            await cartController.addToCart(
                                                refId!,
                                                addedFrom!,
                                                constraint!.minimumOrder ?? 1,
                                                priceInfo,
                                                products![0],
                                                null,
                                                null,
                                                null,
                                                null);
                                            stateController.showLoader.value =
                                                false;
                                          } else {
                                            stateController.showLoader.value =
                                                false;
                                            Navigator.of(context).pop();
                                            snackBarClass.showToast(
                                                context, msg);
                                          }
                                        }
                                      } else {
                                        stateController.showLoader.value =
                                            false;
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                        // ignore: use_build_context_synchronously
                                        snackBarClass.showToast(context,
                                            'Your profile is not active yet');
                                      }
                                      stateController.showLoader.value = false;
                                    }
                                  : () {
                                      Navigator.of(context).pop();
                                      stateController.setCurrentTab(3);
                                      snackBarClass.showToast(
                                          context, 'Please Login to preoceed');
                                    },
                              child: Text("Add to cart",
                                  style: TextStyles.headingFont
                                      .copyWith(color: AppColors.white)),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
