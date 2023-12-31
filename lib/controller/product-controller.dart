import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/deal_product/varient.dart';
import 'package:amber_bird/data/product/product.dart';
import 'package:amber_bird/helpers/helper.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  Rx<Product> product = Product().obs;
  var activeIndexVariant = 0.obs;
  final tag;
  Rx<Varient> varient = Varient().obs;
  RxMap offerShipping = {}.obs;
  RxString shortLink = ''.obs;
  RxList<ProductSummary> recommendedProd = <ProductSummary>[].obs;

  ProductController(this.tag);
  @override
  void onInit() {
    getProduct(tag);
    getofferShipping();
    getRecommendedProd();
    getShortCode(tag);
    super.onInit();
  }

  getShortCode(id) async {
    var response =
        await ClientService.get(path: 'shortLink', id: '$id?locale=en');
    if (response.statusCode == 200) {
      shortLink.value = response.data['shortUrl'];
    }
  }

  getofferShipping() async {
    try {
      offerShipping.value = await Helper.getOfferedShipping();
    } catch (err) {
      offerShipping.value = {'amountRequired': 0, 'offeredShipping': 4.99};
    }
    offerShipping.refresh();
  }

  getProduct(String id) async {
    var response =
        await ClientService.get(path: 'cache/product', id: '$id?locale=en');
    if (response.statusCode == 200) {
      Product prod = Product.fromMap(response.data as Map<String, dynamic>);
      product.value = prod;
      varient.value = prod.varients![0];
      if (product.value.defaultVarientCode != null) {
        final index1 = product.value.varients!.indexWhere((element) =>
            element.varientCode == product.value.defaultVarientCode);
        if (index1 != -1) {
          activeIndexVariant.value = index1;
        }
      }
    }
  }

  setVarient(Varient value) {
    varient.value = value;
  }

  getRecommendedProd() async {
    var response = await ClientService.post(
        path: 'productInventory/getRecommendedAvailableProducts',
        payload: {'productId': tag});
    if (response.statusCode == 200) {
      List<ProductSummary> pList = ((response.data as List<dynamic>?)
              ?.map((e) => ProductSummary.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      recommendedProd.value = pList;
      // Product prod = Product.fromMap(response.data as Map<String, dynamic>);
    }
  }
}
