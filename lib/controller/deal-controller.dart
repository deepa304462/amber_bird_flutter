import 'dart:developer';

import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class DealController extends GetxController {
  RxList<DealProduct> dealProd = <DealProduct>[].obs;
  // Map<String, String> params = Get.arguments;

  final tag;

  DealController(this.tag);
  @override
  void onInit() {
    // print(params);
    print('111111${tag}');
    if (tag == dealName.FLASH) {
      getDealProduct('FLASH');
    }else if (tag == dealName.SALES) {
      getDealProduct('SALES');
    }

    super.onInit();
  }

  getDealProduct(name) async {
    var payload = {"type": name};
    var response = await ClientService.searchQuery(
        path: 'cache/dealProduct/search', query: payload, lang: 'en');

    if (response.statusCode == 200) {
      List<DealProduct> dList = ((response.data as List<dynamic>?)
              ?.map((e) => DealProduct.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      dealProd.value = (dList);
      print('deal${response.data}');
      // myController.setDealProd(dealProd);
    } else {
      inspect(response);
    }
  }
}
