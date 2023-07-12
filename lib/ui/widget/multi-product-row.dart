import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/multi-product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/bootom-drawer/deal-bottom-drawer.dart';
import 'package:amber_bird/ui/widget/discount-tag.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/ui/widget/view-more-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/controller-generator.dart';
import 'add-to-cart-button.dart';

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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(style: TextStyles.body, children: <TextSpan>[
                    TextSpan(
                      text: multiprodController.getMonth(),
                      style: TextStyles.headingFont
                          .copyWith(color: AppColors.primeColor),
                    ),
                    TextSpan(
                      text: ' ',
                      style: TextStyles.headingFont
                          .copyWith(color: AppColors.primeColor),
                    ),
                    TextSpan(
                      text: multiprodController.getProductName(currenttypeName),
                      style: TextStyles.headingFont,
                    )
                  ]),
                ),
                ViewMoreWidget(onTap: () async {
                  MegaMenuController megaMenuController =
                      ControllerGenerator.create(MegaMenuController(),
                          tag: 'megaMenuController');
                  megaMenuController.selectedParentTab.value = 'MULTI';
                  GenericTab parentTab = GenericTab(
                      image: '7e572f4e-6e21-4c0f-a8a8-44e2c7d64fd2',
                      id: 'MULTI',
                      type: 'MULTI',
                      text: 'Multi');
                  await megaMenuController.getSubMenu(parentTab,
                      loadProd: false);
                  megaMenuController.selectedSubMenu.value = currenttypeName;
                  if (currenttypeName == multiProductName.COMBO.name) {
                    megaMenuController.getAllProducts(
                        GenericTab(
                            image: '7e572f4e-6e21-4c0f-a8a8-44e2c7d64fd2',
                            id: multiProductName.COMBO.name,
                            type: 'MULTI',
                            text: 'Combo'),
                        parentTab);
                  } else if (currenttypeName == multiProductName.BUNDLE.name) {
                    megaMenuController.getAllProducts(
                        GenericTab(
                            image: '7e572f4e-6e21-4c0f-a8a8-44e2c7d64fd2',
                            id: multiProductName.BUNDLE.name,
                            type: 'MULTI',
                            text: 'Bundle'),
                        parentTab);
                  } else if (currenttypeName ==
                      multiProductName.COLLECTION.name) {
                    megaMenuController.getAllProducts(
                        GenericTab(
                            image: '7e572f4e-6e21-4c0f-a8a8-44e2c7d64fd2',
                            id: multiProductName.COLLECTION.name,
                            type: 'MULTI',
                            text: 'Collection'),
                        parentTab);
                  } else if (currenttypeName == multiProductName.STORIES.name) {
                    megaMenuController.getAllProducts(
                        GenericTab(
                            image: '7e572f4e-6e21-4c0f-a8a8-44e2c7d64fd2',
                            id: multiProductName.STORIES.name,
                            type: 'MULTI',
                            text: 'Stories'),
                        parentTab);
                  }
                  stateController.setCurrentTab(1);
                }),
              ],
            ),
          ),
        ),
        childListing(multiprodController, context)
      ],
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
      height: 300,
      child: Obx(() {
        if (multiprodController.multiProd.isNotEmpty) {
          multiprodController.multiProd.shuffle();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 2),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: multiprodController.multiProd.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              Multi mProduct = multiprodController.multiProd[index];
              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width * .7,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.all(Radius.circular(20)),
                      // shape: BoxShape.rectangle,
                      color: AppColors.white,
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Container(
                              color: Colors.white,
                              child: ImageBox(
                                mProduct.displayImageId != null &&
                                        mProduct.displayImageId!.length > 3
                                    ? mProduct.displayImageId!
                                    : 'd5e438b9-6eee-4214-b1bd-c15cd1f57f81',
                                height: 90,
                                width: MediaQuery.of(context).size.width * .7,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Card(
                              margin: const EdgeInsets.fromLTRB(0, 2, 5, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  (mProduct.name!.defaultText!.text ?? ''),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyles.body
                                      .copyWith(color: AppColors.primeColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.all(5.0),
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: [
                              for (var i = 0;
                                  i < mProduct.products!.length;
                                  i++) ...[
                                SizedBox(
                                  width: 130,
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
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: Row(
                                    children: [
                                      PriceTag(
                                          mProduct.price!.offerPrice.toString(),
                                          mProduct.price!.actualPrice
                                              .toString()),
                                      const Spacer(),
                                      addToCartButton(multiprodController,
                                          mProduct, context)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 5, top: 5),
                      child: DiscountTag(price: mProduct.price!))
                ],
              );
            },
          ),
        );
      }),
    );
  }

  Widget multiProductListing(
      MultiProductController multiprodController, BuildContext context) {
    return SizedBox(
      height: 230,
      child: Obx(() {
        if (multiprodController.multiProd.isNotEmpty) {
          multiprodController.multiProd.shuffle();
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: multiprodController.multiProd.length,
          itemBuilder: (_, index) {
            return multiProductTile(multiprodController,
                multiprodController.multiProd[index], context);
          },
        );
      }),
    );
  }

  Widget multiProductTile(MultiProductController multiprodController,
      Multi multiProd, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: AppColors.white,
      child: Stack(
        children: [
          Column(
            children: [
              Stack(alignment: Alignment.bottomLeft, children: [
                GestureDetector(
                  onTap: () {
                    print('tapped the row');
                    showModalBottomSheet<void>(
                      // context and builder are
                      // required properties in this widget
                      context: context,
                      useRootNavigator: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)),
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      elevation: 3,
                      builder: (context) {
                        return DealBottomDrawer(
                          multiProd.products,
                          multiProd.id,
                          currenttypeName,
                          multiProd.price,
                          multiProd.constraint,
                          multiProd.name,
                          'MULTIPRODUCT',
                        );
                      },
                    );
                  },
                  child: ImageBox(
                    multiProd.displayImageId!,
                    width: MediaQuery.of(context).size.width * .4,
                    fit: BoxFit.cover,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.fromLTRB(0, 2, 5, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Text(
                          (multiProd.name!.defaultText!.text ?? ''),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyles.body
                              .copyWith(color: AppColors.primeColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '(${multiProd.products!.length} Products) ',
                    style: TextStyles.body.copyWith(color: AppColors.grey),
                  ),
                  // Text(
                  //   '${multiProd.name!.defaultText!.text}',
                  //   style: TextStyles.titleFont
                  //       .copyWith(color: AppColors.primeColor),
                  //   textAlign: TextAlign.left,
                  // ),
                ],
              ),
              Row(children: [
                PriceTag(multiProd.price!.offerPrice.toString(),
                    multiProd.price!.actualPrice.toString()),
                const SizedBox(
                  width: 10,
                ),
                addToCartButton(multiprodController, multiProd, context),
              ])
            ],
          ),
          Container(
              margin: const EdgeInsets.only(top: 5),
              child: DiscountTag(price: multiProd.price!))
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
            child: AddToCartButtons(
              hideAdd: cartController.checkProductInCart(multiProd.id, ''),
              onDecrease: () async {
                stateController.showLoader.value = true;
                if (stateController.isLogin.value) {
                  var valid = false;
                  var msg = 'Something went wrong!';

                  var data = await multiprodController.checkValidDeal(
                      multiProd.id!, 'negative', multiProd.id!);
                  valid = !data['error'];
                  msg = data['msg'];
                  if (valid) {
                    await cartController.addToCart(
                        multiProd.id!,
                        'MULTIPRODUCT',
                        (-(multiProd.constraint?.minimumOrder ?? 1)) ?? -1,
                        multiProd.price,
                        null,
                        multiProd.products,
                        null,
                        multiProd.constraint,
                        null,
                        mutliProductName: multiProd.name!.defaultText!.text!,
                        imageId: multiProd.displayImageId);
                  } else {
                    stateController.showLoader.value = false;
                    Navigator.of(context).pop();
                    snackBarClass.showToast(context, msg);
                  }
                } else {
                  stateController.showLoader.value = false;
                  stateController.setCurrentTab(3);
                  snackBarClass.showToast(context, 'Please Login to proceed!!');
                }
              },
              quantity: cartController.getCurrentQuantity(multiProd.id, ''),
              onIncrease: () async {
                stateController.showLoader.value = true;
                if (stateController.isLogin.value) {
                  var valid = false;
                  var msg = 'Something went wrong!';

                  var data = await multiprodController.checkValidDeal(
                      multiProd.id!, 'positive', multiProd.id!);
                  valid = !data['error'];
                  msg = data['msg'];
                  if (valid) {
                    await cartController.addToCart(
                        multiProd.id!,
                        'MULTIPRODUCT',
                        multiProd.constraint!.minimumOrder ?? 1,
                        multiProd.price,
                        null,
                        multiProd.products,
                        null,
                        multiProd.constraint,
                        null,
                        mutliProductName: multiProd.name!.defaultText!.text!,
                        imageId: multiProd.displayImageId);
                  } else {
                    snackBarClass.showToast(context, msg);
                  }
                  stateController.showLoader.value = false;
                } else {
                  stateController.showLoader.value = false;
                  stateController.setCurrentTab(3);
                  snackBarClass.showToast(context, 'Please Login to proceed!!');
                }
              },
              onAdd: () async {
                stateController.showLoader.value = true;
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
                      await cartController.addToCart(
                          multiProd.id!,
                          'MULTIPRODUCT',
                          multiProd.constraint!.minimumOrder ?? 1,
                          multiProd.price,
                          null,
                          multiProd.products,
                          null,
                          multiProd.constraint,
                          null,
                          mutliProductName: multiProd.name!.defaultText!.text!,
                          imageId: multiProd.displayImageId);
                      stateController.showLoader.value = false;
                    } else {
                      stateController.showLoader.value = false;
                      Navigator.of(context).pop();
                      snackBarClass.showToast(context, msg);
                    }
                  } else {
                    stateController.setCurrentTab(4);
                    // ignore: use_build_context_synchronously
                    snackBarClass.showToast(
                        context, 'Your profile is Inactive!!');
                  }
                } else {
                  stateController.setCurrentTab(3);
                  snackBarClass.showToast(context, 'Please Login to proceed!!');
                }
                stateController.showLoader.value = false;
              },
            ),
          ),
        );
      },
    );
  }
}
