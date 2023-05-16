import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class TagController extends GetxController {
  RxList<ProductSummary> productList = <ProductSummary>[].obs;
  var activeIndexVariant = 0.obs;
  final tag;
  Rx<Varient> varient = Varient().obs;
  RxMap offerShipping = {}.obs;
  RxString shortLink = ''.obs;

  TagController(this.tag);
  @override
  void onInit() {
    getTagProduct();
  }

  getTagProduct() async {
     var payload = {'keywords': Uri.decodeComponent(tag)};

    var responseProd = await ClientService.searchQuery(
        path: 'product/searchSummary', query: payload, lang: 'en');
    // var responseProd = await ClientService.post(
    //     path: 'product/searchSummary', payload: {'keywords': tag});
    if (responseProd.statusCode == 200) {
      List<ProductSummary> summaryProdList = ((responseProd.data
                  as List<dynamic>?)
              ?.map((e) => ProductSummary.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);

      productList.value = summaryProdList;
    }
  }
}
