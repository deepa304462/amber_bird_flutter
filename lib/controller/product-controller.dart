import 'package:amber_bird/data/deal_product/product.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  RxList<ProductSummary> productList = <ProductSummary>[].obs;

  @override
  void onInit() { 
    super.onInit();
  }
}