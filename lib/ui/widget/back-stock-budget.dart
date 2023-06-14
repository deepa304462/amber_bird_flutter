import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/ui/widget/product-card.dart';
import 'package:amber_bird/utils/ui-style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackInStockProductWidget extends StatelessWidget {
  RxList<ProductSummary> productList = <ProductSummary>[].obs;

  getSearchProd() async {
    var payload = {'backInStock': true};

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
                  productSummary.varients = list;
                  return productSummary;
                } else {
                  return ProductSummary();
                }
              }).toList() ??
              []);

      productList.value = summaryProdList;
    }
  }

  @override
  Widget build(BuildContext context) {
    getSearchProd();
    return Obx(() => productList.isNotEmpty
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
                          'Re-Stocked',
                          style: TextStyles.headingFont,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productList.length,
                        itemBuilder: (_, index) {
                          ProductSummary productSummary = productList[index];
                          return SizedBox(
                            width: 150,
                            child: Stack(
                              children: [
                                ProductCard(
                                    fixedHeight: true,
                                    productSummary,
                                    productSummary.id,
                                    'CENTS',
                                    productSummary.varient!.price!,
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
