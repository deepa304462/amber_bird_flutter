import 'dart:developer';

import 'package:amber_bird/data/product_guide/product_guide.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class ProductGuideController extends GetxController {
  RxList<ProductGuide> productGuides = <ProductGuide>[].obs;

  @override
  void onInit() {
    print('fetch product guide');
    ClientService.post(path: 'productGuide/search?locale=en', payload: {})
        .then((value) {
      (value.data as List).forEach((element) {
        productGuides.add(ProductGuide.fromMap(element));
      });
    });
    super.onInit();
  }
}
