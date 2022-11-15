import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class BrandProductPageController extends GetxController {
  final String brandId;
  Rx<Brand> brand = Brand().obs;
  RxList<ProductSummary> productList = <ProductSummary>[].obs;
  Rx<bool> isLoading = true.obs;
  BrandProductPageController(this.brandId);

  @override
  void onInit() {
    getBrand();
    super.onInit();
  }

  void getBrand() {
    isLoading.value = true;
    ClientService.get(path: 'brand', id: '$brandId?locale=en').then((value) {
      brand.value = Brand.fromMap(value.data);
      searchProducts();
    });
  }

  void searchProducts() {
    ClientService.searchQuery(
            path: 'cache/product/searchSummary',
            query: {'brandId': brandId},
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
