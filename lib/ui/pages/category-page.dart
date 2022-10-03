import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/category-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
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
                height: 200,
                width: double.maxFinite,
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                currentProduct.images!.length > 0
                                    ? Image.network(
                                        '${ClientService.cdnUrl}${currentProduct.images![0]}',
                                        width: 100,
                                        fit: BoxFit.fill)
                                    : const SizedBox(
                                        child: Text('Empty image')),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Obx(
                                    () => IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: wishlistController
                                                .checkIfProductWishlist(
                                                    currentProduct!.id)
                                            ? Colors.redAccent
                                            : AppColors.grey,
                                      ),
                                      onPressed: () => {
                                        wishlistController.addToWishlist(
                                            currentProduct!.id, currentProduct)
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                                        [currentProduct],
                                                        currentProduct.id!,
                                                        'CATEGORY',
                                                        -1,
                                                        currentProduct
                                                            .varient!.price);
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
                                                        [currentProduct],
                                                        currentProduct.id!,
                                                        'CATEGORY',
                                                        1,
                                                        currentProduct
                                                            .varient!.price);
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
                                                          [currentProduct],
                                                          currentProduct.id!,
                                                          'CATEGORY',
                                                          1,
                                                          currentProduct
                                                              .varient!.price);
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
                                                          [currentProduct],
                                                          currentProduct.id!,
                                                          'CATEGORY',
                                                          1,
                                                          currentProduct
                                                              .varient!.price);
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
                return const SizedBox();
              }
            }));
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
                  icon: const Icon(Icons.list)),
              IconButton(
                  onPressed: () {
                    categoryController.isList.value = false;
                  },
                  icon: const Icon(Icons.grid_4x4_outlined))
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
