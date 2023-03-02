import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class BrandPageController extends GetxController {
  RxList<Brand> brands = <Brand>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    _saerchBrands();
    super.onInit();
  }

  void _saerchBrands() {
    ClientService.searchQuery(path: 'brand/search', query: {}, lang: 'en')
        .then((value) {
      brands.value = (value.data as List).map((e) => Brand.fromMap(e)).toList();
    });
  }
}
