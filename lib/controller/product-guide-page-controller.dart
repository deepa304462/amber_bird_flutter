import 'package:amber_bird/data/product_guide/product_guide.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProductGuidePageController extends GetxController {
  Rx<ProductGuide> productGuide = ProductGuide().obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    print('ok');
    ClientService.post(path: 'productGuide/search?locale=en', payload: {})
        .then((value) {
      (value.data as List).forEach((element) {
        productGuide.value = ProductGuide.fromMap(element);
        isLoading.value = false;
      });
    });
    super.onInit();
  }
}
