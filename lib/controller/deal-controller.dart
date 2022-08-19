import 'dart:developer';

import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class DealController extends GetxController {
  RxList<DealProduct> dealProd = <DealProduct>[].obs;

  final tag;

  DealController(this.tag);
  @override
  void onInit() {
    if (tag == dealName.FLASH) {
      getDealProduct('FLASH');
    } else if (tag == dealName.SALES) {
      getDealProduct('SALES');
    }

    super.onInit();
  }

  String getDealName(name) {
    if (dealName.FLASH == name) {
      return "Flash Deal";
    } else if (dealName.SALES == name) {
      return "Sales Deal";
    } else {
      return "Flash Deal";
    }
  }

  getDealProduct(name) async {
    var payload = {"type": name};
    var response = await ClientService.searchQuery(
        path: 'cache/dealProduct/search', query: payload, lang: 'en');
     inspect(response.data);
    if (response.statusCode == 200) {
      List<DealProduct> dList = ((response.data as List<dynamic>?)
              ?.map((e) => DealProduct.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      dealProd.value = (dList);
    } else {
      inspect(response);
    }
  }
}
