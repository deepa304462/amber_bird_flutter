import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:get/get.dart';

class DealController extends GetxController {
    Map<String, List<DealProduct>?> dealProd =   Map().obs;
  // .obs;
  @override
  void onInit() {
    getDealProduct();
    super.onInit();
  }

  getDealProduct(){
     var payload = {"type": widget.CurrentdealName};
    var response = await ClientService.searchQuery(
        path: 'cache/dealProduct/search', query: payload, lang: 'en');

    if (response.statusCode == 200) {
      print(response.data);
      dealProd = RxList((response.data as List<dynamic>?)
              ?.map((e) => DealProduct.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      myController.setDealProd(dealProd);
    } else {
      inspect(response);
    }
  }
}
