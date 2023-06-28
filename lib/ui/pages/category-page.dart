import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/multi-product-controller.dart';
import 'package:amber_bird/controller/product-guide-row-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/ui/widget/discount-tag.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/ui/widget/product-card-scoin.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/ui/widget/product-guide-card.dart';
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
  ProductGuideController productGuideController = ControllerGenerator.create(
      ProductGuideController(),
      tag: 'productGuideController');

  CategoryPage() {
    megaMenuController = ControllerGenerator.create(MegaMenuController(),
        tag: 'megaMenuController');
    if (productGuideController.productGuides.isNotEmpty) {
      productGuideController.productGuides.shuffle();
    }
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
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 70,
              child: megaMenuController.mainTabs.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: megaMenuController.mainTabs.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
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
                                          ? TextStyles.body.copyWith(
                                              color: AppColors.primeColor)
                                          : TextStyles.body
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
          const Divider(),
          megaMenuController.subMenuList.isNotEmpty
              ? SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: megaMenuController.subMenuList.length,
                    itemBuilder: (_, index) {
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
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
                              () => Card(
                                elevation: 0,
                                color:
                                    (megaMenuController.selectedSubMenu.value ==
                                            megaMenuController
                                                .subMenuList[index].id)
                                        ? AppColors.primeColor
                                        : AppColors.commonBgColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(
                                        color: (megaMenuController
                                                    .selectedSubMenu.value ==
                                                megaMenuController
                                                    .subMenuList[index].id)
                                            ? AppColors.primeColor
                                            : AppColors.commonBgColor)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4.0, 2, 4, 2),
                                  child: Text(
                                      megaMenuController
                                          .subMenuList[index].text!,
                                      style: (megaMenuController
                                                  .selectedSubMenu.value ==
                                              megaMenuController
                                                  .subMenuList[index].id)
                                          ? TextStyles.body
                                              .copyWith(color: AppColors.white)
                                          : TextStyles.body),
                                ),
                              ),
                            ),
                          ),
                        ],
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
      case 'MSD':
        return _ProductList(megaMenuController, context, 'MSD');
      case 'TAGS_PRODUCT':
        return _ProductList(megaMenuController, context, 'TAGS_PRODUCT');
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

  Widget _ProductGuideList(MegaMenuController megaMenuController,
      BuildContext context, String type) {
    return Obx(
      () => Expanded(
        child: productGuideController.productGuides.isNotEmpty
            ? MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: productGuideController.productGuides.length,
                itemBuilder: (_, index) {
                  return ProductGuideCard(
                      productGuideController.productGuides[index]);
                })
            : SizedBox(),
      ),
    );
  }

  Widget _ProductList(MegaMenuController megaMenuController,
      BuildContext context, String type) {
    return Expanded(
      child: megaMenuController.productList.isNotEmpty
          ? MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: megaMenuController.productList.length,
              itemBuilder: (_, index) {
                ProductSummary product = megaMenuController.productList[index];
                return ProductCard(
                  fixedHeight: false,
                  product,
                  product.id,
                  type,
                  product.varient!.price,
                  RuleConfig(),
                  Constraint(),
                );
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
                  fixedHeight: false,
                  product,
                  product.id,
                  'SCOIN',
                  product.varient!.price,
                  RuleConfig(),
                  Constraint(),
                );
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
    if (megaMenuController.selectedSubMenu.value == 'CENTS')
      return _ProductList(megaMenuController, context, 'CENTS');
    else if (megaMenuController.selectedSubMenu.value == 'RESTOCKED')
      return _ProductList(megaMenuController, context, 'RESTOCKED');
    else
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
                    return SizedBox(
                      width: 150,
                      child: Stack(
                        children: [
                          ProductCard(
                              fixedHeight: false,
                              dealProduct.product,
                              dealProduct.id,
                              megaMenuController.selectedParentTab.value,
                              dealProduct.dealPrice,
                              dealProduct.ruleConfig,
                              dealProduct.constraint),
                          Positioned(
                            top: 0,
                            child: DiscountTag(
                              price: dealProduct.dealPrice!,
                            ),
                          ),
                        ],
                      ),
                    );
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
    if (megaMenuController.selectedSubMenu.value == 'THEMES')
      return _ProductGuideList(megaMenuController, context, 'THEMES');
    else
      return Expanded(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: megaMenuController.multiProd.length,
          shrinkWrap: true,
          itemBuilder: (_, index) {
            Multi mProduct = megaMenuController.multiProd[index];
            num totalNumberOfProducts = 0;
            mProduct.products!.forEach(
              (element) {
                totalNumberOfProducts =
                    totalNumberOfProducts + element.defaultPurchaseCount!;
              },
            );
            return SizedBox(
              height: 370,
              child: Card(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        ImageBox(
                          mProduct.displayImageId != null &&
                                  mProduct.displayImageId!.length > 3
                              ? mProduct.displayImageId!
                              : 'd5e438b9-6eee-4214-b1bd- ',
                          height: 110,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                        ),
                        Card(
                          margin: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                      height: 180,
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
                                    fixedHeight: false,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            totalNumberOfProducts > 2
                                ? Row(
                                    children: [
                                      Text(
                                        ' ${totalNumberOfProducts} Products',
                                        style: TextStyles.bodyFont.copyWith(
                                            color: AppColors.primeColor),
                                      )
                                    ],
                                  )
                                : const SizedBox(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1,
                              child: Row(
                                children: [
                                  PriceTag(
                                      mProduct.price!.offerPrice.toString(),
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
                                                padding:
                                                    const EdgeInsets.all(8),
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
                                                      await cartController.addToCart(
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
                                                padding:
                                                    const EdgeInsets.all(8),
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
                                                      await cartController
                                                          .addToCart(
                                                              mProduct.id!,
                                                              megaMenuController
                                                                  .selectedParentTab
                                                                  .value,
                                                              1,
                                                              mProduct.price!,
                                                              null,
                                                              mProduct.products,
                                                              null,
                                                              mProduct
                                                                  .constraint,
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
                                                        stateController
                                                            .showLoader
                                                            .value = true;
                                                        bool isCheckedActivate =
                                                            await stateController
                                                                .getUserIsActive();
                                                        if (isCheckedActivate) {
                                                          // if (stateController.isActivate.value) {
                                                          await cartController.addToCart(
                                                              mProduct.id!,
                                                              megaMenuController
                                                                  .selectedParentTab
                                                                  .value,
                                                              1,
                                                              mProduct.price!,
                                                              null,
                                                              mProduct.products,
                                                              null,
                                                              mProduct
                                                                  .constraint,
                                                              null);
                                                        } else {
                                                          // Navigator.of(context).pop();
                                                          // ignore: use_build_context_synchronously
                                                          snackBarClass.showToast(
                                                              context,
                                                              'Your profile is not active yet');
                                                        }
                                                        stateController
                                                            .showLoader
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
