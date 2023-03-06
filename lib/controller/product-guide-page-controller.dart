import 'package:amber_bird/data/product_guide/product_guide.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class ProductGuidePageController extends GetxController {
  Rx<ProductGuide> productGuide = ProductGuide().obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void setPrductGuideId(String productGuideId) {
    ClientService.get(path: 'productGuide/${productGuideId}?locale=en', id: '')
        .then((value) {
      productGuide.value = ProductGuide.fromMap(value.data);
      isLoading.value = false;
    });
  }
}
