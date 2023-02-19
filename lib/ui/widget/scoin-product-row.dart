import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/scoin-product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/ui/widget/product-card-scoin.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/ui/widget/view-more-widget.dart';
import 'package:amber_bird/utils/codehelp.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScoinProductRow extends StatelessWidget {
  bool isLoading = false;
  final Controller stateController = Get.find();
  final CartController cartController = Get.find();
  final WishlistController wishlistController = Get.find();
  Rx<Varient> activeVariant = Varient().obs;
  ScoinProductRow({super.key});

  @override
  Widget build(BuildContext context) {
    final ScoinProductController scoinController =
        Get.put(ScoinProductController());
    return Obx(() {
      if (scoinController.sCoinProd.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Member Special Deals",
                        style: TextStyles.titleLargeSemiBold,
                      ),
                      ViewMoreWidget(onTap: () {
                        MegaMenuController megaMenuController;
                        if (Get.isRegistered<MegaMenuController>()) {
                          megaMenuController = Get.find();
                        } else {
                          megaMenuController = Get.put(MegaMenuController());
                        }
                        // megaMenuController.selectedParentTab.value =
                        //     currentdealName;

                        stateController.setCurrentTab(2);
                      }),

                      // Text(
                      //   'View More',
                      //   style: TextStyles.headingFontBlue,
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                    height: 220,
                    child: ScoinProductCard(scoinController, context))
              ],
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }

  Widget ScoinProductCard(scoinController, context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: scoinController.sCoinProd.length,
          itemBuilder: (_, index) {
            ProductSummary dProduct = scoinController.sCoinProd[index];
            return SizedBox(
              width: 150,
              child: ProductCardScoin(
                fixedHeight: true,
                dProduct,
                dProduct.id,
                'SCOIN',
                dProduct.varient!.price,
                RuleConfig(),
                Constraint(),
              ),
            );
          },
        ),
      ),
    );
  }
}
