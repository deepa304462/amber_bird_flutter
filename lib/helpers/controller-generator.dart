import 'package:amber_bird/controller/cart-controller.dart';
import 'package:get/get.dart';

import '../controller/product-guide-page-controller.dart';

class ControllerGenerator {
  ControllerGenerator._();
  static create(GetxController controller, {String? tag}) {
    if (tag == null) {
      return Get.put(controller);
    } else {
      try {
        if (tag == 'cartController') {
          var controllerOld = Get.find<CartController>(tag: tag);
          return controllerOld;
        }
        if (tag == 'productGuidePageController') {
          var controllerOld = Get.find<ProductGuidePageController>(tag: tag);
          return controllerOld;
        }
        return controller = Get.find(tag: tag);
      } catch (e) {
        if (tag == 'cartController') {
          return Get.put(CartController(), tag: tag);
        }
        if (tag == 'productGuidePageController') {
          return Get.put(ProductGuidePageController(), tag: tag);
        }
        return Get.put(controller, tag: tag);
      }
    }
  }
}
