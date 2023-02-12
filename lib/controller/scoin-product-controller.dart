import 'dart:convert';

import 'package:amber_bird/controller/multi-product-controller.dart';
import 'package:amber_bird/data/customer_insight/customer_insight.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:get/get.dart';

class ScoinProductController extends GetxController {
  RxList<ProductSummary> sCoinProd = <ProductSummary>[].obs;

  @override
  void onInit() {
    getProduct();
    super.onInit();
  }

  getProduct() async {
    var payload = {"onlyAvailableViaSCoins": true};
    var response = await ClientService.searchQuery(
        path: 'product/searchSummary', query: payload, lang: 'en');
    if (response.statusCode == 200) {
      List<ProductSummary> dList = ((response.data as List<dynamic>?)
              ?.map((e) => ProductSummary.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      sCoinProd.value = (dList);
    }
  }
}
