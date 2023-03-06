import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/multi-product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/discount-tag.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/ui/widget/view-more-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/controller-generator.dart';

class MultiProductRow extends StatelessWidget {
  bool isLoading = false;
  final currenttypeName;
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  final Controller stateController = Get.find();
  MultiProductRow(this.currenttypeName, {super.key});

  @override
  Widget build(BuildContext context) {
    final MultiProductController multiprodController = Get.put(
        MultiProductController(currenttypeName),
        tag: currenttypeName.toString());
    // if (dealController.dealProd.isNotEmpty) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    multiprodController.getProductName(currenttypeName),
                    style: TextStyles.titleLargeBold,
                  ),
                  ViewMoreWidget(onTap: () {
                    MegaMenuController megaMenuController;
                    if (Get.isRegistered<MegaMenuController>()) {
                      megaMenuController = Get.find();
                    } else {
                      megaMenuController = Get.put(MegaMenuController());
                    }
                    megaMenuController.selectedParentTab.value =
                        currenttypeName;
                    if (currenttypeName == multiProductName.COMBO.name) {
                      megaMenuController.getSubMenu(GenericTab(
                          image: '7e572f4e-6e21-4c0f-a8a8-44e2c7d64fd2',
                          id: multiProductName.COMBO.name,
                          type: 'MULTI',
                          text: 'Combo'));
                    }
                    stateController.setCurrentTab(1);
                  }),
                ],
              ),
            ),
          ),
          childListing(multiprodController, context)
        ],
      ),
    );
  }

  Widget childListing(
      MultiProductController multiprodController, BuildContext context) {
    if (currenttypeName == multiProductName.COMBO.name) {
      return twoProductListing(multiprodController, context);
    } else if (currenttypeName == multiProductName.COLLECTION.name ||
        currenttypeName == multiProductName.BUNDLE.name) {
      return multiProductListing(multiprodController, context);
    } else {
      return const Text('No implemented');
    }
  }

  Widget twoProductListing(
      MultiProductController multiprodController, BuildContext context) {
    return SizedBox(
      height: 340,
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: multiprodController.multiProd.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              Multi mProduct = multiprodController.multiProd[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: ImageBox(
                        mProduct.displayImageId != null &&
                                mProduct.displayImageId!.length > 3
                            ? mProduct.displayImageId!
                            : 'd5e438b9-6eee-4214-b1bd-c15cd1f57f81',
                        height: 60,
                        width: MediaQuery.of(context).size.width * .6,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5.0),
                      height: 160,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          for (var i = 0;
                              i < mProduct.products!.length;
                              i++) ...[
                            SizedBox(
                              width: 150,
                              child: ProductCard(
                                  mProduct.products![i],
                                  mProduct.products![i].id,
                                  fixedHeight: true,
                                  'MULTIPRODUCT',
                                  mProduct.products![i].varient!.price!,
                                  null,
                                  mProduct.constraint),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Container(
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
                              mProduct.name!.defaultText!.text ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .6,
                              child: Row(
                                children: [
                                  PriceTag(
                                      mProduct.price!.offerPrice.toString(),
                                      mProduct.price!.actualPrice.toString()),
                                  const Spacer(),
                                  addToCartButton(
                                      multiprodController, mProduct, context)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget multiProductListing(
      MultiProductController multiprodController, BuildContext context) {
    return SizedBox(
      height: 270,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: multiprodController.multiProd.length,
          itemBuilder: (_, index) {
            return multiProductTile(multiprodController,
                multiprodController.multiProd[index], context);
          },
        ),
      ),
    );
  }

  Widget multiProductTile(MultiProductController multiprodController,
      Multi multiProd, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageBox(
                multiProd.displayImageId!,
                width: MediaQuery.of(context).size.width * .4,
                fit: BoxFit.contain,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${multiProd.name!.defaultText!.text}',
                    style: TextStyles.bodyFont
                        .copyWith(fontSize: 20, color: Colors.grey),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PriceTag(multiProd.price!.offerPrice.toString(),
                        multiProd.price!.actualPrice.toString()),
                    const SizedBox(
                      width: 10,
                    ),
                    addToCartButton(multiprodController, multiProd, context),
                  ])
            ],
          ),
          DiscountTag(price: multiProd.price!)
        ],
      ),
    );
  }

  addToCartButton(MultiProductController multiprodController, Multi multiProd,
      BuildContext context) {
    return Obx(
      () {
        return Align(
          alignment: Alignment.centerRight,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: cartController.checkProductInCart(multiProd.id, '')
                ? Card(
                    color: AppColors.primeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        IconButton(
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            if (stateController.isLogin.value) {
                              var valid = false;
                              var msg = 'Something went wrong!';

                              var data =
                                  await multiprodController.checkValidDeal(
                                      multiProd.id!, 'negative', multiProd.id!);
                              valid = !data['error'];
                              msg = data['msg'];
                              if (valid) {
                                cartController.addToCart(
                                    multiProd.id!,
                                    'MULTIPRODUCT',
                                    (-(multiProd.constraint?.minimumOrder ??
                                            1)) ??
                                        -1,
                                    multiProd.price,
                                    null,
                                    multiProd.products,
                                    null,
                                    multiProd.constraint,
                                    null,
                                    mutliProductName:
                                        multiProd.name!.defaultText!.text!);
                              } else {
                                Navigator.of(context).pop();
                                snackBarClass.showToast(context, msg);
                              }
                            } else {
                              stateController.setCurrentTab(3);
                              var showToast = snackBarClass.showToast(
                                  context, 'Please Login to preoceed');
                            }
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        Text(
                          cartController
                              .getCurrentQuantity(multiProd.id, '')
                              .toString(),
                          style: TextStyles.bodyWhite.copyWith(fontSize: 20),
                        ),
                        IconButton(
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            if (stateController.isLogin.value) {
                              var valid = false;
                              var msg = 'Something went wrong!';

                              var data =
                                  await multiprodController.checkValidDeal(
                                      multiProd.id!, 'positive', multiProd.id!);
                              valid = !data['error'];
                              msg = data['msg'];
                              if (valid) {
                                cartController.addToCart(
                                    multiProd.id!,
                                    'MULTIPRODUCT',
                                    multiProd.constraint!.minimumOrder ?? 1,
                                    multiProd.price,
                                    null,
                                    multiProd.products,
                                    null,
                                    multiProd.constraint,
                                    null,
                                    mutliProductName:
                                        multiProd.name!.defaultText!.text!);
                              } else {
                                snackBarClass.showToast(context, msg);
                              }
                            } else {
                              stateController.setCurrentTab(3);
                              var showToast = snackBarClass.showToast(
                                  context, 'Please Login to preoceed');
                            }
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
                : CircleAvatar(
                    backgroundColor: AppColors.primeColor,
                    radius: 20,
                    child: IconButton(
                      padding: const EdgeInsets.all(1),
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        if (stateController.isLogin.value) {
                          stateController.showLoader.value = true;
                          bool isCheckedActivate =
                              await stateController.getUserIsActive();
                          if (isCheckedActivate) {
                            var valid = false;
                            var msg = 'Something went wrong!';

                            var data = await multiprodController.checkValidDeal(
                                multiProd.id!, 'positive', multiProd.id!);
                            valid = !data['error'];
                            msg = data['msg'];
                            if (valid) {
                              cartController.addToCart(
                                  multiProd.id!,
                                  'MULTIPRODUCT',
                                  multiProd.constraint!.minimumOrder ?? 1,
                                  multiProd.price,
                                  null,
                                  multiProd.products,
                                  null,
                                  multiProd.constraint,
                                  null,
                                  mutliProductName:
                                      multiProd.name!.defaultText!.text!);
                            } else {
                              Navigator.of(context).pop();
                              snackBarClass.showToast(context, msg);
                            }
                          }
                        } else {
                          stateController.setCurrentTab(3);
                          var showToast = snackBarClass.showToast(
                              context, 'Please Login to preoceed');
                        }
                        stateController.showLoader.value = false;
                      },
                      icon: const Icon(
                        Icons.add,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
