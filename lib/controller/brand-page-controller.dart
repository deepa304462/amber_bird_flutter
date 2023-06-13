import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class BrandPageController extends GetxController {
  RxList<Brand> brands = <Brand>[].obs;
  RxBool isLoading = true.obs;
  @override
  void onInit() {
    _saerchBrands();
    super.onInit();
  }

  void _saerchBrands() {
    isLoading.value = true;
    ClientService.searchQuery(path: 'cache/brand/search', query: {}, lang: 'en')
        .then((value) {
      brands.value = (value.data as List).map((e) => Brand.fromMap(e)).toList();
      isLoading.value = false;
    });
  }
}
