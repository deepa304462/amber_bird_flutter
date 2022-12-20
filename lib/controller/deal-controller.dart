import 'package:amber_bird/controller/cart-controller.dart';
import 'package:amber_bird/data/deal_product/deal_product.dart';
import 'package:amber_bird/services/client-service.dart';
import 'package:get/get.dart';

class DealController extends GetxController {
  RxList<DealProduct> dealProd = <DealProduct>[].obs;

  final tag;

  DealController(this.tag);
  @override
  void onInit() {
    if (tag == dealName.FLASH) {
      getDealProduct('FLASH');
    } else if (tag == dealName.SALES) {
      getDealProduct('SALES');
    }

    super.onInit();
  }

  String getDealName(name) {
    if (dealName.FLASH == name) {
      return "Flash Deal";
    } else if (dealName.SALES == name) {
      return "Sales Deal";
    } else {
      return "Flash Deal";
    }
  }

  getDealProduct(name) async {
    var payload = {"type": name};
    var response = await ClientService.searchQuery(
        path: 'dealProduct/search', query: payload, lang: 'en');
    if (response.statusCode == 200) {
      List<DealProduct> dList = ((response.data as List<dynamic>?)
              ?.map((e) => DealProduct.fromMap(e as Map<String, dynamic>))
              .toList() ??
          []);
      dealProd.value = (dList);
    }
  }

  checkValidDeal(DealProduct dealProduct) {
    if (dealProduct.ruleConfig != null) {
      if (dealProduct.ruleConfig!.minCartAmount != null &&
          dealProduct.ruleConfig!.minCartAmount != 0) {
        if (Get.isRegistered<CartController>()) {
          var cartController = Get.find<CartController>();
          if (cartController.calculatedPayment.value.totalAmount <
              dealProduct.ruleConfig!.minCartAmount) {
            return ({
              'error': true,
              'msg':
                  'Required min cart amount ${dealProduct.ruleConfig!.minCartAmount}'
            });
          }
        }
      }
    }
  }
}
