import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/product_category/product_category.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class CategoryProductPageController extends GetxController {
  final String categoryId;
  Rx<ProductCategory> category = ProductCategory().obs;
  RxList<ProductSummary> productList = <ProductSummary>[].obs;
  Rx<bool> isLoading = true.obs;
  CategoryProductPageController(this.categoryId);

  @override
  void onInit() {
    getCategory();
    super.onInit();
  }

  void getCategory() {
    isLoading.value = true;
    ClientService.get(path: 'productCategory', id: '$categoryId?locale=en')
        .then((value) {
      category.value = ProductCategory.fromMap(value.data);
      searchProducts();
    });
  }

  void searchProducts() {
    ClientService.searchQuery(
            path: 'cache/product/searchSummary',
            query: {'parentCategoryId': categoryId},
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
