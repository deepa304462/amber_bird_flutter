import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/ui/widget/bootom-drawer/deal-bottom-drawer.dart';
import 'package:amber_bird/ui/widget/fit-text.dart';
import 'package:amber_bird/ui/widget/image-box.dart';
import 'package:amber_bird/ui/widget/price-tag.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/ui/widget/shimmer-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CategoryPage extends StatelessWidget {
  final MegaMenuController megaMenuController = Get.find();
  final CartController cartController = Get.find();
  final Controller stateController = Get.find();
  final WishlistController wishlistController = Get.find();

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
                                          ? TextStyles.headingFontGray.copyWith(
                                              color: AppColors.primeColor)
                                          : TextStyles.headingFontGray,
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
                                CircleAvatar(
                                  backgroundColor: AppColors.primeColor,
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
                                            mProduct.products,
                                            mProduct.id,
                                            'CATEGORY',
                                            mProduct.price,
                                            mProduct.constraint,
                                            mProduct.name,
                                            'MULTIPRODUCT',
                                          );
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
            ),
          );
        },
      ),
    );
  }
}
