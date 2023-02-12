import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/deal-controller.dart';
import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/scoin-product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/deal_product-card.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class ScoinProductRow extends StatelessWidget {
  bool isLoading = false;
  final Controller stateController = Get.find();
  final CartController cartController = Get.find();
  final WishlistController wishlistController = Get.find();
  Rx<Varient> activeVariant = Varient().obs;
  ScoinProductRow({super.key});

  @override
  Widget build(BuildContext context) {
    final ScoinProductController scoinController =
        Get.put(ScoinProductController());
    return Obx(() {
      if (scoinController.sCoinProd.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Scoin",
                        style: TextStyles.titleLargeSemiBold,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          MegaMenuController megaMenuController;
                          if (Get.isRegistered<MegaMenuController>()) {
                            megaMenuController = Get.find();
                          } else {
                            megaMenuController = Get.put(MegaMenuController());
                          }
                          // megaMenuController.selectedParentTab.value =
                          //     currentdealName;

                          stateController.setCurrentTab(2);
                        },
                        child: Text(
                          'View More',
                          style: TextStyles.bodyWhite,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primeColor,
                          // This is what you need!
                        ),
                      ),

                      // Text(
                      //   'View More',
                      //   style: TextStyles.headingFontBlue,
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                    height: 220,
                    child: ScoinProductCard(scoinController, context))
              ],
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Widget ScoinProductCard(scoinController, context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: scoinController.sCoinProd.length,
          itemBuilder: (_, index) {
            ProductSummary dProduct = scoinController.sCoinProd[index];
            return SizedBox(
              width: 150,
              child: ProductCardScoin(dProduct, dProduct.id, 'SCOIN',
                  dProduct.varient!.price, null, null, context),
            );
          },
        ),
      ),
    );
  }

  Widget ProductCardScoin(
      product, refId, addedFrom, dealPrice, ruleConfig, constraint, context) {
    activeVariant.value = product!.varient!;
    return Padding(
      padding: const EdgeInsetsDirectional.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          fit: StackFit.loose,
          children: [
            _gridItemBody(product!, ruleConfig, constraint, context),
            _gridItemHeader(product!),
          ],
        ),
      ),
    );
  }

  Widget _gridItemBody(ProductSummary product, RuleConfig ruleConfig,
      Constraint constraint, BuildContext context) {
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
        _gridItemFooter(product, ruleConfig, constraint, context)
      ],
    );
  }

  Widget _gridItemHeader(ProductSummary product) {
    String timeLeft = '';
    var difference;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() {
          return Visibility(
            visible: true,
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
                    product.id, product, null, 'SCOIN');
                stateController.showLoader.value = false;
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _gridItemFooter(ProductSummary product, RuleConfig ruleConfig,
      Constraint constraint, BuildContext context) {
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
            overflow: false ? TextOverflow.ellipsis : TextOverflow.visible,
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
                  : const SizedBox(),
              PriceTag(product.varient!.price!.offerPrice!.toString(),
                  product.varient!.price!.actualPrice!.toString()),
            ],
          ),
          Obx(
            () => Positioned(
              right: 0,
              top: 50,
              child: CircleAvatar(
                backgroundColor: Colors.red.shade900,
                radius: 20,
                child: TextButton(
                  child: Text('Buy Now'),
                  onPressed: stateController.isLogin.value
                      ? () async {
                          stateController.showLoader.value = true;
                          bool isCheckedActivate =
                              await stateController.getUserIsActive();
                          if (isCheckedActivate) {
                            // if (stateController.isActivate.value) {
                            var valid = false;
                            var msg = 'Something went wrong!';
                            var data =
                                await cartController.scoinProductCartCreate(
                                    product, ruleConfig, constraint);
                            valid = !data['error'];
                            msg = data['msg'];

                            if (valid) {
                              Modular.to.navigate('/scoin-checkout');
                            }else{
                               snackBarClass.showToast(
                                  context, msg);
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
