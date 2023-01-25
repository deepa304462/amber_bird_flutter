import 'dart:convert';

import 'package:amber_bird/data/customer_insight/customer_insight.dart';
import 'package:amber_bird/data/deal_product/constraint.dart';
import 'package:amber_bird/data/deal_product/rule_config.dart';
import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:amber_bird/utils/offline-db.service.dart';
import 'package:get/get.dart';

class MultiProductController extends GetxController {
  RxList<Multi> multiProd = <Multi>[].obs;

  final tag;

  MultiProductController(this.tag);
  @override
  void onInit() {
    if (tag == multiProductName.COMBO.name) {
      getmultiProductProduct('COMBO');
    }
    if (tag == multiProductName.BUNDLE.name) {
      getmultiProductProduct('BUNDLE');
    }
    if (tag == multiProductName.COLLECTION) {
      getmultiProductProduct('COLLECTION');
    } else if (tag == dealName.SALES.name) {
      getmultiProductProduct('SALES');
    }

    super.onInit();
  }

  getmultiProductProduct(key) async {
    var payload = {"type": key};
    var response = await ClientService.searchQuery(
        path: 'cache/multiProduct/search', query: payload, lang: 'en');
    if (response.statusCode == 200) {
      List<Multi> dList = ((response.data as List<dynamic>?)
              ?.map((e) => Multi.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      multiProd.value = (dList);
    }
  }

  getProductName(name) {
    if (multiProductName.COMBO.name == name) {
      return "Combo Deal";
    } else if (multiProductName.BUNDLE.name == name) {
      return "Bundle Deal";
    } else if (multiProductName.COLLECTION.name == name) {
      return "Collections";
    } else {
      return "Flash Deal";
    }
  }

  checkValidDeal(String id, String type,String cartId) async {
    RuleConfig? ruleConfig;
    Constraint? constraint;
    List outputList = multiProd.value.where((o) => o.id == id).toList();

    Multi multiProduct = outputList[0];
    ruleConfig = RuleConfig();
    constraint = multiProduct.constraint;

    // DealProduct();
    var insight = await OfflineDBService.get(OfflineDBService.customerInsight);
    CustomerInsight custInsight = CustomerInsight.fromJson(jsonEncode(insight));
    if (type == 'positive') {
      dynamic data =
          await Helper.checkProductValidtoAddinCart(ruleConfig, constraint, id,cartId);
      return data;
    } else {
      return ({'error': false, 'msg': ''});
    }
  }
}
