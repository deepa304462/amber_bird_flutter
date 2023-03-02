import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class ScoinProductController extends GetxController {
  RxList<ProductSummary> sCoinProd = <ProductSummary>[].obs;

  @override
  void onInit() {
    getProduct();
    super.onInit();
  }

  getProduct() async {
    var payload = {"onlyAvailableViaSCoins": true};
    var response = await ClientService.searchQuery(
        path: 'product/searchSummary', query: payload, lang: 'en');
    if (response.statusCode == 200) {
      List<ProductSummary> dList = ((response.data as List<dynamic>?)?.map((e) {
            ProductSummary productSummary =
                ProductSummary.fromMap(e as Map<String, dynamic>);
            // productSummary.varients.
            var list = productSummary.varients!
                .where((i) => i.scoinPurchaseEnable!)
                .toList();
            productSummary.varient = list[0]; 
            productSummary.varients = list; 
            return productSummary;
          }).toList() ??
          []);
      sCoinProd.value = (dList);
    }
  }
}
