import 'package:get/get.dart';

class ControllerGenerator {
  ControllerGenerator._();
  static create(GetxController controller, {String? tag}) {
    if (tag == null) {
      return Get.put(controller);
    } else if (Get.isRegistered(tag: tag)) {
      return Get.find(tag: tag);
    } else {
      return Get.put(controller, tag: tag);
    }
  }
}
