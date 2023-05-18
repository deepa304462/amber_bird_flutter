import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/data/category/category.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class BrandProductPageController extends GetxController {
  String brandId = '';
  Rx<Brand> brand = Brand().obs;
  RxList<ProductSummary> productList = <ProductSummary>[].obs;
  RxList<Category> categoryList = <Category>[].obs;
  Rx<bool> isLoading = true.obs;
  RxString selectedCategory = ''.obs;

  setBrandId(String givenBrandId) {
    brandId = givenBrandId;
    productList.clear();
    brand.value = Brand();
    selectedCategory.value = '';
    getBrand();
  }

  void getBrand() {
    isLoading.value = true;
    ClientService.get(path: 'brand', id: '$brandId?locale=en').then((value) {
      brand.value = Brand.fromMap(value.data);
      getCategory();
    });
  }

  void getCategory() {
    isLoading.value = true;
    ClientService.get(
            path: 'product/getBrandRelatedCategories', id: '$brandId?locale=en')
        .then((value) {
      List<Category> list = ((value.data as List<dynamic>?)
              ?.map((e) => Category.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);

      categoryList.value = list;
      if (categoryList.length > 0) {
        selectedCategory.value = categoryList[0].id!;
      }
      searchProducts();
    });
  }

  void searchProducts() {
    ClientService.searchQuery(
            path: 'cache/product/searchSummary',
            query: {
              'brandId': brandId,
              'productCategoryId': selectedCategory.value
            },
            lang: 'en')
        .then((value) {
      List<ProductSummary> pList = ((value.data as List<dynamic>?)
              ?.map((e) => ProductSummary.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      productList.value = (pList);
      isLoading.value = false;
    });
  }
}
