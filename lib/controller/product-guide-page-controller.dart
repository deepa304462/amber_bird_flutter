import 'package:amber_bird/data/product_guide/product_guide.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class ProductGuidePageController extends GetxController {
  Rx<ProductGuide> productGuide = ProductGuide().obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() { 
    ClientService.post(path: 'productGuide/search?locale=en', payload: {})
        .then((value) {
      for (var element in (value.data as List)) {
        productGuide.value = ProductGuide.fromMap(element);
        isLoading.value = false;
      }
    });
    super.onInit();
  }
}
