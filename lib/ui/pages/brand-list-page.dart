import 'package:amber_bird/controller/brand-controller.dart';
import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/deal-controller.dart';
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
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/bootom-drawer/deal-bottom-drawer.dart';
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

class BrandListPage extends StatelessWidget {
  final BrandController brandController =
      ControllerGenerator.create(BrandController as GetxController);
  final CartController cartController = Get.find();
  final Controller stateController = Get.find();
  final WishlistController wishlistController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SizedBox(
              height: 75,
              child: brandController.brandList.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: brandController.brandList.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  brandController.selectedBrandTab.value =
                                      brandController.brandList[index].id ?? '';
                                },
                                child: ImageBox(
                                  brandController.brandList[index].image!,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              Obx(() => Center(
                                    child: FitText(
                                      brandController.brandList[index].text!,
                                      style: (brandController
                                                  .selectedBrandTab.value ==
                                              brandController
                                                  .brandList[index].id)
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
          showResults(brandController, context),
        ],
      );
    });
  }

  Widget showResults(BrandController brandController, BuildContext context) {
    if (brandController.isLoading.value) {
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

    return productList(brandController, context);
  }

  Widget productList(BrandController brandController, BuildContext context) {
    return Expanded(
      child: brandController.productList.length > 0
          ? MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: brandController.productList.length,
              itemBuilder: (_, index) {
                ProductSummary product = brandController.productList[index];
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
}
