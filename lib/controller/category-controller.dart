import 'dart:developer';

import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxList<ProductCategory> categoryList = <ProductCategory>[].obs; //RxList([]);
  RxList<ProductCategory> subCategoryList = <ProductCategory>[].obs;
  Rx<ProductCategory> selectedCatergory = ProductCategory().obs;
  Rx<ProductCategory> selectedSubCatergory = ProductCategory().obs;

  @override
  void onInit() {
    getCategory();
    super.onInit();
  }

  getCategory() async {
    var payload = {'': ''};
    var response = await ClientService.searchQuery(
        path: 'cache/productCategory/search', query: payload, lang: 'en');

    if (response.statusCode == 200) {
      List<ProductCategory> cList = ((response.data as List<dynamic>?)
              ?.map((e) => ProductCategory.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      categoryList.value = (cList);
      // print(categoryList);
    }
  }

  getSubCategory(catId) async {
    var payload = {"parentCategoryId": catId};
    var response = await ClientService.searchQuery(
        path: 'cache/productCategory/search', query: payload, lang: 'en');

    if (response.statusCode == 200) {
      List<ProductCategory> sList = ((response.data as List<dynamic>?)
              ?.map((e) => ProductCategory.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      subCategoryList.value = (sList);
    }
  }
}
