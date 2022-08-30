import 'dart:developer';

import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  Rx<Product> product = Product().obs;
  var activeIndexVariant = 0.obs;
  final tag;

  ProductController(this.tag);
  @override
  void onInit() {
    getProduct(tag);
    super.onInit();
  }

  getProduct(String id) async {
    var payload = {"id": id};
    var response = await ClientService.searchQuery(
        path: 'cache/product/$id', query: payload, lang: 'en');
    inspect(response);
    if (response.statusCode == 200) {
      Product prod = Product.fromMap(response.data as Map<String, dynamic>);
      product.value = (prod);
      if (product.value.defaultVarientCode != null) {
        final index1 = product.value.varients!.indexWhere((element) =>
            element.varientCode == product.value.defaultVarientCode);
        if (index1 != -1) {
          activeIndexVariant.value = index1;
          print("Index $index1: ${product.value.varients![index1]}");
        }
      }
    }
  }
}
