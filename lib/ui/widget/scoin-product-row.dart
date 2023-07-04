import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/scoin-product-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/controller/wishlist-controller.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/product-card-scoin.dart';
import 'package:amber_bird/ui/widget/view-more-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/controller-generator.dart';

class ScoinProductRow extends StatelessWidget {
  bool isLoading = false;
  final Controller stateController = Get.find();
  final CartController cartController =
      ControllerGenerator.create(CartController(), tag: 'cartController');
  final WishlistController wishlistController = Get.find();
  Rx<Varient> activeVariant = Varient().obs;
  ScoinProductRow({super.key});

  @override
  Widget build(BuildContext context) {
    final ScoinProductController scoinController =
        Get.put(ScoinProductController());
    if (scoinController.sCoinProd.isNotEmpty) {
      scoinController.sCoinProd.shuffle();
    }
    return Obx(() {
      if (scoinController.sCoinProd.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 5),
          child: Container(
            // color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyles.body,
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Redeem',
                              style: TextStyles.headingFont
                                  .copyWith(color: AppColors.primeColor),
                            ),
                            TextSpan(
                              text: ' S-Coins',
                              style: TextStyles.headingFont,
                            ),
                          ],
                        ),
                      ),
                      ViewMoreWidget(onTap: () async {
                        MegaMenuController megaMenuController =
                            ControllerGenerator.create(MegaMenuController(),
                                tag: 'megaMenuController');
                        megaMenuController.selectedParentTab.value = 'DEAL';
                        GenericTab parentTab = GenericTab(
                            image: '34038fcf-20e1-4840-a188-413b83d72e11',
                            id: 'DEAL',
                            type: 'DEAL',
                            text: 'Deal');
                        await megaMenuController.getSubMenu(parentTab,
                            loadProd: false);
                        megaMenuController.selectedSubMenu.value =
                            dealName.ONLY_COIN_DEAL.name;
                        megaMenuController.getAllProducts(
                            GenericTab(
                                image: '34038fcf-20e1-4840-a188-413b83d72e11',
                                id: dealName.ONLY_COIN_DEAL.name,
                                type: 'DEAL',
                                text: 'Redeem'),
                            parentTab);
                        stateController.setCurrentTab(1);
                      }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 180,
                  child: ScoinProductCard(scoinController, context),
                )
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
