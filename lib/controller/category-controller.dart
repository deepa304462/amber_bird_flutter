import 'dart:developer';

import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxList<ProductCategory> categoryList = <ProductCategory>[].obs; //RxList([]);
  RxList<ProductCategory> subCategoryList = <ProductCategory>[].obs;
  Rx<ProductCategory> selectedCatergory = ProductCategory().obs;
  Rx<ProductCategory> selectedSubCatergory = ProductCategory().obs;
  RxList<ProductSummary> productList = <ProductSummary>[].obs;

  @override
  void onInit() {
    getProductList();
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
      getProductList();
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
      getProductList();
    }
  }

  getProductList() async {
    var payload = { 
      // "productCategoryId": selectedCatergory.value.id,
      // "parentCategoryId": selectedCatergory.value.id,
      // "brandId": "string",
      // "keywords": "string"
      "":""
    };
    print(payload);
    // {"parentCategoryId": catId};
    var response = await ClientService.searchQuery(
        path: 'cache/product/search', query: payload, lang: 'en');

    if (response.statusCode == 200) {
      List<ProductSummary> pList = ((response.data as List<dynamic>?)
              ?.map((e) => ProductSummary.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      print(pList);
      inspect(pList);
      productList.value = (pList);
    }
  }
}
