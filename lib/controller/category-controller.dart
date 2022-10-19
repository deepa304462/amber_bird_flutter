import 'dart:developer';

import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxList<ProductCategory> mainTabs = <ProductCategory>[].obs; //RxList([]);
  RxList<ProductCategory> subCategoryList = <ProductCategory>[].obs;
  RxString selectedCatergory = "".obs;
  RxString selectedSubCatergory = "all".obs;
  RxList<ProductSummary> productList = <ProductSummary>[].obs;

  RxBool isList = true.obs;
  @override
  void onInit() {
    getProductList();
    getCategory();
    super.onInit();
  }

  getCategory() async {
    var payload = {'onlyParentCategories': true};
    var response = await ClientService.searchQuery(
        path: 'cache/productCategory/search', query: payload, lang: 'en');

    if (response.statusCode == 200) {
      List<ProductCategory> cList = ((response.data as List<dynamic>?)
              ?.map((e) => ProductCategory.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      mainTabs.value = (cList);

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

  getProductList() async {
    var payload = {
      // "productCategoryId": selectedSubCatergory.value.id,
      // "parentCategoryId": selectedCatergory.value.id,
      // "brandId": "string",
      // "keywords": "string"
      "": ""
    };
    if (selectedSubCatergory.value != '' &&
        selectedSubCatergory.value != 'all') {
      payload = {
        // "parentCategoryId": selectedCatergory.value.id ?? '',
        "productCategoryId": selectedSubCatergory.value  ,
      };
    } else if (selectedCatergory.value != '') {
      payload = {
        "parentCategoryId": selectedCatergory.value ,
      };
    }
     // {"parentCategoryId": catId};
    var response = await ClientService.searchQuery(
        path: 'cache/product/searchSummary', query: payload, lang: 'en');

    if (response.statusCode == 200) {
      List<ProductSummary> pList = ((response.data as List<dynamic>?)
              ?.map((e) => ProductSummary.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      
      productList.value = (pList);
    } else {
      print(response);
    }
  }
}
