import 'dart:developer';

import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxList<ProductCategory> categoryList = <ProductCategory>[].obs; //RxList([]);
  RxList<ProductCategory> subCategoryList = <ProductCategory>[].obs;
  Rx<ProductCategory> selectedCatergory = ProductCategory().obs;
  Rx<ProductCategory> selectedSubCatergory = ProductCategory().obs;
  RxList<Product> productList = <Product>[].obs;
  RxBool isList = true.obs;
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
    if (selectedSubCatergory.value.id != '' && selectedSubCatergory.value.id != null) {
      payload = {
        "parentCategoryId": selectedCatergory.value.id ?? '',
        "productCategoryId": selectedSubCatergory.value.id ?? '',
      };
    } else if (selectedCatergory.value.id != ''  &&
        selectedCatergory.value.id != null) {
      payload = {
        "parentCategoryId": selectedCatergory.value.id ?? '',
      };
    }
    print(payload);
     // {"parentCategoryId": catId};
    var response = await ClientService.searchQuery(
        path: 'cache/product/search', query: payload, lang: 'en');

    if (response.statusCode == 200) {
      List<Product> pList = ((response.data as List<dynamic>?)
              ?.map((e) => Product.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      print(pList);
      inspect(pList);
      productList.value = (pList);
    }else{
      print(response);
    }
  }
}
