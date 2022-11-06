import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class WildCardPageController extends GetxController {
  Rx<Uri> uri = Uri().obs;

  WildCardPageController(Uri givenUri) {
    uri.value = givenUri;
  }
}
