import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/controller/faq-controller.dart';
import 'package:amber_bird/controller/product-guide-row-controller.dart';
import 'package:amber_bird/controller/product-tag-controller.dart';
import 'package:amber_bird/controller/state-controller.dart';
import 'package:get/get.dart';

import '../controller/mega-menu-controller.dart';
import '../controller/product-guide-page-controller.dart';

class ControllerGenerator {
  ControllerGenerator._();
  static create(GetxController controller, {String? tag}) {
    if (tag == null) {
      // if (Get.isRegistered<controller>()) {
      // return Get.find<controller>();
      // }else{
      return Get.put(controller);
      // }
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
        if (tag == 'productGuideController') {
          var controllerOld = Get.find<ProductGuideController>(tag: tag);
          return controllerOld;
        }
        if (tag == 'faqController') {
          var controllerOld = Get.find<FaqController>(tag: tag);
          return controllerOld;
        }
        if (tag == 'Controller') {
          var controllerOld = Get.find<Controller>(tag: tag);
          return controllerOld;
        }
        if (tag == 'megaMenuController') {
          var controllerOld = Get.find<MegaMenuController>(tag: tag);
          return controllerOld;
        }
        return controller = Get.find(tag: tag);
      } catch (e) {
        if (tag == 'cartController') {
          return Get.put(CartController(), tag: tag);
        }
        if (tag == 'productGuideController') {
          return Get.put(ProductGuideController(), tag: tag);
        }
        if (tag == 'productGuidePageController') {
          return Get.put(ProductGuidePageController(), tag: tag);
        }
        if (tag == 'productTagController') {
          return Get.put(ProductTagController(), tag: tag);
        }
        if (tag == 'productTagController') {
          return Get.put(ProductTagController(), tag: tag);
        }
        if (tag == 'faqController') {
          return Get.put(FaqController(), tag: tag);
        }
        if (tag == 'Controller') {
          var controllerOld = Get.put<Controller>(Controller());
          return controllerOld;
        }
        if (tag == 'megaMenuController') {
          return Get.put(MegaMenuController(), tag: tag);
        }
        return Get.put(controller, tag: tag);
      }
    }
  }
}
