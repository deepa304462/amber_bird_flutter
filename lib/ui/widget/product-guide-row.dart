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
  late Controller stateController;
  late ProductGuideController productGuideController;
  ProductGuideRow({Key? key}) : super(key: key) {
    stateController = Get.find();
    productGuideController = ControllerGenerator.create(
        ProductGuideController(),
        tag: 'productGuideController'); //Get.put(ProductGuideController());
  }

  @override
  Widget build(BuildContext context) {
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
                  'V Care',
                  style: TextStyles.headingFont,
                ),
                ViewMoreWidget(onTap: () async {
                  MegaMenuController megaMenuController =
                      ControllerGenerator.create(MegaMenuController(),
                          tag: 'megaMenuController');
                  megaMenuController.selectedParentTab.value = 'MULTI';
                  GenericTab parentTab = GenericTab(
                      image: '34038fcf-20e1-4840-a188-413b83d72e11',
                      id: 'MULTI',
                      type: 'MULTI',
                      text: 'Multi');
                  await megaMenuController.getSubMenu(parentTab);
                  megaMenuController.selectedSubMenu.value = 'THEMES';
                  megaMenuController.getAllProducts(
                      GenericTab(
                          image: '34038fcf-20e1-4840-a188-413b83d72e11',
                          id: 'THEMES',
                          type: 'MULTI',
                          text: 'V Care'),
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
            child: Obx(() {
              if (productGuideController.productGuides.isNotEmpty) {
                productGuideController.productGuides.shuffle();
              }
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: productGuideController.productGuides
                    .map((e) => ProductGuideCard(e))
                    .toList(),
              );
            }),
          ),
        ],
      ),
    );
  }
}
