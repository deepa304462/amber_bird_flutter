import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/category-controller.dart';
import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/element/snackbar.dart';
import 'package:amber_bird/ui/widget/bootom-drawer/deal-bottom-drawer.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPage extends StatelessWidget {
  bool isLoading = false;

  final MegaMenuController megaMenuController = Get.put(MegaMenuController());
  final CartController cartController = Get.find();
  final Controller stateController = Get.find();
  final WishlistController wishlistController = Get.find();

  Widget _productList(
      MegaMenuController categoryController, BuildContext context) {
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
                                currentProduct.images!.isNotEmpty
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
      MegaMenuController categoryController, BuildContext context) {
    return GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 6 / 8, crossAxisSpacing: 10),
        scrollDirection: Axis.vertical,
        itemCount: categoryController.productList.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          var currentProduct = categoryController.productList[index];
          if (currentProduct.varient != null) {
            return ProductCard(currentProduct, currentProduct.id, 'CATEGORY',
                currentProduct.varient!.price!);
          } else {
            return const SizedBox();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                height: 70,
                child: megaMenuController.mainTabs.isNotEmpty
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
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
                                      child: Text(
                                        megaMenuController
                                            .mainTabs[index].text!,
                                        style: (megaMenuController
                                                    .selectedParentTab.value ==
                                                megaMenuController
                                                    .mainTabs[index].id)
                                            ? TextStyles.headingFontGray
                                                .copyWith(
                                                    color: AppColors.primeColor)
                                            : TextStyles.headingFontGray,
                                      ),
                                    ))
                              ],
                            ),
                          );
                        },
                      )
                    : const SizedBox(),
              ),
            );
          },
        ),
        Obx(() => megaMenuController.subMenuList.isNotEmpty
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
                                      ? TextStyles.titleGreen
                                      : TextStyles.title),
                            ),
                          ),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              megaMenuController.selectedSubMenu.value =
                                  megaMenuController.subMenuList[index].id ??
                                      '';
                            },
                            child: Image.network(
                                '${ClientService.cdnUrl}${megaMenuController.subMenuList[index].image}',
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
        Obx(
          () {
            return showResults(megaMenuController, context);
          },
        )
      ],
    );
  }

  Widget showResults(
      MegaMenuController megaMenuController, BuildContext context) {
    switch (megaMenuController.selectedType.value) {
      case 'DEAL':
        return _dealGrid(megaMenuController, context);
      case 'MULTI':
        return _multiProductList(megaMenuController, context);
      default:
        return categoryProducts(megaMenuController, context);
    }
  }

  Widget categoryProducts(
      MegaMenuController megaMenuController, BuildContext context) {
    return Column(
      children: [_productGrid(megaMenuController, context)],
    );
  }

  Widget _dealGrid(
      MegaMenuController megaMenuController, BuildContext context) {
    return GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 6 / 8, crossAxisSpacing: 10),
        scrollDirection: Axis.vertical,
        itemCount: megaMenuController.dealProductList.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          DealProduct dealProduct = megaMenuController.dealProductList[0];
          if (dealProduct.product != null) {
            return ProductCard(dealProduct.product, dealProduct.product!.id,
                'DEAL', dealProduct.product!.varient!.price!);
          } else {
            return const SizedBox();
          }
        });
  }

  Widget _multiProductList(
      MegaMenuController megaMenuController, BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: megaMenuController.multiProd.length,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          Multi mProduct = megaMenuController.multiProd[index];
          // var curProduct = dProduct!.product;
          return Card(
            child: Column(
              children: [
                Image.network(
                  '${ClientService.cdnUrl}${mProduct.displayImageId}',
                  height: 80,
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  height: 160,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        for (var i = 0; i < mProduct.products!.length; i++) ...[
                          SizedBox(
                            width: 150,
                            child: ProductCard(
                                mProduct.products![i],
                                mProduct.products![i].id,
                                'MULTIPRODUCT',
                                mProduct.products![i].varient!.price!),
                          )
                        ]
                      ]),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Container(
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
                          mProduct!.name!.defaultText!.text ?? '',
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
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PriceTag(mProduct.price!.offerPrice.toString(),
                                  mProduct!.price!.actualPrice.toString()),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Colors.red.shade900,
                                radius: 20,
                                child: IconButton(
                                  padding: const EdgeInsets.all(1),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                      // context and builder are
                                      // required properties in this widget
                                      context: context,
                                      useRootNavigator: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13)),
                                      backgroundColor: Colors.white,
                                      isScrollControlled: true,
                                      elevation: 3,
                                      builder: (context) {
                                        // return _bottomSheetAddToCart(product, context);
                                        return DealBottomDrawer(
                                            mProduct!.products,
                                            mProduct.id,
                                            'MULTIPRODUCT',
                                            mProduct.price,
                                            mProduct.name);
                                      },
                                    );
                                    // cartController.addToCart(product!, refId!, addedFrom!);
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
