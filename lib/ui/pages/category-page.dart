import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/multi-product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/ui/widget/product-card-scoin.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/ui/widget/shimmer-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../helpers/controller-generator.dart';

class CategoryPage extends StatelessWidget {
  late MegaMenuController megaMenuController;
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  final Controller stateController = Get.find();
  final WishlistController wishlistController = Get.find();
  CategoryPage() {
    megaMenuController = ControllerGenerator.create(MegaMenuController(),
        tag: 'megaMenuController');
  }
  Widget _productGrid(
      MegaMenuController categoryController, BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: categoryController.productList.length,
      itemBuilder: (_, index) {
        var currentProduct = categoryController.productList[index];
        if (currentProduct.varient != null) {
          return ProductCard(currentProduct, currentProduct.id, 'CATEGORY',
              currentProduct.varient!.price!, null, null);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SizedBox(
              height: 75,
              child: megaMenuController.mainTabs.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: megaMenuController.mainTabs.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  megaMenuController.selectedParentTab.value =
                                      megaMenuController.mainTabs[index].id ??
                                          '';
                                  megaMenuController.getSubMenu(
                                      megaMenuController.mainTabs[index]);
                                },
                                child: ImageBox(
                                  megaMenuController.mainTabs[index].image!,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              Obx(() => Center(
                                    child: FitText(
                                      megaMenuController.mainTabs[index].text!,
                                      style: (megaMenuController
                                                  .selectedParentTab.value ==
                                              megaMenuController
                                                  .mainTabs[index].id)
                                          ? TextStyles.headingFont.copyWith(
                                              color: AppColors.primeColor)
                                          : TextStyles.headingFont
                                              .copyWith(color: AppColors.grey),
                                    ),
                                  ))
                            ],
                          ),
                        );
                      },
                    )
                  : Lottie.network(
                      'https://assets6.lottiefiles.com/packages/lf20_x62chJ.json',
                    ),
            ),
          ),
          megaMenuController.subMenuList.isNotEmpty
              ? SizedBox(
                  height: 58,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: megaMenuController.subMenuList.length,
                    itemBuilder: (_, index) {
                      return Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.lightGrey),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                megaMenuController.selectedSubMenu.value =
                                    megaMenuController.subMenuList[index].id ??
                                        '';
                                megaMenuController.getAllProducts(
                                    megaMenuController.subMenuList[index],
                                    GenericTab(
                                        id: megaMenuController
                                            .selectedParentTab.value,
                                        type: megaMenuController
                                            .selectedType.value));
                              },
                              child: Obx(
                                () => Text(
                                    megaMenuController.subMenuList[index].text!,
                                    style: (megaMenuController
                                                .selectedSubMenu.value ==
                                            megaMenuController
                                                .subMenuList[index].id)
                                        ? TextStyles.titleFont
                                            .copyWith(color: AppColors.green)
                                        : TextStyles.titleFont),
                              ),
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                megaMenuController.selectedSubMenu.value =
                                    megaMenuController.subMenuList[index].id ??
                                        '';
                              },
                              child: ImageBox(
                                '${megaMenuController.subMenuList[index].image}',
                                width: 25,
                                height: 25,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox(),
          showResults(megaMenuController, context),
        ],
      );
    });
  }

  Widget showResults(
      MegaMenuController megaMenuController, BuildContext context) {
    if (megaMenuController.isLoading.value) {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              ShimmerWidget(
                  heightOfTheRow: MediaQuery.of(context).size.width * .4,
                  radiusOfcell: 12,
                  widthOfCell: MediaQuery.of(context).size.width * .4),
              ShimmerWidget(
                  heightOfTheRow: MediaQuery.of(context).size.width * .4,
                  radiusOfcell: 12,
                  widthOfCell: MediaQuery.of(context).size.width * .4),
              ShimmerWidget(
                  heightOfTheRow: MediaQuery.of(context).size.width * .4,
                  radiusOfcell: 12,
                  widthOfCell: MediaQuery.of(context).size.width * .4),
              ShimmerWidget(
                  heightOfTheRow: MediaQuery.of(context).size.width * .4,
                  radiusOfcell: 12,
                  widthOfCell: MediaQuery.of(context).size.width * .4),
              ShimmerWidget(
                  heightOfTheRow: MediaQuery.of(context).size.width * .4,
                  radiusOfcell: 12,
                  widthOfCell: MediaQuery.of(context).size.width * .4),
            ],
          ),
        ),
      );
    }
    switch (megaMenuController.selectedType.value) {
      case 'DEAL':
        return _dealGrid(megaMenuController, context);
      case 'MULTI':
        return _multiProductList(megaMenuController, context);
      case 'SCOIN':
        return _scoinProductList(megaMenuController, context);
      default:
        return categoryProducts(megaMenuController, context);
    }
  }

  Widget categoryProducts(
      MegaMenuController megaMenuController, BuildContext context) {
    return Expanded(
      child: _productGrid(megaMenuController, context),
    );
  }

  Widget _scoinProductList(
      MegaMenuController megaMenuController, BuildContext context) {
    return Expanded(
      child: megaMenuController.productList.isNotEmpty
          ? MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: megaMenuController.productList.length,
              itemBuilder: (_, index) {
                ProductSummary product = megaMenuController.productList[index];
                return ProductCardScoin(
                  fixedHeight: true,
                  product,
                  product.id,
                  'SCOIN',
                  product.varient!.price,
                  RuleConfig(),
                  Constraint(),
                );
                // ProductCardScoin(
                //     dealProduct.product,
                //     dealProduct.product!.id,
                //     megaMenuController.selectedParentTab.value,
                //     dealProduct.product!.varient!.price!,
                //     dealProduct.ruleConfig,
                //     dealProduct.constraint);
              },
            )
          : Column(
              children: [
                Lottie.asset('assets/no-data.json',
                    width: MediaQuery.of(context).size.width * .5,
                    fit: BoxFit.contain),
                Expanded(
                  child: Text(
                    'No product available in this section',
                    style: TextStyles.bodyFont,
                  ),
                )
              ],
            ),
    );
  }

  Widget _dealGrid(
      MegaMenuController megaMenuController, BuildContext context) {
    return Expanded(
      child: megaMenuController.dealProductList.length > 0
          ? MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: megaMenuController.dealProductList.length,
              itemBuilder: (_, index) {
                DealProduct dealProduct =
                    megaMenuController.dealProductList[index];
                if (dealProduct.product != null) {
                  return ProductCard(
                      dealProduct.product,
                      dealProduct.product!.id,
                      megaMenuController.selectedParentTab.value,
                      dealProduct.product!.varient!.price!,
                      dealProduct.ruleConfig,
                      dealProduct.constraint);
                } else {
                  return const SizedBox();
                }
              },
            )
          : Column(
              children: [
                Lottie.asset('assets/no-data.json',
                    width: MediaQuery.of(context).size.width * .5,
                    fit: BoxFit.contain),
                Expanded(
                  child: Text(
                    'No product available in this section',
                    style: TextStyles.bodyFont,
                  ),
                )
              ],
            ),
    );
  }

  Widget _multiProductList(
      MegaMenuController megaMenuController, BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: megaMenuController.multiProd.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          Multi mProduct = megaMenuController.multiProd[index];
          return SizedBox(
            height: 320,
            child: Card(
              child: Column(
                children: [
                  ImageBox(
                    mProduct.displayImageId != null &&
                            mProduct.displayImageId!.length > 3
                        ? mProduct.displayImageId!
                        : 'd5e438b9-6eee-4214-b1bd-c15cd1f57f81',
                    height: 60,
                    width: MediaQuery.of(context).size.width,
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
                                  'MULTIPRODUCT',
                                  fixedHeight: true,
                                  mProduct.products![i].varient!.price!,
                                  null,
                                  null),
                            )
                          ]
                        ]),
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
                            width: MediaQuery.of(context).size.width * .8,
                            child: Row(
                              children: [
                                PriceTag(mProduct.price!.offerPrice.toString(),
                                    mProduct.price!.actualPrice.toString()),
                                const Spacer(),
                                Obx(() => cartController.checkProductInCart(
                                        mProduct.id, '')
                                    ? Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        color: AppColors.primeColor,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              padding: const EdgeInsets.all(8),
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: () async {
                                                stateController
                                                    .showLoader.value = true;
                                                if (stateController
                                                    .isLogin.value) {
                                                  var valid = false;
                                                  var msg =
                                                      'Something went wrong!';

                                                  if (Get.isRegistered<
                                                          MultiProductController>(
                                                      tag: megaMenuController
                                                          .selectedParentTab
                                                          .value)) {
                                                    var multiprodController = Get.find<
                                                            MultiProductController>(
                                                        tag: megaMenuController
                                                            .selectedParentTab
                                                            .value);
                                                    var data =
                                                        await multiprodController
                                                            .checkValidDeal(
                                                                mProduct.id!,
                                                                'negative',
                                                                mProduct.id!);
                                                    valid = !data['error'];
                                                    msg = data['msg'];
                                                  }
                                                  if (valid) {
                                                    cartController.addToCart(
                                                        mProduct.id!,
                                                        megaMenuController
                                                            .selectedParentTab
                                                            .value,
                                                        (-(mProduct.constraint
                                                                    ?.minimumOrder ??
                                                                1)) ??
                                                            -1,
                                                        mProduct.price,
                                                        null,
                                                        mProduct.products,
                                                        null,
                                                        mProduct.constraint,
                                                        null);
                                                  } else {
                                                    // ignore: use_build_context_synchronously
                                                    snackBarClass.showToast(
                                                        context, msg);
                                                  }
                                                } else {
                                                  stateController
                                                      .setCurrentTab(3);
                                                  // ignore: use_build_context_synchronously
                                                  snackBarClass.showToast(
                                                      context,
                                                      'Please Login to preoceed');
                                                }
                                                stateController
                                                    .showLoader.value = false;
                                              },
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                            Text(
                                              cartController
                                                  .getCurrentQuantity(
                                                      mProduct.id, '')
                                                  .toString(),
                                              style: TextStyles.titleFont,
                                            ),
                                            IconButton(
                                              padding: const EdgeInsets.all(8),
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: () async {
                                                stateController
                                                    .showLoader.value = true;
                                                if (stateController
                                                    .isLogin.value) {
                                                  var valid = false;
                                                  var msg =
                                                      'Something went wrong!';

                                                  if (Get.isRegistered<
                                                          MultiProductController>(
                                                      tag: megaMenuController
                                                          .selectedParentTab
                                                          .value)) {
                                                    var multiprodController = Get.find<
                                                            MultiProductController>(
                                                        tag: megaMenuController
                                                            .selectedParentTab
                                                            .value);

                                                    var data =
                                                        await multiprodController
                                                            .checkValidDeal(
                                                                mProduct.id!,
                                                                'positive',
                                                                mProduct.id!);

                                                    valid = !data['error'];
                                                    msg = data['msg'];
                                                  }
                                                  if (valid) {
                                                    cartController.addToCart(
                                                        mProduct.id!,
                                                        megaMenuController
                                                            .selectedParentTab
                                                            .value,
                                                        1,
                                                        mProduct.price!,
                                                        null,
                                                        mProduct.products,
                                                        null,
                                                        mProduct.constraint,
                                                        null);
                                                  } else {
                                                    stateController
                                                        .setCurrentTab(3);
                                                    // ignore: use_build_context_synchronously
                                                    snackBarClass.showToast(
                                                        context, msg);
                                                  }
                                                }
                                                stateController
                                                    .showLoader.value = false;
                                              },
                                              icon: Icon(
                                                Icons.add_circle_outline,
                                                color: AppColors.white,
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
                                          constraints: const BoxConstraints(),
                                          color: Colors.white,
                                          onPressed:
                                              stateController.isLogin.value
                                                  ? () async {
                                                      stateController.showLoader
                                                          .value = true;
                                                      bool isCheckedActivate =
                                                          await stateController
                                                              .getUserIsActive();
                                                      if (isCheckedActivate) {
                                                        // if (stateController.isActivate.value) {
                                                        cartController.addToCart(
                                                            mProduct.id!,
                                                            megaMenuController
                                                                .selectedParentTab
                                                                .value,
                                                            1,
                                                            mProduct.price!,
                                                            null,
                                                            mProduct.products,
                                                            null,
                                                            mProduct.constraint,
                                                            null);
                                                      } else {
                                                        // Navigator.of(context).pop();
                                                        // ignore: use_build_context_synchronously
                                                        snackBarClass.showToast(
                                                            context,
                                                            'Your profile is not active yet');
                                                      }
                                                      stateController.showLoader
                                                          .value = false;
                                                    }
                                                  : () {
                                                      stateController
                                                          .setCurrentTab(3);
                                                      snackBarClass.showToast(
                                                          context,
                                                          'Please Login to preoceed');
                                                    },
                                          icon: const Icon(
                                            Icons.add,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                // CircleAvatar(
                                //   backgroundColor: AppColors.primeColor,
                                //   radius: 20,
                                //   child: IconButton(
                                //     padding: const EdgeInsets.all(1),
                                //     constraints: const BoxConstraints(),
                                //     onPressed: () {
                                //       showModalBottomSheet<void>(
                                //         // context and builder are
                                //         // required properties in this widget
                                //         context: context,
                                //         useRootNavigator: true,
                                //         shape: RoundedRectangleBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(13)),
                                //         backgroundColor: Colors.white,
                                //         isScrollControlled: true,
                                //         elevation: 3,
                                //         builder: (context) {
                                //           return DealBottomDrawer(
                                //             mProduct.products,
                                //             mProduct.id,
                                //             'CATEGORY',
                                //             mProduct.price,
                                //             mProduct.constraint,
                                //             mProduct.name,
                                //             'MULTIPRODUCT',
                                //           );
                                //         },
                                //       );
                                //     },
                                //     icon: const Icon(
                                //       Icons.add,
                                //     ),

                                //   ),
                                // ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
