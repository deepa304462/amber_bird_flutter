import 'package:amber_bird/controller/mega-menu-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/helpers/controller-generator.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/ui/widget/view-more-widget.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CentProductWidget extends StatelessWidget {
  RxList<ProductSummary> centProductList = <ProductSummary>[].obs;
  final Controller stateController = Get.find();
  getSearchProd() async {
    var payload = {'lessThanOneEuroProducts': true};

    var response = await ClientService.searchQuery(
        path: 'product/searchSummary', query: payload, lang: 'en');
    if (response.statusCode == 200) {
      List<ProductSummary> summaryProdList =
          ((response.data as List<dynamic>?)?.map((e) {
                ProductSummary productSummary =
                    ProductSummary.fromMap(e as Map<String, dynamic>);
                var list = productSummary.varients!.where((i) {
                  if (i.price!.offerPrice! < 1.00) {
                    return true;
                  }
                  return false;
                }).toList();
                if (list.length > 0) {
                  productSummary.varient = list[0];
                  productSummary.varients = [list[0]];
                  //list;
                  return productSummary;
                } else {
                  return ProductSummary();
                }
              }).toList() ??
              []);

      centProductList.value = summaryProdList;
    }
  }

  @override
  Widget build(BuildContext context) {
    getSearchProd();
    return Obx(() => centProductList.isNotEmpty
        ? Padding(
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
                          'Cents',
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
                          megaMenuController.selectedSubMenu.value = 'CENTS';
                          megaMenuController.getAllProducts(
                              GenericTab(
                                  image: '34038fcf-20e1-4840-a188-413b83d72e11',
                                  id: 'CENTS',
                                  type: 'DEAL',
                                  text: 'Cents'),
                              parentTab);

                          stateController.setCurrentTab(1);
                        }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: centProductList.length > 15
                            ? 15
                            : centProductList.length,
                        itemBuilder: (_, index) {
                          ProductSummary productSummary =
                              centProductList[index];
                          return SizedBox(
                            width: 150,
                            child: Stack(
                              children: [
                                ProductCard(
                                    fixedHeight: true,
                                    productSummary,
                                    productSummary.id,
                                    'CENTS',
                                    productSummary.varient!.price,
                                    null,
                                    null),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : const SizedBox());
  }
}
