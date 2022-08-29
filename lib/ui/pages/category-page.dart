import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/category-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/open-container/open_container_product.dart';
import 'package:amber_bird/ui/widget/open-container/open_container_wrapper.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPage extends StatelessWidget {
  bool isLoading = false;

  final CategoryController categoryController = Get.find();
  final CartController cartController = Get.find();
  final Controller stateController = Get.find();
  final WishlistController wishlistController = Get.find();

  Widget _productList(
      CategoryController categoryController, BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * .42,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: categoryController.productList.length,
            itemBuilder: (_, index) {
              var currentProduct = categoryController.productList[index];
              return Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: 220,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            currentProduct.images!.length > 0
                                ? Image.network(
                                    '${ClientService.cdnUrl}${currentProduct.images![0]}',
                                    width: 100,
                                    fit: BoxFit.fill)
                                : const SizedBox(child: Text('Empty image')),
                            Column(
                              children: [
                                Text(
                                  currentProduct.name!.defaultText!.text!,
                                  style: TextStyles.headingFont,
                                ),
                                Row(children: [
                                  Image.network(
                                    '${ClientService.cdnUrl}${currentProduct.category!.logoId}',
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${currentProduct.category!.name!.defaultText!.text}',
                                    style: TextStyles.subHeadingFont,
                                  ),
                                ]),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        currentProduct.varient != null
                            ? Obx(() => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            '\$${currentProduct.varient!.price!.offerPrice!}'),
                                        Text(
                                          '\$${currentProduct.varient!.price!.actualPrice!}',
                                          style: TextStyles.prieLinThroughStyle,
                                        ),
                                      ],
                                    ),
                                    cartController.checkProductInCart(
                                            currentProduct.id)
                                        ? Row(
                                            children: [
                                              IconButton(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () {
                                                  if (stateController
                                                      .isLogin.value) {
                                                    cartController.addToCart(
                                                        currentProduct,
                                                        currentProduct.id!,
                                                        'CATEGORY',
                                                        -1);
                                                  } else {
                                                    stateController
                                                        .setCurrentTab(3);
                                                    var showToast =
                                                        snackBarClass.showToast(
                                                            context,
                                                            'Please Login to preoceed');
                                                  }
                                                  // cController.addToCart(p, refId!, addedFrom!, -1);
                                                },
                                                icon: const Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.black),
                                              ),
                                              Text(cartController
                                                  .getCurrentQuantity(
                                                      currentProduct.id)
                                                  .toString()),
                                              IconButton(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed: () {
                                                  if (stateController
                                                      .isLogin.value) {
                                                    cartController.addToCart(
                                                        currentProduct,
                                                        currentProduct.id!,
                                                        'CATEGORY',
                                                        1);
                                                  } else {
                                                    stateController
                                                        .setCurrentTab(3);
                                                    var showToast =
                                                        snackBarClass.showToast(
                                                            context,
                                                            'Please Login to preoceed');
                                                  }
                                                  // cController.addToCart(p, refId!, addedFrom!, 1);
                                                },
                                                icon: const Icon(
                                                    Icons.add_circle_outline,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          )
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primeColor,
                                                // padding: const EdgeInsets.symmetric(
                                                //     horizontal: 50, vertical: 15),
                                                textStyle:
                                                    TextStyles.bodyWhite),
                                            onPressed: currentProduct
                                                        .varient!.currentStock >
                                                    0
                                                ? () {
                                                    if (stateController
                                                        .isLogin.value) {
                                                      cartController.addToCart(
                                                          currentProduct,
                                                          currentProduct.id!,
                                                          'CATEGORY',
                                                          1);
                                                    } else {
                                                      stateController
                                                          .setCurrentTab(3);
                                                      var showToast =
                                                          snackBarClass.showToast(
                                                              context,
                                                              'Please Login to preoceed');
                                                    }
                                                  }
                                                : () {
                                                    print(
                                                        'nnnnn${stateController.isLogin.value}');
                                                    if (stateController
                                                        .isLogin.value) {
                                                      cartController.addToCart(
                                                          currentProduct,
                                                          currentProduct.id!,
                                                          'CATEGORY',
                                                          1);
                                                    } else {
                                                      stateController
                                                          .setCurrentTab(3);
                                                      var showToast =
                                                          snackBarClass.showToast(
                                                              context,
                                                              'Please Login to preoceed');
                                                    }
                                                  },
                                            child: Text("Add to cart",
                                                style:
                                                    TextStyles.addTocartText),
                                          ),
                                  ],
                                ))
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  Widget _productGrid(
      CategoryController categoryController, BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * .42,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 6 / 8,
                crossAxisSpacing: 10),
            scrollDirection: Axis.vertical,
            itemCount: categoryController.productList.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              var currentProduct = categoryController.productList[index];
              if (currentProduct.varient != null) {
                return ProductCard(currentProduct, currentProduct.id,
                    'CATEGORY', currentProduct.varient!.price!);
              } else {
                return SizedBox();
              }
            }));
  }

  Widget _gridProductHeader(ProductSummary currentProduct) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: true,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.white),
              width: 80,
              height: 30,
              alignment: Alignment.center,
              child: const Text(
                "2hrs left",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          // GetX<WishlistController>(builder: (wController) {
          //   return
          Obx(() {
            print(wishlistController.wishlistProducts);
            return IconButton(
              icon: Icon(
                Icons.favorite,
                color:
                    wishlistController.checkIfProductWishlist(currentProduct.id)
                        ? Colors.redAccent
                        : const Color(0xFFA6A3A0),
              ),
              onPressed: () => {
                wishlistController.addToWishlist(
                    currentProduct.id, currentProduct)
              },
            );
          }),

          // }),
        ],
      ),
    );
  }

  Widget _gridProductBody(ProductSummary currentProduct, BuildContext context) {
    return Column(
      children: [
        OpenContainerWrapper(
          product: currentProduct,
          refId: currentProduct.id,
          addedFrom: 'DIRECTLY',
          child: currentProduct.images!.length > 0
              ? Image.network(
                  '${ClientService.cdnUrl}${currentProduct.images![0]}',
                  height: 120,
                  // fit: BoxFit.fill
                  //
                )
              : const SizedBox(
                  child: Text('Empty Iamge'),
                ),
        ),
        _gridProductFooter(currentProduct, context)
      ],
    );
  }

  Widget _gridProductFooter(ProductSummary product, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      // margin: const EdgeInsets.only(left: 3, right: 3),
      height: 55,
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
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          // product.varients!.isNotEmpty
          //     ? Row(
          //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             "\$${product.varients![0]!.price!.offerPrice}",
          //             style: TextStyles.bodyFont,
          //           ),
          //           const SizedBox(width: 3),
          //           Visibility(
          //             visible: product!.varients![0]!.price!.actualPrice != null
          //                 ? true
          //                 : false,
          //             child: Text(
          //               "\$${product!.varients![0]!.price!.actualPrice.toString()}",
          //               style: const TextStyle(
          //                 decoration: TextDecoration.lineThrough,
          //                 color: Colors.grey,
          //                 fontWeight: FontWeight.w500,
          //               ),
          //             ),
          //           ),
          //           const Spacer(),
          //           IconButton(
          //             padding: const EdgeInsets.all(1),
          //             constraints: const BoxConstraints(),
          //             onPressed: () {
          //               // showModalBottomSheet<void>(
          //               //   // context and builder are
          //               //   // required properties in this widget
          //               //   context: context,
          //               //   elevation: 3,
          //               //   builder: (context) {
          //               //     // return _bottomSheetAddToCart(product, context);
          //               //     return DealBottomDrawer(
          //               //         product, product.id, 'DIRECTLY', dealPrice);
          //               //   },
          //               // );
          //               // cartController.addToCart(product!, refId!, addedFrom!);
          //             },
          //             icon: Icon(Icons.add_circle_outline,
          //                 color: AppColors.primeColor),
          //           ),
          //         ],
          //       )
          //     : SizedBox(),
        ],
      ),
    );
  }

  Widget _staticSubCategory() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColors.lightGrey),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              categoryController.selectedSubCatergory.value = 'all';
              categoryController.getProductList();
            },
            child: Obx(
              () => Text('All',
                  style:
                      (categoryController.selectedSubCatergory.value == 'all')
                          ? TextStyles.titleGreen
                          : TextStyles.title),
            ),
          ),
          const SizedBox(width: 5),
          InkWell(
            onTap: () {
              categoryController.selectedSubCatergory.value = 'all';
            },
            child: const Icon(Icons.all_out, size: 25),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Categories",
                style: TextStyles.headingFont,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: categoryController.categoryList.isNotEmpty
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryController.categoryList.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              categoryController.selectedCatergory.value =
                                  categoryController.categoryList[index].id ??
                                      '';
                              categoryController.getSubCategory(
                                  categoryController.categoryList[index].id);

                              categoryController.selectedSubCatergory.value =
                                  'all';
                              categoryController.getProductList();
                            },
                            child: Image.network(
                                '${ClientService.cdnUrl}${categoryController.categoryList[index].logoId}',
                                width: 80,
                                height: 80,
                                fit: BoxFit.fill),
                          ),
                          Obx(() => Center(
                                child: Text(
                                  categoryController.categoryList[index].name!
                                          .defaultText!.text ??
                                      '',
                                  style: (categoryController
                                              .selectedCatergory.value ==
                                          categoryController
                                              .categoryList[index].id)
                                      ? TextStyles.bodyGreen
                                      : TextStyles.bodySm,
                                ),
                              ))
                        ],
                      ),
                    );
                  },
                )
              : const SizedBox(),
        ),
        Obx(() => categoryController.subCategoryList.isNotEmpty
            ? SizedBox(
                height: 58,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryController.subCategoryList.length + 1,
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return _staticSubCategory();
                    } else {
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
                                categoryController.selectedSubCatergory.value =
                                    categoryController
                                            .subCategoryList[index - 1].id ??
                                        '';
                                categoryController.getProductList();
                              },
                              child: Obx(
                                () => Text(
                                    categoryController
                                            .subCategoryList[index - 1]
                                            .name!
                                            .defaultText!
                                            .text ??
                                        '',
                                    style: (categoryController
                                                .selectedSubCatergory.value ==
                                            categoryController
                                                .subCategoryList[index - 1].id)
                                        ? TextStyles.titleGreen
                                        : TextStyles.title),
                              ),
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () {
                                categoryController.selectedSubCatergory.value =
                                    categoryController
                                            .subCategoryList[index - 1].id ??
                                        '';
                              },
                              child: Image.network(
                                  '${ClientService.cdnUrl}${categoryController.subCategoryList[index - 1].logoId}',
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.fill),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              )
            : const SizedBox()),
        const Divider(),
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    categoryController.isList.value = true;
                  },
                  icon: Icon(Icons.list)),
              IconButton(
                  onPressed: () {
                    categoryController.isList.value = false;
                  },
                  icon: Icon(Icons.grid_4x4_outlined))
            ],
          ),
        ),
        const Divider(),
        Obx(() => categoryController.productList.isNotEmpty
            ? (categoryController.isList.isTrue
                ? _productList(categoryController, context)
                : _productGrid(categoryController, context))
            : const SizedBox())
      ],
    );
  }
}
