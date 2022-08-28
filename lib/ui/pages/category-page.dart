import 'dart:developer';

import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/category-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/open-container/open_container_product.dart';
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
        height: MediaQuery.of(context).size.height * .45,
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
                    padding: EdgeInsets.all(7),
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
                                    '${ClientService.cdnUrl}${currentProduct!.category!.logoId}',
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '${currentProduct!.category!.name!.defaultText!.text}',
                                    style: TextStyles.subHeadingFont,
                                  ),
                                ]),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        currentProduct.varients!.isNotEmpty
                            ? SizedBox(
                                height: 50,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: currentProduct.varients!.length,
                                  itemBuilder: (_, indexVarient) {
                                    var currentVariant =
                                        currentProduct.varients![indexVarient];
                                    return Card(
                                      color: Colors.white,
                                      margin: const EdgeInsets.all(5),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                              '${currentVariant!.weight!} ${currentVariant!.unit!}'),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const SizedBox()
                      
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
        height: MediaQuery.of(context).size.height * .45,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 6/7,
                crossAxisSpacing: 10),
            scrollDirection: Axis.vertical,
            itemCount: categoryController.productList.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              var currentProduct = categoryController.productList[index];
              return  Padding(
                  padding: const EdgeInsetsDirectional.all(5),
                  child: ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(15.0),
                    child: GridTile(
                      header: _gridProductHeader(currentProduct!),
                      child: _gridProductBody(currentProduct!, context),
                    ),
                  ),
                 
              );
            }));
  }

  Widget _gridProductHeader(Product currentProduct) {
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

  Widget _gridProductBody(Product currentProduct, BuildContext context) {
    return Column(
      children: [
        OpenContainerProduct(
          product: currentProduct,
          refId: currentProduct.id,
          addedFrom: 'DIRECTLY',
          child: currentProduct!.images!.length > 0
              ? Image.network(
                  '${ClientService.cdnUrl}${currentProduct!.images![0]}',
                  height: 120,
                  // fit: BoxFit.fill
                  // 
                  )
              :const SizedBox(
                  child: Text('Empty Iamge'),
                ),
        ),
        _gridProductFooter(currentProduct, context)
      ],
    );
  }

  Widget _gridProductFooter(Product product, BuildContext context) {
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
            product!.name!.defaultText!.text ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          product.varients!.isNotEmpty
              ? Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product.varients![0]!.price!.offerPrice}",
                      style: TextStyles.bodyFont,
                    ),
                    const SizedBox(width: 3),
                    Visibility(
                      visible: product!.varients![0]!.price!.actualPrice != null
                          ? true
                          : false,
                      child: Text(
                        "\$${product!.varients![0]!.price!.actualPrice.toString()}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      padding: const EdgeInsets.all(1),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        // showModalBottomSheet<void>(
                        //   // context and builder are
                        //   // required properties in this widget
                        //   context: context,
                        //   elevation: 3,
                        //   builder: (context) {
                        //     // return _bottomSheetAddToCart(product, context);
                        //     return DealBottomDrawer(
                        //         product, product.id, 'DIRECTLY', dealPrice);
                        //   },
                        // );
                        // cartController.addToCart(product!, refId!, addedFrom!);
                      },
                      icon: Icon(Icons.add_circle_outline,
                          color: AppColors.primeColor),
                    ),
                  ],
                )
              : SizedBox(),
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
                                  categoryController.categoryList[index];
                              categoryController.getSubCategory(
                                  categoryController.categoryList[index].id);

                              categoryController.selectedSubCatergory.value =
                                  ProductCategory();
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
                                              .selectedCatergory.value.id ==
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
                  itemCount: categoryController.subCategoryList.length,
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
                              categoryController.selectedSubCatergory.value =
                                  categoryController.subCategoryList[index];
                              categoryController.getProductList();
                            },
                            child: Obx(
                              () => Text(
                                  categoryController.subCategoryList[index]
                                          .name!.defaultText!.text ??
                                      '',
                                  style: (categoryController
                                              .selectedSubCatergory.value.id ==
                                          categoryController
                                              .subCategoryList[index].id)
                                      ? TextStyles.titleGreen
                                      : TextStyles.title),
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              categoryController.selectedSubCatergory.value =
                                  categoryController.subCategoryList[index];
                            },
                            child: Image.network(
                                '${ClientService.cdnUrl}${categoryController.subCategoryList[index].logoId}',
                                width: 25,
                                height: 25,
                                fit: BoxFit.fill),
                          ),
                        ],
                      ),
                    );
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
