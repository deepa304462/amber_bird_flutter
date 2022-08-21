import 'package:amber_bird/data/multi/multi.product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class MultiProductController extends GetxController {
  RxList<Multi> dealProd = <Multi>[].obs;

  final tag;

  MultiProductController(this.tag);
  @override
  void onInit() {
    // if (tag == dealName.FLASH) {
    //   getDealProduct('FLASH');
    // } else if (tag == dealName.SALES) {
    //   getDealProduct('SALES');
    // }

    super.onInit();
  }
}