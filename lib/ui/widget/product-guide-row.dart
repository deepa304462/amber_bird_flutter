import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/product-guide-row-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/ui/widget/product-guide-card.dart';
import 'package:amber_bird/ui/widget/view-more-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductGuideRow extends StatelessWidget {
  const ProductGuideRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Controller stateController = Get.find();
    ProductGuideController productGuideController =
        Get.put(ProductGuideController());
    if (productGuideController.productGuides.isNotEmpty) {
      productGuideController.productGuides.shuffle();
    }
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Themes',
                  style: TextStyles.headingFont,
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
                  await megaMenuController.getSubMenu(parentTab);
                  megaMenuController.selectedSubMenu.value = 'THEMES';
                  megaMenuController.getAllProducts(
                      GenericTab(
                          image: '34038fcf-20e1-4840-a188-413b83d72e11',
                          id: 'THEMES',
                          type: 'DEAL',
                          text: 'Themes'),
                      parentTab);

                  stateController.setCurrentTab(1);
                }),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: Obx(
              () => ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: productGuideController.productGuides
                    .map((e) => ProductGuideCard(e))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
