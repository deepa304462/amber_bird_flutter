import 'package:amber_bird/data/brand/brand.dart';
import 'package:amber_bird/data/deal_product/product.dart';
import 'package:amber_bird/data/product_category/generic-tab.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class BrandController extends GetxController {
  RxString selectedBrandTab = ''.obs;
  RxList<GenericTab> brandList = <GenericTab>[].obs;
  RxList<ProductSummary> productList = <ProductSummary>[].obs;
RxBool isLoading = false.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    getBrand();
  }

  getBrand() async {
    var resp = await ClientService.get(
        path: 'multiProduct/categorySummary', id: selectedBrandTab.value);
    ((resp.data as List<dynamic>?)?.map((e) {
          Brand brand = Brand.fromMap(e as Map<String, dynamic>);
          brandList.add(GenericTab(
              id: brand.id,
              image: brand.logoId,
              text: brand.name,
              type: 'brand'));
        }).toList() ??
        []);

    // getAllProducts(subMenuList[0], parentTab);
  }

  Future<void> getAllProducts(GenericTab subMenu, GenericTab parentTab) async {
    var payload = {"brandId": selectedBrandTab.value};
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
      productList.value = dList;
    }
  }
}
